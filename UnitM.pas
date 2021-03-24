unit UnitM;

interface

uses
  ClipBrd,
  IdBaseComponent,
  IdComponent,
  IdDNSResolver,
  IdHTTP,
  IdIOHandler,
  IdIOHandlerSocket,
  IdIOHandlerStack,
  IdSSL,
  IdSSLOpenSSL,
  IdTCPClient,
  IdTCPConnection,
  MMSystem,
  System.Classes,
  System.ImageList,
  System.RegularExpressions,
  System.SysUtils,
  System.Variants,
  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.Graphics,
  Vcl.ImgList,
  Vcl.Menus,
  Vcl.StdCtrls,
  Winapi.Messages,
  Winapi.Windows;

const
  MAX_POST_IDS = 10000;
  DEFAULT_ICON_INDEX = 0;
  ACTIVE_ICON_INDEX = 1;

type
  TFormMain = class(TForm)
    TrayIcon: TTrayIcon;
    ImageListTray: TImageList;
    PopupMenuTray: TPopupMenu;
    menuQuit: TMenuItem;
    IdHTTP: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    MemoResult: TMemo;
    LabeledEditWrongPost: TLabeledEdit;
    LabeledEditError: TLabeledEdit;
    LabeledEditSuccess: TLabeledEdit;
    LabeledEditSkip: TLabeledEdit;
    menuShowMainFormDebug: TMenuItem;
    LabelPostResults: TLabel;
    IdDNSResolver: TIdDNSResolver;
    procedure menuQuitClick(Sender: TObject);
    procedure menuShowMainFormDebugClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    postIds: Array[0..MAX_POST_IDS] of Integer;
    postIdCount: Integer;
    zkillboardIp: String;

    // https://delphisources.ru/pages/faq/base/clipbrd_chg_notify.html
    FNextClipboardViewer: HWND;
    procedure WMChangeCBChain(var Msg : TWMChangeCBChain); message WM_CHANGECBCHAIN;
    procedure WMDrawClipboard(var Msg : TWMDrawClipboard); message WM_DRAWCLIPBOARD;
  public
    { Public declarations }
    function GetClipboardText(): String;
    procedure ClipboardChange();
    procedure RemeberKillmailId(idString: String);
    function IsPostedKillmailId(idString: String): Boolean;
    procedure Post(id, hash: String);
    procedure Explode(var a: Array of String; Border, S: String);
    procedure OnSocketAllocated(Sender: TObject);
    procedure ResolveZkillboard();
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

function TFormMain.GetClipboardText(): String;
const
  MAX_RETRY_COUNT = 3;
var
  RetryCount : Integer;
  Success: Boolean;
begin
  Result := '';
  RetryCount := 0;
  Success := False;

  while not Success do
  try
    // Clipboard can be locked
    Result := Clipboard.AsText;
    Success := True;
  except
    on Exception do begin
      Inc(RetryCount);
      if RetryCount <= MAX_RETRY_COUNT then begin
        Sleep(RetryCount * 100)
      end else begin
        raise Exception.Create('GetClipboardText failed');
      end;
    end;
  end;
end;

procedure TFormMain.RemeberKillmailId(idString: String);
var
  id: Integer;
begin
  try
    id := StrToInt(idString);
  finally

  end;

  // Reset
  if (postIdCount = MAX_POST_IDS - 1) then begin
    postIdCount := 0;
  end;

  postIdCount := postIdCount + 1;
  postIds[postIdCount - 1] := id;
end;

function TFormMain.IsPostedKillmailId(idString: String): Boolean;
var
  i, id: Integer;
begin
  Result := False;

  try
    id := StrToInt(idString);
  finally

  end;

  for i := 0 to postIdCount - 1 do begin
    if (postIds[i] = id) then begin
      Result := True;
      Exit;
    end;
  end;
end;

procedure TFormMain.menuQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.menuShowMainFormDebugClick(Sender: TObject);
begin
  menuShowMainFormDebug.Checked := not menuShowMainFormDebug.Checked;

  Visible := menuShowMainFormDebug.Checked;
end;

procedure TFormMain.ClipboardChange();
(*
Examples:
<url=killReport:91650826:2876d8ccc7f479c6a73b7b9e80d2dfc4b538d090>Kill: Mr Antisocial (Stiletto)</url>
https://esi.evetech.net/v1/killmails/91650392/0ef7394f0d770d96567063fbda8d6612437a1c10/?datasource=tranquility
*)
const
  Pattern = '(<url=killReport:\d+:[0-9a-fA-F]{40}>|killmails/\d+/[0-9a-fA-F]{40}/)';
var
  j: Integer;
  RegEx: TRegEx;
  Matches: TMatchCollection;
  Match, id, hash: String;
  explodedString: array of String;
  clipboardText: String;
begin
  SetLength(explodedString, 10);
  RegEx := TRegEx.Create(Pattern);

  clipboardText := '';
  try
    clipboardText := GetClipboardText();
  except
    sndPlaySound('error.wav', SND_NODEFAULT Or SND_ASYNC);
  end;

  Matches := RegEx.Matches(clipboardText);
  for j := 0 to Matches.Count - 1 do begin
    Match := Matches.Item[j].Value;

    id := '';
    hash := '';

    if (Match[1] = '<') then begin
      Explode(explodedString, ':', Match);
      id := explodedString[1];
      hash := Copy(explodedString[2], 1, Length(explodedString[2]) - 1);
    end
    else if (Match[1] = 'k') then begin
      Explode(explodedString, '/', Match);
      id := explodedString[1];
      hash := explodedString[2];
    end;

    if (id = '') then continue;

    Post(id, hash);
  end;

  explodedString := nil;
