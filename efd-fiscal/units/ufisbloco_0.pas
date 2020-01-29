{*****************************************************************************}
{                                                                             }
{              SPED Sistema Publico de Escrituracao Digital                   }
{              SPED Fiscal                                                    }
{              Copyright (c) 1992,2012 Suporteware                            }
{              Created by Carlos Gonzaga                                      }
{                                                                             }
{*****************************************************************************}

{******************************************************************************
|   Classes/Objects e tipos para criar, manipular e tratar o
|   BLOCO 0: ABERTURA, IDENTIFICAÇÃO E REFERÊNCIAS
|
|Historico  Descrição
|******************************************************************************
|01.06.2012 Cada bloco possui sua unit (antiga uefd.pas mapeada para varias...)
|05.05.2011 Adaptado para o estoque
|07.12.2010 Versão inicial (Guia Prático EFD – Versão 2.0.2	Atualização:
|                           08 de setembro de 2010)
*}

unit ufisbloco_0;

interface

uses Windows,
	Messages,
  SysUtils,
  Classes ,
  EFDCommon;

type

  // Código da finalidade do arquivo:
  TCodFinaly = (
    cfOrig,  //0 - Remessa do arquivo original;
    cfSubst  //1 - Remessa do arquivo substituto.
    );

  // Perfil de apresentação do arquivo fiscal
  TPerfil = (perfil_A, perfil_B, perfil_C);

  // Indicador de tipo de atividade preponderante:
  TIndAtiv =(
    atvInd, // 0 – Industrial ou equiparado a industrial;
    atvOut  // 1 – Outros.
    );


{$REGION 'BLOCO 0: ABERTURA, IDENTIFICAÇÃO E REFERÊNCIAS'}
type
  TBloco_0 = class ;
  Tregistro_0001 = class;
  Tregistro_0005 = class;

  {$REGION 'REGISTRO 0000: ABERTURA DO ARQUIVO DIGITAL E IDENTIFICAÇÃO DA ENTIDADE'}
  Tregistro_0000 = class(TBaseRegistro)
  private
    fOwner: TBloco_0;
  protected
    function GetRow: string; override ;
  public
//    const reg = '0000';
    cod_ver: TCodVerLay	;
    cod_fin: TCodFinaly;
    dta_ini: TDateTime;
    dta_fin: TDateTime;
    nome: string	;
    cnpj: string	;
    cpf: string	;
    uf: string	;
    ie: string	;
    cod_mun: Integer	;
    im: string	;
    suframa: string;
    ind_perfil: TPerfil;
    ind_ativ: TIndAtiv	;
  public
    constructor Create(AOwner: TBloco_0) ;
  end;
  {$ENDREGION}

  //****************************************************************************
  // Registros comuns e extentido para cada EFD
  //****************************************************************************

  {$REGION 'REGISTRO 0100: DADOS DO CONTABILISTA'}
  Tregistro_0100 = class(EFDCommon.Tregistro_0100)
  private
    fOwner: Tregistro_0001 ;
  protected
    function GetRow: string ; override ;
  public
    constructor Create(AOwner: Tregistro_0001); 
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO 0150: TABELA DE CADASTRO DO PARTICIPANTE'}
  Tregistro_0150List = class(EFDCommon.Tregistro_0150List)
  protected
    fOwner: Tregistro_0001;
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    constructor Create(AOwner: Tregistro_0001);
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO 0190: IDENTIFICAÇÃO DAS UNIDADES DE MEDIDA'}
  Tregistro_0190List = class (EFDCommon.Tregistro_0190List)
  protected
    fOwner: Tregistro_0001 ;
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    constructor Create(AOwner: Tregistro_0001);
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO 0200: TABELA DE IDENTIFICAÇÃO DO ITEM (PRODUTO E SERVIÇOS)'}
  Tregistro_0200List = class (EFDCommon.Tregistro_0200List)
  protected
    fOwner: Tregistro_0001 ;
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    constructor Create(AOwner: Tregistro_0001);
  end;
  {$ENDREGION}

  //****************************************************************************
  // fim da extensão
  //****************************************************************************

  {$REGION 'REGISTRO 0001: ABERTURA DO BLOCO 0'}
  Tregistro_0001 = class(TOpenBloco)
  protected
    function GetRow: string; override;
  private
    fOwner: TBloco_0;
  public
    //const reg = '0001';
  public
    registro_0005: Tregistro_0005;
    registro_0100: Tregistro_0100;
    registro_0150: Tregistro_0150List;
    registro_0190: Tregistro_0190List;
    registro_0200: Tregistro_0200List;
    constructor Create(AOwner: TBloco_0);
    destructor Destroy; override	;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO 0005: DADOS COMPLEMENTARES DA ENTIDADE'}
  Tregistro_0005 = class(TBaseRegistro)
  private
    fOwner: Tregistro_0001;
  protected
    function GetRow: string; override ;
  public
