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
    procedure menuQuitClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Post(id, hash: String);
    procedure Explode(var a: array of string; Border, S: string);
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

procedure TFormMain.FormCreate(Sender: TObject);
begin
  // Post('91650826', '2876d8ccc7f479c6a73b7b9e80d2dfc4b538d090');
end;

procedure TFormMain.menuQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.TimerTimer(Sender: TObject);
(*
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

  (*
  for i := 0 to MemoCurrent.Lines.Count - 1 do begin
    MemoCurrent.Lines[i] := StringReplace(MemoCurrent.Lines[i], '</url>', '</url>1' + #13#10,
                          [rfReplaceAll]);
  end;
  *)

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
// QUEST HELPER https://esi.evetech.net/v1/killmails/91654347/eb57d7e799ed9fb1cd9942f42d1f0410ce5d3e8c/?datasource=tranquility
var
  PostData: TStringList;
  page, message1: String;
begin
  page := '';
  PostData := TStringList.Create;

  try
    IdHTTP.Request.Referer := 'https://zkillboard.com/post/';
    // PostData.Add('killmailurl=https%3A%2F%2Fesi.evetech.net%2Fv1%2Fkillmails%2F'+id+'%2F'+hash+'%2F%3Fdatasource%3Dtranquility');
    PostData.Add('killmailurl=https://esi.evetech.net/v1/killmails/'+id+'/'+hash+'/?datasource=tranquility');
    // PostData.Add('killmailurl=123');
    page := IdHTTP.Post('https://zkillboard.com/post/', PostData);

    MemoResult.Clear;
    MemoResult.Lines.Add(page);
  except
    on E : Exception do begin
      message1 := E.ClassName + ': ' + E.Message;

      if (Pos('302 Found', E.Message) = 0) then begin
        ShowMessage(message1);
      end else begin
        MemoResult.Clear;
        MemoResult.Lines.Add(message1);
      end;
    end;
  end;

  PostData.Free;

//   page := IdHTTP.Get('https://zkillboard.com/robots.txt');

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
