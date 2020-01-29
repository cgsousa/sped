{******************************************************************************}
{                                                                              }
{              SPED Sistema Publico de Escrituracao Digital                    }
{              EFD-Contribuições (PIS/COFINS)                                  }
{              Copyright (c) 1992,2012 Suporteware                             }
{              Created by Carlos Gonzaga                                       }
{                                                                              }
{******************************************************************************}

{*******************************************************************************
|   Classes/Objects e tipos para criar, manipular e tratar o
|   BLOCO 0: ABERTURA, IDENTIFICAÇÃO E REFERÊNCIAS
|
|Historico  Descrição
|*******************************************************************************
|16.08.2012 Cada bloco possui sua unit (antiga uefd_piscofins.pas mapeada units)
|20.12.2011 Versão inicial (Guia Prático EFD-PIS/COFINS – Versão 1.0.3
|                           Atualização: 01 de setembro de 2011)
*}

unit uctrbloco_0;

interface

uses Windows,
	Messages,
  SysUtils,
  Classes ,
  EFDCommon;

type

  // Tipo de escrituração
  TIndTypEsc = (escOrig, escRetif);

  // Indicador de situação especial
  TIndSitEsp = (seAbertura, seCisao, seFusao, seIncorp, seEncerra) ;

  // Indicador da natureza da pessoa jurídica:
  TIndNatPJ =(npjGeral ,  // 00 – Sociedade empresária em geral
              npjCopera,  // 01 – Sociedade cooperativa
              npjPIS      // 02 – Entidade sujeita ao PIS/Pasep exclusivamente
                          // com base na Folha de Salários
              );

  // Indicador de tipo de atividade preponderante:
  TIndTypAtiv =(taIndus , // 0 – Industrial ou equiparado a industrial;
                taServ , // 1 – Prestador de serviços;
                taCom , // 2 - Atividade de comércio;
                tavFin , // 3 – Atividade financeira;
                taImo , // 4 – Atividade imobiliária;
                taOut=9 // 9 – Outros.
                );

  //Código indicador da incidência tributária no período
  TCodIncTrib =(
    citRegNCum=1,    //1 – Escrituração de operações com incidência exclusivamente no regime não-cumulativo;
    citRegCum=2,     //2 – Escrituração de operações com incidência exclusivamente no regime cumulativo;
    citRegNCum_Cum=3 //3 – Escrituração de operações com incidência nos regimes não-cumulativo e cumulativo.
    );

  {Código indicador de método de apropriação de créditos
  comuns, no caso de incidência no regime nãocumulativo}
  TCodAproCred = (
    cacDireta=1 , //1 – Método de Apropriação Direta;
    cacReceitaBru=2//2 – Método de Rateio Proporcional (Receita Bruta)
    );

  //Código indicador do Tipo de Contribuição Apurada no Período
  TCodTipContr = (
    ctcAliqBas=1 ,//1 – Apuração da Contribuição Exclusivamente a Alíquota Básica
    ctcAliqEsp=2  //2 – Apuração da Contribuição a Alíquotas Específicas
    );            //(Diferenciadas e/ou por Unidade de Medida de Produto)

  {Código indicador do critério de escrituração e apuração adotado, no caso de incidência
  exclusivamente no regime cumulativo (COD_INC_TRIB = 2), pela pessoa jurídica submetida
  ao regime de tributação com base no lucro presumido:}
  TCodRegCum = (
    crcCaixa=1,  //1 – Regime de Caixa – Escrituração consolidada (Registro F500);
    crcEscCons=2,//2 – Regime de Competência - Escrituração consolidada (Registro F550);
    crcEscDet=9  //9 – Regime de Competência - Escrituração detalhada, com base nos registros dos
    );                  //Blocos “A”, “C”, “D” e “F”.