//    const reg = '0005';
    fantazia: string;
    cep     : string;
    log_end : string;
    numero  : string;
    comple  : string;
    bairro  : string;
    fone    : string;
    fax     : string;
    email   : string;
  public
    constructor Create(AOwner: Tregistro_0001);
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO 0990: ENCERRAMENTO DO BLOCO 0'}
  Tregistro_0990 = class(TBaseRegistro)
  private
    fOwner: TBloco_0 ;
  protected
    function GetRow: string; override ;
  public
//    const reg = '0990';
    qtd_lin_B0:Integer ;
    constructor Create(AOwner: TBloco_0) ;
  end;
  {$ENDREGION}


  TBloco_0 = class
  private
    fBloco_9: TBloco_9 ;
    fdta_ini: TDateTime ;
    fdta_fin: TDateTime ;
    function get_dt_ini: TDateTime ;
    function get_dt_fin: TDateTime ;
    procedure DoInc(const qtd_lin: Integer=1);
  public
    registro_0000: Tregistro_0000;
    registro_0001: Tregistro_0001;
    registro_0990: Tregistro_0990;
  public
    function NewReg_0150(const cod_part, nome:string;
                         const cnpj,cpf,ie:string;
                         const endere  :string;
                         const comple  :string;
                         const bairro  :string;
                         const cod_mun: Integer;
                         const cod_pais:Integer=TDefValue.COD_BACEN_BRASIL): Tregistro_0150;
    function GetReg_0150(const cod_part: string): Tregistro_0150;


    function NewReg_0190(const InUnid: string; out OuUnid: string): Tregistro_0190;

    function NewReg_0200(const cod_item, descr_item, cod_bar: string;
                         out und_iven: string;
                         const tipo_item: TItemTyp=itmRevenda;
                         const cod_ncm: string='';
                         const cod_gen: Integer=00;
                         const aliq_icms: Currency=0.00): Tregistro_0200;


  public
    property dta_ini: TDateTime read get_dt_ini ;
    property dta_fin: TDateTime read get_dt_fin ;
    constructor Create(ABloco_9: TBloco_9); reintroduce ;
    destructor Destroy; override;
    procedure DoExec(AFile: TFileEFD) ;
  end;

{$ENDREGION}

implementation

uses DateUtils, StrUtils,
  EFDUtils ;

{ TBloco_0 }

constructor TBloco_0.Create(ABloco_9: TBloco_9);
begin
    inherited Create();
    fBloco_9 :=ABloco_9 ;
    registro_0000 :=Tregistro_0000.Create(Self) ;
    registro_0001 :=Tregistro_0001.Create(Self) ;
    registro_0990 :=Tregistro_0990.Create(Self) ;
end;

destructor TBloco_0.Destroy;
begin
    registro_0000.Destroy ;
    registro_0001.Destroy ;
    registro_0990.Destroy ;
    inherited Destroy;
end;

procedure TBloco_0.DoExec(AFile: TFileEFD);
var
    I:Integer	;

begin
    AFile.NewLine(registro_0000.Row);
    AFile.NewLine(registro_0001.Row);
    AFile.NewLine(registro_0001.registro_0005.Row);
    AFile.NewLine(registro_0001.registro_0100.Row);

    for I :=0 to registro_0001.registro_0150.Count -1 do
    begin
        AFile.NewLine(registro_0001.registro_0150.Items[I].Row)	;
    end;

    for I :=0 to registro_0001.registro_0190.Count -1 do
    begin
        AFile.NewLine(registro_0001.registro_0190.Items[I].Row)	;
    end;

    for I :=0 to registro_0001.registro_0200.Count -1 do
    begin
        AFile.NewLine(registro_0001.registro_0200.Items[I].Row)	;
    end;

    AFile.NewLine(registro_0990.Row)	;
end;

procedure TBloco_0.DoInc(const qtd_lin: Integer);
begin
    Inc(Self.registro_0990.qtd_lin_B0, qtd_lin) ;
end;

