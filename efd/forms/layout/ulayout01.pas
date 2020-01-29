unit ulayout01;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ImgList, StdCtrls ,
  JvExControls, JvNavigationPane,

  AdvPanel, AdvPageControl, AdvGlowButton, AdvGroupBox, AdvCombo, AdvEdit,
  AdvStyleIF, AdvSmoothMessageDialog, AdvSmoothPanel, AdvOfficeButtons,
  ExeInfo, JvComponentBase, JvBalloonHint, System.ImageList ;


type
  TAdvEdit = class(AdvEdit.TAdvEdit)
    function IsEmpty: Boolean ;
  end;


{$REGION 'Tfrm_layout01'}
type
  Tfrm_layout01 = class(TForm)
    pnl_header: TJvNavPanelHeader;
    pnl_footer: TAdvPanel;
    btn_close: TAdvGlowButton;
    ImageList1: TImageList;
    ExeInfo1: TExeInfo;
    JvBalloonHint1: TJvBalloonHint;
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure DoNextControl;
    procedure DoBackControl;

  public
    { Public declarations }
//    procedure OnKeySelectNext(Sender: TObject; var Key: Char);

    procedure DoResetForm(); virtual ;
    procedure DoSetHeaderCaption(const ACaption: string);
    procedure DoStatusBar(const AText: string); overload ;
    procedure DoStatusBar(const AText: string; const Args: array of const); overload ;
    procedure DoClearCustomEdit(AWinCntrl: TWinControl = nil) ;

    function MsgDlg(const ACaption, AText: string;
                    const AButtons: TMsgDlgButtons = [mbOK];
                    const AStyle: TTMSStyle = tsWindows8): Boolean; overload ;
    function MsgDlg(const ADlgType: TMsgDlgType;
                    const AText: string;
                    const AButtons: TMsgDlgButtons = [mbOK]): Boolean; overload ;

  end;


{$ENDREGION}

var
  frm_layout01: Tfrm_layout01;

implementation

//uses COperatingSystemInfo;

{$R *.dfm}

{ Tfrm_layout01 }

procedure Tfrm_layout01.DoBackControl;
begin
  if Assigned(ActiveControl)then
  begin
    SelectNext(ActiveControl, False, True);
  end;
end;

procedure Tfrm_layout01.DoClearCustomEdit(AWinCntrl: TWinControl);
var
  I: Integer ;
  C: TComponent ;
begin
  if Assigned(AWinCntrl) then
    for I :=0 to AWinCntrl.ControlCount -1 do
    begin
      C :=AWinCntrl.Controls[I];
      if C is TCustomEdit then
      begin
        TCustomEdit(C).Clear ;
      end;
    end
  else
    for I :=0 to ComponentCount -1 do
    begin
      C :=Components[I];
      if C is TCustomEdit then
      begin
        TCustomEdit(C).Clear ;
      end;
    end;
end;

procedure Tfrm_layout01.DoNextControl;
begin
  if Assigned(ActiveControl)then
  begin
    SelectNext(ActiveControl, True, True);
  end;
end;

procedure Tfrm_layout01.DoResetForm;
begin
  Caption :=Application.Title;

  DoStatusBar('%s - [versão: %d.%d.%d] Sistema: %s',[
    ExeInfo1.FileDescription,
    ExeInfo1.MajorVersion, ExeInfo1.MinorVersion, ExeInfo1.ReleaseNumber,
    ExeInfo1.GetOperatingSystem ]);

end;

procedure Tfrm_layout01.DoSetHeaderCaption(const ACaption: string);
begin
  pnl_header.Caption :=ACaption ;

end;

procedure Tfrm_layout01.DoStatusBar(const AText: string;
  const Args: array of const);
begin
  DoStatusBar(Format(AText, Args));
end;

procedure Tfrm_layout01.DoStatusBar(const AText: string);
begin
  pnl_footer.StatusBar.Text :=AText ;
end;

procedure Tfrm_layout01.FormCreate(Sender: TObject);
begin
  BorderWidth :=3 ;
  Ctl3D :=False ;
  Position :=poDesktopCenter ;
  KeyPreview :=True ;
  btn_close.ModalResult :=mrCancel ;
end;

procedure Tfrm_layout01.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
    begin
      Key:=#0;
      Self.DoNextControl;
    end;
  end;
end;

procedure Tfrm_layout01.FormShow(Sender: TObject);
begin
  DoResetForm();

end;

function Tfrm_layout01.MsgDlg(const ADlgType: TMsgDlgType;
  const AText: string; const AButtons: TMsgDlgButtons): Boolean;
begin
  case ADlgType of
    mtInformation: Result :=Self.MsgDlg('Informação', AText) ;
    mtWarning: Result :=Self.MsgDlg('Advertência', AText, AButtons, tsOffice2003Olive) ;
    mtError: Result :=Self.MsgDlg('Erro', AText, [mbOK], tsOffice2010Black) ;
  end;
end;

function Tfrm_layout01.MsgDlg(const ACaption, AText: string;
  const AButtons: TMsgDlgButtons; const AStyle: TTMSStyle): Boolean;
var
  frm_dlg: TAdvSmoothMessageDialog ;
  btn_dlg: TAdvSmoothMessageDialogButton ;
begin
  frm_dlg :=TAdvSmoothMessageDialog.Create(Self) ;
  try
    frm_dlg.Caption :=ACaption;
    frm_dlg.HTMLText.Text :=AText ;
    if mbOK in AButtons then
    begin
      btn_dlg :=frm_dlg.Buttons.Add ;
      btn_dlg.Caption :='OK';
      btn_dlg.ButtonResult :=mrOk ;
    end
    else if mbYes in AButtons then
    begin
      btn_dlg :=frm_dlg.Buttons.Add ;
      btn_dlg.Caption :='Sim';
      btn_dlg.ButtonResult :=mrYes ;
    end;
    if mbCancel in AButtons then
    begin
      btn_dlg :=frm_dlg.Buttons.Add ;
      btn_dlg.Caption :='Cancelar';
      btn_dlg.ButtonResult :=mrCancel ;
    end
    else if mbNo in AButtons then
    begin
      btn_dlg :=frm_dlg.Buttons.Add ;
      btn_dlg.Caption :='Não';
      btn_dlg.ButtonResult :=mrNo ;
    end;
    frm_dlg.SetComponentStyle(AStyle);
    frm_dlg.Position :=poMainFormCenter;
    Result :=frm_dlg.Execute ;
  finally
    frm_dlg.Destroy ;
  end;
end;

{ TAdvEdit }

function TAdvEdit.IsEmpty: Boolean;
begin
  case Self.EditType of
    etString: Result :=Trim(Self.Text) = '';
    etNumeric: Result :=Self.IntValue = 0;
    etFloat,etMoney: Result :=Self.FloatValue = 0;
  else
    Result :=True ;
  end;
end;

end.