{$REGION 'BLOCO 0: ABERTURA, IDENTIFICAÇÃO E REFERÊNCIAS'}
type
  TBloco_0 = class ;
  Tregistro_0100List = class;
  Tregistro_0110 = class;
  Tregistro_0111 = class;
  Tregistro_0140 = class;
  Tregistro_0140List = class;

  {$REGION 'REGISTRO 0000: ABERTURA DO ARQUIVO DIGITAL E IDENTIFICAÇÃO DA PESSOA JURÍDICA'}
  Tregistro_0000 = class(TBaseRegistro)
  private
    fOwner: TBloco_0;
  protected
    function GetRow: string; override;
  public
    cod_ver: TCodVerLay	;
    tip_esc     :TIndTypEsc ;
    ind_sit_esp :TIndSitEsp ;
    num_rec_ant :string ;
    dt_ini     :TDateTime	;
    dt_fin     :TDateTime	;
    nome        :string ;
    cnpj        :string	;
    uf          :string	;
    cod_mun     :Integer;
    suframa     :string	;
    ind_nat_pj  :TIndNatPJ;
    ind_ativ    :TIndTypAtiv ;
  public
    constructor Create(AOwner: TBloco_0);
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO 0001: ABERTURA DO BLOCO 0'}
  Tregistro_0001 = class(TOpenBloco)
  private
    fOwner: TBloco_0;
  protected
    function GetRow: string; override ;
  public
    registro_0100: Tregistro_0100List;
    registro_0110: Tregistro_0110;
    registro_0140: Tregistro_0140List;
    registro_0150: Tregistro_0150List;
    registro_0190: Tregistro_0190List;
    registro_0200: Tregistro_0200List;
    constructor Create(AOwner: TBloco_0);
    destructor Destroy; override	;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO 0100: DADOS DO CONTABILISTA'}
  Tregistro_0100 = class(EFDCommon.Tregistro_0100)
  private
    fOwner: Tregistro_0100List ;
  protected
    function GetRow: string; override ;
  end;

  Tregistro_0100List = class(TBaseEFDList)
  protected
    fOwner: Tregistro_0001 ;
    function Get(Index: Integer): Tregistro_0100 ;
  public
    property Items[Index: Integer]: Tregistro_0100 read Get;
    constructor Create(AOwner: Tregistro_0001); reintroduce ;
    function AddNew: Tregistro_0100;
    function IndexOf(const cpf: string): Tregistro_0100;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO 0110: REGIMES DE APURAÇÃO DA CONTRIBUIÇÃO SOCIAL E DE APROPRIAÇÃO DE CRÉDITO'}
  Tregistro_0110 = class(TBaseRegistro)
  private
    fOwner: Tregistro_0001 ;
  protected
    function GetRow: string; override;
  public
    cod_inc_trib: TCodIncTrib ;
    ind_apr_cred: TCodAproCred;
    cod_tip_cntr: TCodTipContr;
    ind_reg_cum: TCodRegCum;
  public
    registro_0111: Tregistro_0111  ;
    constructor Create(AOwner: Tregistro_0001);
    destructor Destroy; override	;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO 0111: TABELA DE RECEITA BRUTA MENSAL PARA FINS DE RATEIO DE CRÉDITOS COMUNS'}
  Tregistro_0111 = class(TBaseRegistro)
  private
    fOwner: Tregistro_0110;
  protected
    function GetRow: string; override;
  public
    rec_bru_ncum_trib_mi: Currency  ;
    rec_bru_ncum_nt_mi: Currency ;
    rec_bru_ncum_exp: Currency ;
    rec_bru_cum: Currency ;
    rec_bru_total: Currency ;
  public
    constructor Create(AOwner: Tregistro_0110);
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO 0140: TABELA DE CADASTRO DE ESTABELECIMENTO'}
  Tregistro_0140 = class(TBaseRegistro)
  private
    fOwner: Tregistro_0140List;
  protected
    function GetRow:string; override ;
  public
    codigo : Integer;
    nome   : string ;
    cnpj   : string ;
    uf     : string ;
    ie     : string ;
    cod_mun: Integer;
    im     : string ;
    suframa: string ;
  end;

  Tregistro_0140List = class(TBaseEFDList)
  private
    fOwner: Tregistro_0001 ;
  private
    function Get(Index: Integer): Tregistro_0140	;
  public
    property Items[Index: Integer]: Tregistro_0140 read Get;
    constructor Create(AOwner: Tregistro_0001);
    function AddNew: Tregistro_0140;
    function IndexOf(const codigo: Integer): Tregistro_0140;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO 0150: TABELA DE CADASTRO DO PARTICIPANTE'}
  Tregistro_0150List = class(EFDCommon.Tregistro_0150List)
  protected
    fOwner: Tregistro_0001 ;
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    constructor Create(AOwner: Tregistro_0001); reintroduce ;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO 0190: IDENTIFICAÇÃO DAS UNIDADES DE MEDIDA'}
  Tregistro_0190List = class (EFDCommon.Tregistro_0190List)
  protected
    fOwner: Tregistro_0001 ;
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    constructor Create(AOwner: Tregistro_0001); reintroduce ;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO 0200: TABELA DE IDENTIFICAÇÃO DO ITEM (PRODUTO E SERVIÇOS)'}
  Tregistro_0200List = class (EFDCommon.Tregistro_0200List)
  protected
    fOwner: Tregistro_0001 ;
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    constructor Create(AOwner: Tregistro_0001); reintroduce ;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO 0990: ENCERRAMENTO DO BLOCO 0'}
  Tregistro_0990 = class(TBaseRegistro)
  private
    fOwner: TBloco_0 ;
  protected
    function GetRow: string; override;
  public
    qtd_lin_B0:Integer ;
    constructor Create(AOwner: TBloco_0) ;
  end;
  {$ENDREGION}

  TBloco_0 = class
  private
    fBloco_9: TBloco_9;
    procedure DoInc(const qtd_lin: Integer=1) ;
  public
    registro_0000: Tregistro_0000;
    registro_0001: Tregistro_0001;
    registro_0990: Tregistro_0990;
  public
    function NewReg_0100(const nome, cpf, crc, cnpj: string;
                         const endere, bairro, cep: string;
                         const codmun: Integer ;
                         const fone: string = '';
                         const fax: string = '';
                         const email: string = ''): Tregistro_0100 ;

    function NewReg_0140(const codigo: Integer;
                         const nome, cnpj, uf, ie: string ;
                         const codmun: Integer;
                         const im: string='';
                         const suframa: string=''): Tregistro_0140;

    function NewReg_0150(const cod_part, nome:string;
                         const cnpj,cpf,ie:string;
                         const endere  :string	;
                         const comple  :string;
                         const bairro  :string;
                         const cod_mun: Integer;
                         const cod_pais:Integer=TDefValue.COD_BACEN_BRASIL): Tregistro_0150;

    function NewReg_0190(const InUnid: string; out OuUnid: string): Tregistro_0190;

    function NewReg_0200(const cod_item, descr_item, cod_bar: string;
                         out und_iven: string;
                         const tipo_item: TItemTyp=itmRevenda;
                         const cod_ncm: string='';
                         const cod_gen: Integer=00;
                         const aliq_icms: Currency=0.00): Tregistro_0200;

    constructor Create(ABloco_9: TBloco_9);
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
    fBloco_9 :=ABloco_9;
    registro_0000 :=Tregistro_0000.Create(Self);
    registro_0001 :=Tregistro_0001.Create(Self);
    registro_0990 :=Tregistro_0990.Create(Self);
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

    for I :=0 to registro_0001.registro_0100.Count -1 do
    begin
        AFile.NewLine(registro_0001.registro_0100.Items[I].Row);
    end;

    AFile.NewLine(registro_0001.registro_0110.Row);
    //AFile.NewLine(registro_0001.registro_0110.registro_0111.Row);

    for I :=0 to registro_0001.registro_0140.Count -1 do
    begin
        AFile.NewLine(registro_0001.registro_0140.Items[I].Row);
    end;

    for I :=0 to registro_0001.registro_0150.Count -1 do
    begin
        AFile.NewLine(registro_0001.registro_0150.Items[I].Row);
    end;

    for I :=0 to registro_0001.registro_0190.Count -1 do
    begin
        AFile.NewLine(registro_0001.registro_0190.Items[I].Row);
    end;

    for I :=0 to registro_0001.registro_0200.Count -1 do
    begin
        AFile.NewLine(registro_0001.registro_0200.Items[I].Row);
    end;

    AFile.NewLine(registro_0990.Row);