end;

procedure TFormMain.Post(id, hash: String);
var
  PostData: TStringList;
  page, message1: String;
begin
  if (IsPostedKillmailId(id)) then begin
    // Skip
    sndPlaySound('skip.wav', SND_NODEFAULT Or SND_ASYNC);
    LabeledEditSkip.Text := IntToStr(StrToInt(LabeledEditSkip.Text) + 1);
    Exit;
  end;

  page := '';
  PostData := TStringList.Create;

  try
    IdHTTP.Request.Referer := 'https://zkillboard.com/post/';
    PostData.Add('killmailurl=https://esi.evetech.net/v1/killmails/' + id + '/' + hash + '/?datasource=tranquility');
    page := IdHTTP.Post('https://zkillboard.com/post/', PostData);

    MemoResult.Clear;
    MemoResult.Lines.Add(page);

    // Wrong post
    sndPlaySound('wrong.wav', SND_NODEFAULT Or SND_ASYNC);
    LabeledEditWrongPost.Text := IntToStr(StrToInt(LabeledEditWrongPost.Text) + 1);
  except
    on E: EIdHTTPProtocolException do begin
      message1 := E.ClassName + ': ' + E.Message;

      MemoResult.Clear;
      MemoResult.Lines.Add(message1);

      if (E.ErrorCode = 302) then begin
        // Success
        sndPlaySound('success.wav', SND_NODEFAULT Or SND_ASYNC);
        LabeledEditSuccess.Text := IntToStr(StrToInt(LabeledEditSuccess.Text) + 1);

        RemeberKillmailId(id);
      end else begin
        // Error
        sndPlaySound('error.wav', SND_NODEFAULT Or SND_ASYNC);
        LabeledEditError.Text := IntToStr(StrToInt(LabeledEditError.Text) + 1);

        ShowMessage(message1);
      end;
    end;
    on E : Exception do begin
      message1 := E.ClassName + ': ' + E.Message;

      MemoResult.Clear;
      MemoResult.Lines.Add(message1);

      // Error
      sndPlaySound('error.wav', SND_NODEFAULT Or SND_ASYNC);
      LabeledEditError.Text := IntToStr(StrToInt(LabeledEditError.Text) + 1);

      ShowMessage(message1);
    end;
  end;

  PostData.Free;

  Sleep(1000);
end;

procedure TFormMain.Explode(var a: Array of String; Border, S: String);
var
  S2: string;
  i: Integer;
begin
  i  := 0;
  S2 := S + Border;
  repeat
    a[i] := Copy(S2, 0,Pos(Border, S2) - 1);
    Delete(S2, 1,Length(a[i] + Border));
    Inc(i);
  until S2 = '';
end;

procedure TFormMain.OnSocketAllocated(Sender: TObject);
begin
  // idHTTP connect by IP address, not by domain name
  IdHTTP.IOHandler.Host := zkillboardIp;
end;

procedure TFormMain.ResolveZkillboard();
var
  i: Integer;
  Record1: TResultRecord;
  aRecord: TARecord;
  message1: String;
begin
  zkillboardIp := '';

  try
    IdDNSResolver.Resolve('zkillboard.com');

    for i := 0 to IdDNSResolver.QueryResult.Count -1 do
    begin
      Record1 := IdDNSResolver.QueryResult[i];
      case Record1.RecType of
        qtA: begin
          aRecord := TARecord(Record1);

          zkillboardIp := aRecord.IPAddress;
        end;
      end;
    end;
  except
    on E : Exception do begin
      message1 := E.ClassName + ': ' + E.Message;
      ShowMessage('Cant resolve zkillboard.com' + #13 + message1);
      Halt;
    end;
  end;

  if (zkillboardIp = '') then begin
    ShowMessage('Cant resolve zkillboard.com');
    Halt;
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  TrayIcon.IconIndex := ACTIVE_ICON_INDEX;
  ResolveZkillboard;
  TrayIcon.IconIndex := DEFAULT_ICON_INDEX;

  IdHTTP.ConnectTimeout := 5000;
  IdHTTP.ReadTimeout := 5000;

  IdHTTP.OnSocketAllocated := OnSocketAllocated;

  postIdCount := 0;

  FNextClipboardViewer := SetClipboardViewer(Handle);
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  ChangeClipboardChain(Handle, FNextClipboardViewer);
end;

procedure TFormMain.WMChangeCBChain(var Msg : TWMChangeCBChain);
begin
  inherited;
    { mark message as done }
  Msg.Result := 0;
    { the chain has changed }
  if Msg.Remove = FNextClipboardViewer then
    { The next window in the clipboard viewer chain had been removed. We recreate it. }
    FNextClipboardViewer := Msg.Next
  else
    { Inform the next window in the clipboard viewer chain }
    SendMessage(FNextClipboardViewer, WM_CHANGECBCHAIN, Msg.Remove, Msg.Next);
end;


procedure TFormMain.WMDrawClipboard(var Msg : TWMDrawClipboard);
begin
  inherited;
    { Clipboard content has changed }
  try
    // MessageBox(0, 'Clipboard content has changed!', 'Clipboard Viewer', MB_ICONINFORMATION);
    TrayIcon.IconIndex := ACTIVE_ICON_INDEX;
    ClipboardChange;
    TrayIcon.IconIndex := DEFAULT_ICON_INDEX;
  finally
    { Inform the next window in the clipboard viewer chain }
    SendMessage(FNextClipboardViewer, WM_DRAWCLIPBOARD, 0, 0);
  end;
end;

end.