function TBloco_0.GetReg_0150(const cod_part: string): Tregistro_0150;
begin
  	Result	:=Self.registro_0001.registro_0150.IndexOf(cod_part);
end;

function TBloco_0.get_dt_fin: TDateTime;
begin
  	Result :=registro_0000.dta_fin ;
end;

function TBloco_0.get_dt_ini: TDateTime;
begin
    Result :=registro_0000.dta_ini ;
end;

function TBloco_0.NewReg_0150(const cod_part, nome:string;
                              const cnpj,cpf,ie:string;
                              const endere  :string	;
                              const comple  :string;
                              const bairro  :string;
                              const cod_mun, cod_pais: Integer): Tregistro_0150;
begin
    Result	:=Self.registro_0001.registro_0150.IndexOf(cod_part);
    if Result=nil then
    begin
        Result :=Self.registro_0001.registro_0150.AddNew;
        Result.codigo :=cod_part;
        Result.nome   :=nome;
        Result.cod_pais:=cod_pais;
        Result.cnpj		 :=cnpj;
        Result.cpf		 :=cpf;
        Result.ie      :=ie;
        Result.cod_mun:=cod_mun	;
        Result.endere	:=endere	;
        Result.bairro	:=bairro;
    end ;
end;

function TBloco_0.NewReg_0190(const InUnid: string;
  out OuUnid: string): Tregistro_0190;
begin
    OuUnid :=UpperCase(Trim(InUnid));
    if OuUnid = EmptyStr then
    begin
      OuUnid :='UN' ;
    end;
    {if (OuUnid='DP')or(OuUnid='JG')or(OuUnid='RL')or(OuUnid='')or(OuUnid='VD')then
    begin
        OuUnid :='UN' ;
    end;}
    Result	:=Self.registro_0001.registro_0190.IndexOf(OuUnid) ;
    if Result = nil then
    begin
        Result	:=Self.registro_0001.registro_0190.AddNew	;
        Result.unidad	:=OuUnid;
    end ;
    if 			OuUnid='UN' then	Result.descri:='UNIDADE'
    else if OuUnid='CX' then	Result.descri:='CAIXA'
    else if OuUnid='LT' then	Result.descri:='LITRO'
    else if OuUnid='KG' then	Result.descri:='KILO'
    else if OuUnid='PT' then	Result.descri:='PACOTE'
    else begin
        Result.descri	:='NÃO INFORMADO';
    end;
end;

function TBloco_0.NewReg_0200(const cod_item, descr_item, cod_bar: string;
                              out und_iven: string;
                              const tipo_item: TItemTyp;
                              const cod_ncm: string	;
                              const cod_gen: Integer	;
                              const aliq_icms : Currency): Tregistro_0200;
var
    und: string ;
begin
    und :=und_iven ;
    Self.NewReg_0190(und, und_iven);
    Result :=registro_0001.registro_0200.IndexOf(cod_item);
    if Result = nil then
    begin
        Result :=registro_0001.registro_0200.AddNew;
        Result.cod_item  :=cod_item;
        Result.descr_item:=Trim(descr_item);
        Result.cod_bar   :=cod_bar;
        Result.und_iven	 :=und_iven;
        Result.tipo      :=tipo_item ;
        Result.cod_ncm   :=cod_ncm;
        Result.cod_gen   :=cod_gen;
        Result.aliq_icms :=aliq_icms;
    end;
end;


{ Tregistro_0000 }

constructor Tregistro_0000.Create(AOwner: TBloco_0);
begin
    inherited Create('0000');
    fOwner :=AOwner ;
end;

function Tregistro_0000.GetRow: string;
begin
    Result :=        Tefd_util.SEP_FIELD +Self.reg;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.cod_ver),3);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.cod_fin),1,'0');
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FDat(Self.dta_ini) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FDat(Self.dta_fin) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.nome,100);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cnpj,14);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cpf,11);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.uf,2);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.ie,14);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cod_mun,7) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.im,11);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.suframa,9);
    case Self.ind_perfil of
        perfil_A:Result :=Result +Tefd_util.SEP_FIELD +'A' ;
        perfil_B:Result :=Result +Tefd_util.SEP_FIELD +'B' ;
        perfil_C:Result :=Result +Tefd_util.SEP_FIELD +'C' ;
    end;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_ativ),1,'0') ;
    Result :=Result +Tefd_util.SEP_FIELD ;

    fOwner.DoInc();
    fOwner.fBloco_9.UpdateReg(Self.reg);
end;

{ Tregistro_0001 }

