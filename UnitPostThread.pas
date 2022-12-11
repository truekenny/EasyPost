unit UnitPostThread;

interface

uses
  Classes,
  IdHTTP,
  MMSystem,
  SyncObjs,
  SysUtils,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.StdCtrls;

const
  MAX_POST_IDS = 10000;

type
  TKillmailRecord = Record
    id: Integer;
    hash: string[40];
  end;

  TPostThread = class(TThread)
  private
    { Private declarations }
    KillmailQueueList: TThreadList;
    Event: TEvent;

    idHTTP: TIdHTTP;
    MemoResult: TMemo;
    LabeledEditWrongPost: TLabeledEdit;
    LabeledEditError: TLabeledEdit;
    LabeledEditSuccess: TLabeledEdit;
    LabeledEditSkip: TLabeledEdit;

    postIds: Array[0..MAX_POST_IDS] of Integer;
    postIdCount: Integer;

    procedure RemeberKillmailId(idString: String);
    function IsPostedKillmailId(idString: String): Boolean;
    procedure Post(id, hash: String);

    procedure OnThreadTerminate (Sender : TObject);
  protected
    procedure Execute; override;

  public
    constructor Create(ApplicationHandle: Cardinal;
      _idHTTP: TIdHTTP;
      _MemoResult: TMemo;
      _LabeledEditWrongPost: TLabeledEdit;
      _LabeledEditError: TLabeledEdit;
      _LabeledEditSuccess: TLabeledEdit;
      _LabeledEditSkip: TLabeledEdit);
    procedure AddKillmailQueue(id: Integer; hash: String);
    function GetKillmailQueue(): Pointer;
    procedure WakeUpEvent();
  end;

implementation

procedure TPostThread.RemeberKillmailId(idString: String);
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

function TPostThread.IsPostedKillmailId(idString: String): Boolean;
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

procedure TPostThread.Post(id, hash: String);
var
  PostData: TStringList;
  page, message1: String;
begin
  if (IsPostedKillmailId(id)) then begin
    // Skip
    sndPlaySound('skip.wav', SND_NODEFAULT Or SND_ASYNC);
    Synchronize(procedure begin LabeledEditSkip.Text := IntToStr(StrToInt(LabeledEditSkip.Text) + 1); end);
    Exit;
  end;

  page := '';
  PostData := TStringList.Create;

  try
    IdHTTP.Request.Referer := 'https://zkillboard.com/post/';
    PostData.Add('killmailurl=https://esi.evetech.net/v1/killmails/' + id + '/' + hash + '/?datasource=tranquility');
    page := IdHTTP.Post('https://zkillboard.com/post/', PostData);

    Synchronize(procedure begin MemoResult.Clear; MemoResult.Lines.Add(page); end);

    // Wrong post
    sndPlaySound('wrong.wav', SND_NODEFAULT Or SND_ASYNC);
    Synchronize(procedure begin LabeledEditWrongPost.Text := IntToStr(StrToInt(LabeledEditWrongPost.Text) + 1); end);
  except
    on E: EIdHTTPProtocolException do begin
      message1 := E.ClassName + ': ' + E.Message;

      Synchronize(procedure begin MemoResult.Clear; MemoResult.Lines.Add(message1); end);

      if (E.ErrorCode = 302) then begin
        // Success
        sndPlaySound('success.wav', SND_NODEFAULT Or SND_ASYNC);
        Synchronize(procedure begin LabeledEditSuccess.Text := IntToStr(StrToInt(LabeledEditSuccess.Text) + 1); end);

        RemeberKillmailId(id);
      end else begin
        // Error
        sndPlaySound('error.wav', SND_NODEFAULT Or SND_ASYNC);
        Synchronize(procedure begin LabeledEditError.Text := IntToStr(StrToInt(LabeledEditError.Text) + 1); end);

        // ShowMessage(message1);
      end;
    end;
    on E : Exception do begin
      message1 := E.ClassName + ': ' + E.Message;

      Synchronize(procedure begin MemoResult.Clear; MemoResult.Lines.Add(message1); end);

      // Error
      sndPlaySound('error.wav', SND_NODEFAULT Or SND_ASYNC);
      Synchronize(procedure begin LabeledEditError.Text := IntToStr(StrToInt(LabeledEditError.Text) + 1); end);

      // ShowMessage(message1);
    end;
  end;

  PostData.Free;

  Sleep(1000);
end;

procedure TPostThread.OnThreadTerminate(Sender: TObject);
begin
  KillmailQueueList.Free;
  Event.Free;
end;

procedure TPostThread.Execute;
var
  KillmailRecord: ^TKIllmailRecord;
  someKills: Boolean;
begin
  while True do begin
    Event.WaitFor(INFINITE);
    // Event.ResetEvent; // ManualReset=False
    if Terminated then break;

    // Beep();
    someKills := False;
    KillmailRecord := GetKillmailQueue;
    while (KillmailRecord <> nil) do begin
      someKills := True;
      Post(IntToStr(KillmailRecord.id), String(KillmailRecord.hash));

      Dispose(KillmailRecord);
      KillmailRecord := GetKillmailQueue;
    end;

    if someKills then begin
      sndPlaySound('finish.wav', SND_NODEFAULT Or SND_ASYNC);
      sleep(1000);
    end;
  end;
end;

constructor TPostThread.Create(ApplicationHandle: Cardinal;
  _idHTTP: TIdHTTP;
  _MemoResult: TMemo;
  _LabeledEditWrongPost: TLabeledEdit;
  _LabeledEditError: TLabeledEdit;
  _LabeledEditSuccess: TLabeledEdit;
  _LabeledEditSkip: TLabeledEdit);
begin
  postIdCount := 0;

  idHTTP := _idHTTP;
  MemoResult := _MemoResult;
  LabeledEditWrongPost := _LabeledEditWrongPost;
  LabeledEditError := _LabeledEditError;
  LabeledEditSuccess := _LabeledEditSuccess;
  LabeledEditSkip := _LabeledEditSkip;

  KillmailQueueList := TThreadList.Create;
  // ManualReset=False, InitialState=Blocked

  Event := TEvent.Create(nil, False, False, 'EasyPostEvent' + IntToStr(ApplicationHandle));

  inherited Create(False);
  OnTerminate := OnThreadTerminate;
end;

procedure TPostThread.AddKillmailQueue(id: Integer; hash: String);
var
  KillmailRecord: ^TKIllmailRecord;
begin
  New(KillmailRecord);
  KillmailRecord.id := id;
  KillmailRecord.hash := ShortString(hash);
  KillmailQueueList.Add(KillmailRecord);
  Event.SetEvent;
end;

function TPostThread.GetKillmailQueue(): Pointer;
var
  List: TList;
begin
  Result := nil;

  List := KillmailQueueList.LockList;

  if (List.Count <> 0) then begin
    Result := List.First;
    List.Delete(0);
  end;

  KillmailQueueList.UnlockList;
end;

procedure TPostThread.WakeUpEvent();
begin
  Event.SetEvent;
end;

end.
