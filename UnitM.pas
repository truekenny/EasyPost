unit UnitM;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, System.ImageList,
  Vcl.ImgList, Vcl.Menus, Vcl.StdCtrls,

  System.RegularExpressions, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL;

type
  TFormMain = class(TForm)
    TrayIcon: TTrayIcon;
    ImageListTray: TImageList;
    PopupMenuTray: TPopupMenu;
    menuQuit: TMenuItem;
    MemoCurrent: TMemo;
    Timer: TTimer;
    MemoLast: TMemo;
    IdHTTP: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    MemoResult: TMemo;
    LabeledEditWrongPost: TLabeledEdit;
    LabeledEditError: TLabeledEdit;
    LabeledEditSuccess: TLabeledEdit;
    LabeledEditSkip: TLabeledEdit;
    menuShowMainFormDebug: TMenuItem;
    LabelCurrentClipboard: TLabel;
    LabelLastClipboard: TLabel;
    LabelPostResults: TLabel;
    procedure menuQuitClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure menuShowMainFormDebugClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function inArray(idString: String): Boolean;
    procedure Post(id, hash: String);
    procedure Explode(var a: array of string; Border, S: string);
  end;

const
  MAX_POST_IDS = 10000;
var
  FormMain: TFormMain;
  postIds: Array[0..MAX_POST_IDS] of Integer;
  postIdCount: Integer = 0;

implementation

{$R *.dfm}

function TFormMain.inArray(idString: String): Boolean;
var
  i, id: Integer;
begin
  Result := False;

  id := 0;
  try
    id := StrToInt(idString);
  finally

  end;

  // Reset
  if (postIdCount = MAX_POST_IDS - 1) then begin
    postIdCount := 0;
  end;

  for i := 0 to postIdCount - 1 do begin
    if (postIds[i] = id) then begin
      Result := True;
      Exit;
    end;
  end;

  postIdCount := postIdCount + 1;
  postIds[postIdCount - 1] := id;
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

procedure TFormMain.TimerTimer(Sender: TObject);
(*
Examples:
<url=killReport:91650826:2876d8ccc7f479c6a73b7b9e80d2dfc4b538d090>Kill: Mr Antisocial (Stiletto)</url>
https://esi.evetech.net/v1/killmails/91650392/0ef7394f0d770d96567063fbda8d6612437a1c10/?datasource=tranquility
*)
const
  Pattern = '(<url=killReport:\d+:[^>]+>|killmails/\d+/[^/]+/)';
var
  i, j: Integer;
  RegEx: TRegEx;
  Matches: TMatchCollection;
  Match, id, hash: String;
  A: array of String;

begin
  MemoCurrent.Clear;
  MemoCurrent.PasteFromClipboard;

  if (not MemoCurrent.Lines.Equals(MemoLast.Lines)) then begin
    MemoLast.Clear;
    MemoLast.Lines.AddStrings(MemoCurrent.Lines);

    SetLength(A, 10);
    RegEx := TRegEx.Create(Pattern);

    for i := 0 to MemoLast.Lines.Count - 1 do begin
      Matches := RegEx.Matches(MemoLast.Lines[i]);
      for j := 0 to Matches.Count - 1 do begin
        Match := Matches.Item[j].Value;

        id := '';
        hash := '';

        if (Match[1] = '<') then begin
          Explode(A, ':', Match);
          id := A[1];
          hash := Copy(A[2], 1, Length(A[2]) - 1);
        end
        else if (Match[1] = 'k') then begin
          Explode(A, '/', Match);
          id := A[1];
          hash := A[2];
        end;

        if (id = '') then continue;

        Post(id, hash);
      end;
    end;

    A := nil;
  end;
end;

procedure TFormMain.Post(id, hash: String);
var
  PostData: TStringList;
  page, message1: String;
begin
  if (inArray(id)) then begin
    // Skip
    LabeledEditSkip.Text := IntToStr(StrToInt(LabeledEditSkip.Text) + 1);
    Exit;
  end;

  page := '';
  PostData := TStringList.Create;

  try
    IdHTTP.Request.Referer := 'https://zkillboard.com/post/';
    PostData.Add('killmailurl=https://esi.evetech.net/v1/killmails/'+id+'/'+hash+'/?datasource=tranquility');
    page := IdHTTP.Post('https://zkillboard.com/post/', PostData);

    MemoResult.Clear;
    MemoResult.Lines.Add(page);

    // Wrong post
    LabeledEditWrongPost.Text := IntToStr(StrToInt(LabeledEditWrongPost.Text) + 1);
  except
    on E: EIdHTTPProtocolException do begin
      message1 := E.ClassName + ': ' + E.Message;

      MemoResult.Clear;
      MemoResult.Lines.Add(message1);

      if (E.ErrorCode = 302) then begin
        // Success
        LabeledEditSuccess.Text := IntToStr(StrToInt(LabeledEditSuccess.Text) + 1);
      end else begin
        // Error
        LabeledEditError.Text := IntToStr(StrToInt(LabeledEditError.Text) + 1);

        ShowMessage(message1);
      end;
    end;
    on E : Exception do begin
      message1 := E.ClassName + ': ' + E.Message;

      MemoResult.Clear;
      MemoResult.Lines.Add(message1);

      // Error
      LabeledEditError.Text := IntToStr(StrToInt(LabeledEditError.Text) + 1);

      ShowMessage(message1);
    end;
  end;

  PostData.Free;

  Beep;
  Sleep(1000);
end;

procedure TFormMain.Explode(var a: array of string; Border, S: string);
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

end.