end;

procedure TBloco_0.DoInc(const qtd_lin: Integer);
begin
    Inc(Self.registro_0990.qtd_lin_B0, qtd_lin) ;
end;

function TBloco_0.NewReg_0100(const nome, cpf, crc, cnpj: string;
                              const endere, bairro, cep: string;
                              const codmun: Integer ;
                              const fone, fax, email: string): Tregistro_0100;
begin
    Result :=registro_0001.registro_0100.IndexOf(cpf) ;
    if Result = nil then
    begin
        Result :=registro_0001.registro_0100.AddNew ;
        Result.nome :=nome ;
        Result.cpf :=cpf ;
        Result.crc :=crc ;
        Result.cnpj :=cnpj;
        Result.cep :=cep;
        Result.endere :=endere;
        Result.bairro :=bairro;
        Result.cod_mun :=codmun;
    end;
end;

function TBloco_0.NewReg_0140(const codigo: Integer;
                              const nome, cnpj, uf, ie: string;
                              const codmun: Integer;
                              const im, suframa: string): Tregistro_0140;
begin
    Result :=registro_0001.registro_0140.IndexOf(codigo) ;
    if Result = nil then
    begin
        Result :=registro_0001.registro_0140.AddNew ;
        Result.codigo :=codigo;
        Result.nome :=nome;
        Result.cnpj :=cnpj;
        Result.uf :=uf ;
        Result.ie :=ie ;
        Result.cod_mun :=codmun;
    end;
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
    OuUnid :=UpperCase(InUnid);
    if (OuUnid='DP')or(OuUnid='JG')or(OuUnid='RL')or(OuUnid='')or(OuUnid='VD')then
    begin
        OuUnid :='UN' ;
    end;
    Result	:=Self.registro_0001.registro_0190.IndexOf(OuUnid) ;
    if Result = nil then
    begin
        Result	:=Self.registro_0001.registro_0190.AddNew	;
        Result.unidad	:=OuUnid;
    end ;
    if 			OuUnid='CX' then	Result.descri:='CAIXA'
    else if OuUnid='LT' then	Result.descri:='LITRO'
    else if OuUnid='KG' then	Result.descri:='KILO'
    else if OuUnid='PT' then	Result.descri:='PACOTE'
    else begin
        Result.descri	:='UNIDADE';
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
        Result.cod_item   :=cod_item;
        Result.descr_item	  :=descr_item;
        Result.cod_bar  :=cod_bar;
        Result.und_iven	:=und_iven;
        Result.tipo     :=tipo_item ;
        if Length(cod_ncm)=8 then
        begin
        	Result.cod_ncm  :=cod_ncm;
        end;
        Result.cod_gen  :=cod_gen;
        Result.aliq_icms:=aliq_icms;
    end;