constructor Tregistro_0001.Create(AOwner: TBloco_0);
begin
    inherited Create('0001');
    ind_mov :=movDat ;
    fOwner :=AOwner  ;
    registro_0005:=Tregistro_0005.Create(Self) ;
    registro_0100:=Tregistro_0100.Create(Self) ;
    registro_0150:=Tregistro_0150List.Create(Self) ;
    registro_0190:=Tregistro_0190List.Create(Self) ;
    registro_0200:=Tregistro_0200List.Create(Self) ;
end;

destructor Tregistro_0001.Destroy;
begin
    registro_0005.Destroy ;
    registro_0100.Destroy ;
    registro_0150.Destroy ;
    registro_0190.Destroy ;
    registro_0200.Destroy ;
    inherited Destroy ;
end;

function Tregistro_0001.GetRow: string;
begin
    Result := inherited GetRow ;
//    Result :=        Tefd_util.SEP_FIELD +Self.reg;
//    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_mov),1,'0');
//    Result :=Result +Tefd_util.SEP_FIELD ;
    fOwner.DoInc;
    fOwner.fBloco_9.UpdateReg(Self.reg);
end;

{ Tregistro_0990 }

constructor Tregistro_0990.Create(AOwner: TBloco_0) ;
begin
    inherited Create('0990');
    fOwner :=AOwner  ;
end;

function Tregistro_0990.GetRow: string;
begin
    Inc(Self.qtd_lin_B0)	;
    Result :=        Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.reg) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.qtd_lin_B0) ;
    Result :=Result +Tefd_util.SEP_FIELD ;
    fOwner.fBloco_9.UpdateReg(Self.reg);
end;

{ Tregistro_0005 }

constructor Tregistro_0005.Create(AOwner: Tregistro_0001);
begin
    inherited Create('0005');
    fOwner :=AOwner  ;
end;

function Tregistro_0005.GetRow: string;
begin
    Result :=        Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.reg) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.fantazia,60);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cep,8);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.log_end,60);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.numero,10);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.comple,60);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.bairro,60);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.fone,10);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.fax,10);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.email,100);
    Result :=Result +Tefd_util.SEP_FIELD ;

    fOwner.fOwner.DoInc();
    fOwner.fOwner.fBloco_9.UpdateReg(Self.reg) ;
end;

{ Tregistro_0100 }

constructor Tregistro_0100.Create(AOwner: Tregistro_0001);
begin
    //RightStr(Self.ClassName, 4) ;
    inherited Create('0100');
    fOwner :=AOwner  ;
end;

function Tregistro_0100.GetRow: string;
begin
    Result :=inherited GetRow();
    fOwner.fOwner.DoInc();
    fOwner.fOwner.fBloco_9.UpdateReg(Self.reg) ;
end;

{ Tregistro_0150List }

constructor Tregistro_0150List.Create(AOwner: Tregistro_0001);
begin
    inherited Create();
    fOwner :=AOwner  ;
end;

procedure Tregistro_0150List.Notify(Ptr: Pointer; Action: TListNotification);
begin
    if Action=lnAdded then
    begin
        // registra nos totalizadores
        fOwner.fOwner.DoInc();
        fOwner.fOwner.fBloco_9.UpdateReg(Tregistro_0150(Ptr).reg) ;
    end;
    inherited Notify (Ptr, Action);
end;

{ Tregistro_0190List }

constructor Tregistro_0190List.Create(AOwner: Tregistro_0001);
begin
    inherited Create();
    fOwner :=AOwner  ;
end;

procedure Tregistro_0190List.Notify(Ptr: Pointer; Action: TListNotification);
begin
    if Action=lnAdded then
    begin
        // registra nos totalizadores
        fOwner.fOwner.DoInc();
        fOwner.fOwner.fBloco_9.UpdateReg(Tregistro_0190(Ptr).reg) ;
    end;
    inherited Notify (Ptr, Action);
end;

{ Tregistro_0200List }

constructor Tregistro_0200List.Create(AOwner: Tregistro_0001);
begin
    inherited Create();
    fOwner :=AOwner  ;
end;

procedure Tregistro_0200List.Notify(Ptr: Pointer; Action: TListNotification);
begin
    if Action=lnAdded then
    begin
        // registra nos totalizadores
        fOwner.fOwner.DoInc();
        fOwner.fOwner.fBloco_9.UpdateReg(Tregistro_0200(Ptr).reg) ;
    end;
    inherited Notify (Ptr, Action);
end;

end.
