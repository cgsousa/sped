unit ucadcontab00;

interface

{$REGION 'uses'}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ImgList,

  JvExControls, JvNavigationPane,

  AdvPanel, AdvGlowButton, AdvEdit, AdvGroupBox, ExeInfo,

  ulayout01, EFD00, JvComponentBase, JvBalloonHint;

{$ENDREGION}

{$REGION 'Tfrm_cadcontab00'}
type
  Tfrm_cadcontab00 = class(Tfrm_layout01)
    gbx_id: TAdvGroupBox;
    edt_Nome: TAdvEdit;
    edt_CPF: TAdvEdit;
    edt_CRC: TAdvEdit;
    edt_CNPJ: TAdvEdit;
    edt_Codigo: TAdvEdit;
    btn_apply: TAdvGlowButton;
    gbx_local: TAdvGroupBox;
    edt_Endere: TAdvEdit;
    edt_Bairro: TAdvEdit;
    edt_CEP: TAdvEdit;
    edt_CodMun: TAdvEdit;
    gbx_contato: TAdvGroupBox;
    edt_Fone: TAdvEdit;
    edt_email: TAdvEdit;
    edt_Fax: TAdvEdit;
    procedure btn_applyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FContab: Tcadcontab00 ;
    procedure SetContab(const Value: Tcadcontab00);
  public
    { Public declarations }
    property Contab: Tcadcontab00 read FContab write SetContab ;
    procedure DoResetForm(); override ;

  public
    class function NewAndShowModal(AContab: Tcadcontab00): Boolean;

  end;

{$ENDREGION}

implementation



{$R *.dfm}

{ Tfrm_cadcontab00 }

procedure Tfrm_cadcontab00.btn_applyClick(Sender: TObject);
begin

  if edt_Nome.IsEmpty then
  begin
    MsgDlg(mtWarning, 'O nome deve ser informado!');
    edt_Nome.SetFocus ;
    Exit ;
  end;

  if edt_CRC.IsEmpty then
  begin
    MsgDlg(mtWarning, 'O numero do CRC deve ser informado!');
    edt_CRC.SetFocus ;
    Exit ;
  end;

  if edt_CodMun.IsEmpty then
  begin
    MsgDlg(mtWarning, 'O Código do Municipio deve ser informado!');
    edt_CodMun.SetFocus ;
    Exit ;
  end;

  if FContab = nil then
  begin
    FContab :=cadcontab00List.AddNew(-1) ;
  end;
  FContab.ctb00_nome :=edt_Nome.Text ;
  FContab.ctb00_cpf :=edt_CPF.Text ;
  FContab.ctb00_crc :=edt_CRC.Text ;
  FContab.ctb00_cnpj :=edt_CNPJ.Text ;
  FContab.ctb00_cep :=edt_CEP.Text ;
  FContab.ctb00_endere :=edt_Endere.Text ;
  FContab.ctb00_bairro :=edt_Bairro.Text ;
  FContab.ctb00_codmun :=edt_CodMun.IntValue ;
  FContab.ctb00_email :=edt_email.Text ;
  if cadcontab00List.ApplyUpdates(FContab) then
  begin
    case FContab.UpdateStatus  of
      usNewValue: MsgDlg(mtInformation, 'Novo contabilista incluído com sucesso.');
      usUpdateValue: MsgDlg(mtInformation, 'Dados do contabilista alterado com sucesso.');
    end;
    Self.ModalResult :=mrOk ;
  end
  else
  begin
    case FContab.UpdateStatus  of
      usNewValue: MsgDlg(mtError, 'Processo de incluír novo contabilista falhou!' +FContab.ErrMsg);
      usUpdateValue: MsgDlg(mtError, 'Processo de alterar contabilista falhou!' +FContab.ErrMsg);
    end;
  end;
end;

procedure Tfrm_cadcontab00.DoResetForm;
begin
  inherited DoResetForm ;
  Self.DoSetHeaderCaption('CADASTRO DE CONTABILISTA');

end;

procedure Tfrm_cadcontab00.FormCreate(Sender: TObject);
begin
  inherited;
  FContab :=nil;
end;

class function Tfrm_cadcontab00.NewAndShowModal(AContab: Tcadcontab00): Boolean;
var
  R: Tfrm_cadcontab00 ;
begin
  Application.CreateForm(Tfrm_cadcontab00, R);
  try
    R.Contab :=AContab ;
    Result :=R.ShowModal = mrOk ;
  finally
    FreeAndNil(R);
  end;
end;

procedure Tfrm_cadcontab00.SetContab(const Value: Tcadcontab00);
begin
  DoClearCustomEdit();
  if Assigned(Value) then
  begin
    FContab :=Value ;
    edt_Codigo.Text :=Format('%.3d', [FContab.ctb00_codigo]) ;
    edt_Codigo.Enabled :=False ;
    edt_Nome.Text :=FContab.ctb00_nome ;
    edt_CPF.Text :=FContab.ctb00_cpf ;
    edt_CRC.Text :=FContab.ctb00_crc ;
    edt_CNPJ.Text :=FContab.ctb00_cnpj ;
    edt_CEP.IntValue :=StrToIntDef(FContab.ctb00_cep, 0) ;
    edt_Endere.Text :=FContab.ctb00_endere ;
    edt_Bairro.Text :=FContab.ctb00_bairro ;
    edt_CodMun.IntValue :=FContab.ctb00_codmun ;
    edt_email.Text :=FContab.ctb00_email ;
    FContab.UpdateStatus :=usUpdateValue ;
  end;
end;

end.