end;

{ Tregistro_0000 }

constructor Tregistro_0000.Create(AOwner: TBloco_0);
begin
    inherited Create('0000');
    fOwner :=AOwner ;
    cod_ver:=cvl104 ;
    tip_esc:=escOrig ;
    ind_sit_esp:=seAbertura;
    ind_nat_pj :=npjGeral ;
    ind_ativ  :=taCom ;
end;

function Tregistro_0000.GetRow: string;
begin
    Result :=        Tefd_util.SEP_FIELD +Self.reg ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.cod_ver),3);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.tip_esc),1,'0');
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_sit_esp),1,'0');
    Result :=Result +Tefd_util.SEP_FIELD +Self.num_rec_ant ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FDat(Self.dt_ini) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FDat(Self.dt_fin) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.nome,100);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cnpj,14);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.uf,2);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cod_mun,7) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.suframa,9);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_nat_pj),2);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_ativ)) ;
    Result :=Result +Tefd_util.SEP_FIELD ;
    //
    fOwner.DoInc();
    fOwner.fBloco_9.UpdateReg(Self.reg);
end;

{ Tregistro_0001 }

constructor Tregistro_0001.Create(AOwner: TBloco_0);
begin
    inherited Create('0001');
    fOwner :=AOwner  ;
    registro_0100:=Tregistro_0100List.Create(Self) ;
    registro_0110:=Tregistro_0110.Create(Self) ;
    registro_0140:=Tregistro_0140List.Create(Self) ;
    registro_0150:=Tregistro_0150List.Create(Self) ;
    registro_0190:=Tregistro_0190List.Create(Self) ;
    registro_0200:=Tregistro_0200List.Create(Self) ;
end;

destructor Tregistro_0001.Destroy;
begin
    registro_0100.Destroy ;
    registro_0110.Destroy ;
    registro_0140.Destroy ;
    registro_0150.Destroy ;
    registro_0190.Destroy ;
    registro_0200.Destroy ;
    inherited Destroy ;
end;

function Tregistro_0001.GetRow: string;
begin
    Result :=inherited GetRow ;
//    Result :=        Tefd_util.SEP_FIELD +Self.reg;
//    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_mov),1,'0') ;
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
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.qtd_lin_B0);
    Result :=Result +Tefd_util.SEP_FIELD ;
    fOwner.fBloco_9.UpdateReg(Self.Reg);
end;

{ Tregistro_0100List }

