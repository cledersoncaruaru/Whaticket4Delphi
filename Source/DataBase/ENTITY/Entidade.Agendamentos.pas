unit Entidade.Agendamentos;

interface


type

  TAgendamentos = class
  private
    FticketId: Integer;
    FuserId: Integer;
    FcontactId: String;
    Fbody: String;
    FupdatedAt: TDateTime;
    FsentAt: TDateTime;
    Fid: LongInt;
    Fstatus: Integer;
    FsaveMessage: Boolean;
    FcreatedAt: TDateTime;
    FcompanyId: Integer;
    FsendAt: TDateTime;
    Fdescricao: String;

    procedure Setbody(const Value: String);
    procedure SetcompanyId(const Value: Integer);
    procedure SetcontactId(const Value: String);
    procedure SetcreatedAt(const Value: TDateTime);
    procedure Setid(const Value: LongInt);
    procedure SetsaveMessage(const Value: Boolean);
    procedure SetsendAt(const Value: TDateTime);
    procedure SetsentAt(const Value: TDateTime);
    procedure Setstatus(const Value: Integer);
    procedure SetticketId(const Value: Integer);
    procedure SetupdatedAt(const Value: TDateTime);
    procedure SetuserId(const Value: Integer);
    procedure Setdescricao(const Value: String);

  published

      property id             : LongInt read Fid write Setid;
      Property descricao      : String read Fdescricao write Setdescricao;
      property body           : String read Fbody write Setbody;
      property sendAt         : TDateTime read FsendAt write SetsendAt;
      property sentAt         : TDateTime read FsentAt write SetsentAt;
      property contactId      : String  read FcontactId write SetcontactId;
      property ticketId       : Integer read FticketId write SetticketId;
      property userId         : Integer read FuserId write SetuserId;
      property companyId      : Integer read FcompanyId write SetcompanyId;
      property createdAt      : TDateTime read FcreatedAt write SetcreatedAt;
      property updatedAt      : TDateTime read FupdatedAt write SetupdatedAt;
      property Status         : Integer read FStatus write SetStatus;
      property saveMessage    :Boolean read FsaveMessage write SetsaveMessage;

  end;


implementation


{ TAgendamentos }


{ TAgendamentos }

procedure TAgendamentos.Setbody(const Value: String);
begin
  Fbody := Value;
end;

procedure TAgendamentos.SetcompanyId(const Value: Integer);
begin
  FcompanyId := Value;
end;

procedure TAgendamentos.SetcontactId(const Value: String);
begin
  FcontactId := Value;
end;

procedure TAgendamentos.SetcreatedAt(const Value: TDateTime);
begin
  FcreatedAt := Value;
end;

procedure TAgendamentos.Setdescricao(const Value: String);
begin
  Fdescricao := Value;
end;

procedure TAgendamentos.Setid(const Value: LongInt);
begin
  Fid := Value;
end;

procedure TAgendamentos.SetsaveMessage(const Value: Boolean);
begin
  FsaveMessage := Value;
end;

procedure TAgendamentos.SetsendAt(const Value: TDateTime);
begin
  FsendAt := Value;
end;

procedure TAgendamentos.SetsentAt(const Value: TDateTime);
begin
  FsentAt := Value;
end;

procedure TAgendamentos.SetStatus(const Value: Integer);
begin
  FStatus := Value;
end;

procedure TAgendamentos.SetticketId(const Value: Integer);
begin
  FticketId := Value;
end;

procedure TAgendamentos.SetupdatedAt(const Value: TDateTime);
begin
  FupdatedAt := Value;
end;

procedure TAgendamentos.SetuserId(const Value: Integer);
begin
  FuserId := Value;
end;

end.