function Tregistro_0100List.AddNew: Tregistro_0100;
begin
    Result :=Tregistro_0100.Create('0100') ;
    Result.fOwner :=Self ;
    Result.Status :=rsNew;
    inherited Add(Result);

    // registra nos contadores
    fOwner.fOwner.DoInc();
    fOwner.fOwner.fBloco_9.UpdateReg(Result.reg) ;
end;

constructor Tregistro_0100List.Create(AOwner: Tregistro_0001);
begin
    inherited Create ;
    fOwner :=AOwner ;
end;

function Tregistro_0100List.Get(Index: Integer): Tregistro_0100;
begin
    Result :=Tregistro_0100(inherited Items[Index]) ;
end;

function Tregistro_0100List.IndexOf(const cpf: string): Tregistro_0100;
var
    I:Integer ;
begin
    Result :=nil  ;
    for I :=0 to Self.Count -1 do
    begin
        if Self.Items[I].cpf=cpf then
        begin
            Result :=Self.Items[I] ;
            Result.Status :=rsRead ;
            Break ;
        end;
    end;
end;

{ Tregistro_0100 }

function Tregistro_0100.GetRow: string;
begin
    Result :=inherited GetRow();
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


{ Tregistro_0110 }

constructor Tregistro_0110.Create(AOwner: Tregistro_0001);
begin
    inherited Create('0110');
    fOwner :=AOwner ;
    registro_0111 :=Tregistro_0111.Create(Self)  ;
end;

destructor Tregistro_0110.Destroy;
begin
    registro_0111.Destroy ;
    inherited Destroy ;
end;

function Tregistro_0110.GetRow: string;
begin
    Result :=        Tefd_util.SEP_FIELD +Self.reg ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.cod_inc_trib));
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_apr_cred));
    Result :=Result +Tefd_util.SEP_FIELD;// +Tefd_util.FInt(Ord(Self.cod_tip_cntr));
    Result :=Result +Tefd_util.SEP_FIELD;// +Tefd_util.FInt(Ord(Self.ind_reg_cum)) ;
    Result :=Result +Tefd_util.SEP_FIELD ;
    // registra nos totalizadores
    fOwner.fOwner.DoInc();
    fOwner.fOwner.fBloco_9.UpdateReg(Self.reg) ;
end;

{ Tregistro_0111 }

constructor Tregistro_0111.Create(AOwner: Tregistro_0110);
begin
    inherited Create('0111');
    fOwner :=AOwner ;
end;

function Tregistro_0111.GetRow: string;
begin
    Result :=        Tefd_util.SEP_FIELD +Self.reg ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.rec_bru_ncum_trib_mi);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.rec_bru_ncum_nt_mi);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.rec_bru_ncum_exp);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.rec_bru_cum);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.rec_bru_total);
    Result :=Result +Tefd_util.SEP_FIELD ;
    // registra nos totalizadores
    fOwner.fOwner.fOwner.DoInc();
    fOwner.fOwner.fOwner.fBloco_9.UpdateReg(Self.reg) ;
end;

{ Tregistro_0140List }

function Tregistro_0140List.AddNew: Tregistro_0140;
begin
    Result :=Tregistro_0140.Create('0140');
    Result.fOwner :=Self ;
    Result.Status :=rsNew;
    inherited Add(Result) ;

    // registra nos totalizadores
    fOwner.fOwner.DoInc();
    fOwner.fOwner.fBloco_9.UpdateReg(Result.Reg) ;
end;

constructor Tregistro_0140List.Create(AOwner: Tregistro_0001);
begin
    inherited Create();
    fOwner :=AOwner ;

end;

function Tregistro_0140List.Get(Index: Integer): Tregistro_0140;
begin
    Result :=Tregistro_0140(inherited Items[Index]) ;
end;

function Tregistro_0140List.IndexOf(const codigo: Integer): Tregistro_0140;
var
    I:Integer ;
begin
    Result :=nil  ;
    for I :=0 to Self.Count -1 do
    begin
        if Self.Items[I].codigo=codigo then
        begin
            Result :=Self.Items[I] ;
            Result.Status :=rsEdit ;
            Break ;
        end;
    end;
end;


{ Tregistro_0140 }

function Tregistro_0140.GetRow: string;
begin
    Result :=        Tefd_util.SEP_FIELD +Self.reg ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.codigo) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.nome,100) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cnpj,14) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.uf,2) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.ie,14) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cod_mun,7) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.im,11) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.suframa,9) ;
    Result :=Result +Tefd_util.SEP_FIELD ;
end;

end.
