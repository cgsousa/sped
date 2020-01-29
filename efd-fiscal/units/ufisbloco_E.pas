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
|   BLOCO E: APURAÇÃO DO ICMS E DO IPI
|
|Historico  Descrição
|******************************************************************************
|01.06.2012 Cada bloco possui sua unit (antiga uefd.pas mapeada para varias...)
|05.05.2011 Adaptado para o estoque
|07.12.2010 Versão inicial (Guia Prático EFD – Versão 2.0.2	Atualização:
|                           08 de setembro de 2010)
*}
unit ufisbloco_E;

interface

uses Windows,
	Messages,
  SysUtils,
  Classes ,
  EFDCommon;

type
  {Indicador da origem do processo:}
  TIndOrigProc = (opSefaz, // 0- SEFAZ;
                  opJustFederal, // 1- Justiça Federal;
                  opJustEstado , // 2- Justiça Estadual;
                  opOutr=9 //Outros
                 );

  {Indicador de movimento}
  TIndMovST = (mstSemST , //0–Sem operações com ST
               mstComST   //1–Com operações de ST)
              );

{$REGION 'BLOCO E: APURAÇÃO DO ICMS E DO IPI'}
type
  TBloco_E = class ;
  Tregistro_E100List = class;
  Tregistro_E110 = class ;
  Tregistro_E116List = class;
  Tregistro_E200List = class;
  Tregistro_E210 = class ;

  {$REGION 'REGISTRO E001: ABERTURA DO BLOCO E'}
  Tregistro_E001 = class(TOpenBloco)
  private
    fOwner: TBloco_E;
  protected
    function GetRow: string; override ;
  public
    registro_E100: Tregistro_E100List ;
    registro_E200: Tregistro_E200List ;
    constructor Create(AOwner: TBloco_E);
    destructor Destroy; override	;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO E100: PERÍODO DA APURAÇÃO DO ICMS'}
  Tregistro_E100 = class(TBaseRegistro)
  private
    fOwner: Tregistro_E100List;
  protected
    function GetRow: string; override ;
  public
    dt_ini: TDateTime	;
    dt_fin: TDateTime	;
  public
    registro_E110: Tregistro_E110;
    constructor Create ;
    destructor Destroy; override	;
  end;

  Tregistro_E100List = class(TBaseEFDList)
  private
    fOwner: Tregistro_E001 ;
    function Get(Index: Integer): Tregistro_E100 ;
  public
    property Items[Index: Integer]: Tregistro_E100 read Get;
    constructor Create(AOwner: Tregistro_E001);
    function AddNew: Tregistro_E100;
    function IndexOf(const dta_ini, dta_fin: TDateTime): Tregistro_E100;
  end;

  {$ENDREGION}

  {$REGION 'REGISTRO E110: APURAÇÃO DO ICMS – OPERAÇÕES PRÓPRIAS'}
  Tregistro_E110 = class(TBaseRegistro)
  private
    fOwner: Tregistro_E100 ;
  protected
    function GetRow: string; override ;
  public
    vlr_tot_debitos     : Currency;
    vlr_ajt_debitos     : Currency;
    vlr_tot_ajt_debitos : Currency;
    vlr_estorn_cred     : Currency;
    vlr_tot_creditos  	: Currency;
    vlr_ajt_cred        : Currency;
    vlr_tot_ajt_cred    : Currency;
    vlr_estorn_deb      : Currency;
    vlr_sld_cred_ant    : Currency;
    vlr_tot_ded         : Currency;
    vlr_sld_cred_trans  : Currency;
    vlr_deb_esp         : Currency;
    function vlr_sld_apurado: Currency;
    function vlr_icms_recolh: Currency;
  public
    registro_E116: Tregistro_E116List	;
    constructor Create(AOwner: Tregistro_E100);
    destructor Destroy; override	;
  end	;
  {$ENDREGION}

  {$REGION 'REGISTRO E116: OBRIGAÇÕES DO ICMS A RECOLHER – OPERAÇÕES PRÓPRIAS'}
  Tregistro_E116 = class(TBaseRegistro)
  private
    fOwner: Tregistro_E116List;
  protected
    function GetRow: string; override ;
  public
    cod_obg: string	;
    vlr_obg: Currency	;
    dta_vcto: TDateTime	;
    cod_rec: string	;
    num_proc: string	;
    ind_proc: TIndOrigProc ;
    descr_proc: string	;
    txt_compl: string	;
    mes_ref: string	;
  end;

  Tregistro_E116List = class(TBaseEFDList)
  private
    fOwner: Tregistro_E110 ;
    function Get(Index: Integer): Tregistro_E116 ;
  public
    property Items[Index: Integer]: Tregistro_E116 read Get;
    constructor Create(AOwner: Tregistro_E110);
    function AddNew: Tregistro_E116;
    function IndexOf(const cod_obg: string): Tregistro_E116;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO E200: PERÍODO DA APURAÇÃO DO ICMS - SUBSTITUIÇÃO TRIBUTÁRIA'}
  Tregistro_E200 = class(TBaseRegistro)
  private
    fOwner: Tregistro_E200List ;
  protected
    function GetRow: string; override ;
  public
    uf: string;
    dt_ini: TDateTime	;
    dt_fin: TDateTime	;
  public
    registro_E210: Tregistro_E210	;
    constructor Create ;
    destructor Destroy; override	;
  end;

  Tregistro_E200List = class(TBaseEFDList)
  protected
    fOwner: Tregistro_E001 ;
    function Get(Index: Integer): Tregistro_E200 ;
  public
    property Items[Index: Integer]: Tregistro_E200 read Get;
    constructor Create(AOwner: Tregistro_E001); reintroduce ;
    function AddNew: Tregistro_E200;
    function IndexOf(const uf: string): Tregistro_E200;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO E210: APURAÇÃO DO ICMS – SUBSTITUIÇÃO TRIBUTÁRIA'}
  Tregistro_E210 = class(TBaseRegistro)
  private
    fOwner: Tregistro_E200 ;
  protected
    function GetRow: string; override ;
  public
    ind_mov_st: TIndMovST;      //Indicador de movimento: (0–Sem operações com ST,1–Com operações de ST)
    vl_sld_cre_ant_st: Currency;//Valor do "Saldo credor de período anterior ST"
    vl_devol_st: Currency;			//Valor total do ICMS ST de devolução de mercadorias
    vl_res_st: Currency	; 			//Valor total do ICMS ST de ressarcimentos
    vl_out_cre_st: Currency;    // Valor total de Ajustes "Outros créditos ST" e “Estorno de débitos ST”
    vl_ajt_cre_st: Currency;    //Valor total dos ajustes a crédito de ICMS ST, provenientes de ajustes do documento fiscal
    vl_ret_st: Currency	;		    //Valor Total do ICMS retido por Substituição Tributária
    vl_out_deb_st: Currency;    // Valor Total dos ajustes "Outros débitos ST" " e “Estorno de créditos ST”
    vl_ajt_deb_st: Currency;    //Valor total dos ajustes a débito de ICMS ST, provenientes de ajustes do documento fiscal
    vl_sld_dev_ant_st: Currency;//Valor total de Saldo devedor antes das deduções
    vl_ded_st: Currency;        //Valor total dos ajustes "Deduções ST"
    vl_icms_st: Currency;       //Imposto a recolher ST (11-12)
    deb_esp_st: Currency ;	//Valores recolhidos ou a recolher, extraapuração
    //Saldo credor de ST a transportar para o período eguinte [(03+04+05+06+07)–(08+09+10)]
    function sld_cre_st_transp: Currency;
  public
    constructor Create(AOwner: Tregistro_E200); reintroduce ;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO E990: ENCERRAMENTO DO BLOCO E'}
  Tregistro_E990 = class(TBaseRegistro)
  private
    fOwner: TBloco_E;
  protected
    function GetRow: string; override ;
  public
    qtd_lin_BE:Integer	;
    constructor Create(AOwner: TBloco_E) ;
  end;
  {$ENDREGION}


  TBloco_E = class
  private
    fBloco_9: TBloco_9 ;
    procedure DoInc(const qtd_lin: Integer=1) ;
  public
    registro_E001: Tregistro_E001;
    registro_E990: Tregistro_E990;
  public
    constructor Create(ABloco_9: TBloco_9);
    destructor Destroy; override;
    procedure DoInit(const dta_ini, dta_fin: TDateTime) ;
    procedure DoExec(AFile: TFileEFD) ;
  end;

{$ENDREGION}


implementation

uses DateUtils, StrUtils,
  EFDUtils ,
  ufisbloco_0,
  ufisbloco_C,
  ufisbloco_D;


{ TBloco_E }

constructor TBloco_E.Create(ABloco_9: TBloco_9);
begin
    inherited Create();
    fBloco_9 :=ABloco_9 ;
    registro_E001:=Tregistro_E001.Create(Self) ;
    registro_E990:=Tregistro_E990.Create(Self) ;
end;

destructor TBloco_E.Destroy;
begin
    registro_E001.Destroy;
    registro_E990.Destroy;
    inherited Destroy;
end;

procedure TBloco_E.DoExec(AFile: TFileEFD);
var
		I,J:Integer	;
var
    r_E100: Tregistro_E100	;
    r_E116: Tregistro_E116	;
    r_E200: Tregistro_E200	;

begin

    AFile.NewLine(registro_E001.Row);
    for I :=0 to registro_E001.registro_E100.Count -1 do
    begin
        r_E100 :=registro_E001.registro_E100.Items[I] ;
        AFile.NewLine(r_E100.Row);
        AFile.NewLine(r_E100.registro_E110.Row);
        for J :=0 to r_E100.registro_E110.registro_E116.Count -1 do
        begin
            r_E116 :=r_E100.registro_E110.registro_E116.Items[J] ;
            AFile.NewLine(r_E116.Row);
        end;
    end;

    for I :=0 to registro_E001.registro_E200.Count -1 do
    begin
        r_E200 :=registro_E001.registro_E200.Items[I] ;
        AFile.NewLine(r_E200.Row);
        AFile.NewLine(r_E200.registro_E210.Row);

    end;

    AFile.NewLine(registro_E990.Row);
end;

procedure TBloco_E.DoInc(const qtd_lin: Integer);
begin
    Inc(Self.registro_E990.qtd_lin_BE, qtd_lin) ;
end;

procedure TBloco_E.DoInit(const dta_ini, dta_fin: TDateTime);
var
    r_E100: Tregistro_E100 ;
    r_E116: Tregistro_E116 ;
begin
  	registro_E001.ind_mov :=movDat ;
    registro_E001.registro_E100.Clear ;
    registro_E001.registro_E200.Clear ;
    r_E100 :=registro_E001.registro_E100.AddNew ;
    r_E100.dt_ini :=dta_ini;
    r_E100.dt_fin :=dta_fin;
    r_E116 :=r_E100.registro_E110.registro_E116.AddNew;
    r_E116.cod_obg	:='000';
    r_E116.vlr_obg	:=0 ;
    r_E116.dta_vcto :=dta_fin;
    r_E116.cod_rec	:='12345678' ;
    r_E116.num_proc :='12345678' ;
    r_E116.ind_proc :=opJustEstado;
    r_E116.descr_proc:='DESCRICAO RESUMIDA DO PROCESSO';
    r_E116.mes_ref	 :=FormatDateTime('mmyyyy', dta_fin);
end;

{ Tregistro_E001 }

constructor Tregistro_E001.Create(AOwner: TBloco_E);
begin
    inherited Create('E001');
    fOwner :=AOwner ;
    ind_mov:=movDat ;
    registro_E100 :=Tregistro_E100List.Create(Self) ;
    registro_E200 :=Tregistro_E200List.Create(Self) ;
end;

destructor Tregistro_E001.Destroy;
begin
    registro_E100.Destroy ;
    registro_E200.Destroy ;
    inherited;
end;

function Tregistro_E001.GetRow: string;
begin
    Result :=inherited GetRow;
//    Result :=        Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.reg) ;
//    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_mov),1,'0') ;
//    Result :=Result +Tefd_util.SEP_FIELD;

    fOwner.DoInc();
    fOwner.fBloco_9.UpdateReg(Self.reg);
end;

{ Tregistro_E990 }

constructor Tregistro_E990.Create(AOwner: TBloco_E);
begin
    inherited Create('E990');
    fOwner :=AOwner ;
end;

function Tregistro_E990.GetRow: string;
begin
    Inc(Self.qtd_lin_BE);
    Result :=        Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.reg) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.qtd_lin_BE) ;
    Result :=Result +Tefd_util.SEP_FIELD ;
    fOwner.fBloco_9.UpdateReg(Self.reg);
end;

{ Tregistro_E100List }

function Tregistro_E100List.AddNew: Tregistro_E100;
begin
    Result :=Tregistro_E100.Create ;
    Result.fOwner :=Self ;
    inherited Add(Result) ;

    // registra nos totalizadores
    fOwner.fOwner.DoInc();
    fOwner.fOwner.fBloco_9.UpdateReg(Result.Reg) ;
end;

constructor Tregistro_E100List.Create(AOwner: Tregistro_E001);
begin
    inherited Create;
    fOwner :=AOwner ;
end;

function Tregistro_E100List.Get(Index: Integer): Tregistro_E100;
begin
    Result :=Tregistro_E100(inherited Items[Index]) ;
end;

function Tregistro_E100List.IndexOf(const dta_ini, dta_fin: TDateTime): Tregistro_E100;
var
    I:Integer ;
begin
    Result :=nil  ;
    for I :=0 to Self.Count -1 do
    begin
        if(Self.Items[I].dt_ini =dta_ini)and
          (Self.Items[I].dt_fin =dta_fin)then
        begin
            Result :=Self.Items[I] ;
            Break ;
        end;
    end;
end;

{ Tregistro_E100 }

constructor Tregistro_E100.Create;
begin
    inherited Create('E100');
    registro_E110:=Tregistro_E110.Create(Self) ;
end;

destructor Tregistro_E100.Destroy;
begin
    registro_E110.Destroy;
    inherited Destroy;
end;

function Tregistro_E100.GetRow: string;
begin
		Result  :=Tefd_util.SEP_FIELD + Self.reg;
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FDat(Self.dt_ini);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FDat(Self.dt_fin);
    Result	:=Result +Tefd_util.SEP_FIELD ;
end;

{ Tregistro_E110 }

constructor Tregistro_E110.Create(AOwner: Tregistro_E100);
begin
    inherited Create('E110');
    fOwner :=AOwner ;
    registro_E116 :=Tregistro_E116List.Create(Self) ;
end;

destructor Tregistro_E110.Destroy;
begin
    registro_E116.Destroy ;
    inherited Destroy ;
end;

function Tregistro_E110.GetRow: string;
begin
    Result :=         Tefd_util.SEP_FIELD +Self.reg ;
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vlr_tot_debitos,'0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vlr_ajt_debitos,'0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vlr_tot_ajt_debitos,'0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vlr_estorn_cred,'0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vlr_tot_creditos,'0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vlr_ajt_cred,'0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vlr_tot_ajt_cred,'0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vlr_estorn_deb,'0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vlr_sld_cred_ant,'0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vlr_sld_apurado,'0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vlr_tot_ded,'0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vlr_icms_recolh,'0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vlr_sld_cred_trans,'0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vlr_deb_esp,'0');
    Result	:=Result +Tefd_util.SEP_FIELD;

    fOwner.fOwner.fOwner.fOwner.DoInc();
    fOwner.fOwner.fOwner.fOwner.fBloco_9.UpdateReg(Self.reg);
end;

function Tregistro_E110.vlr_icms_recolh: Currency;
begin
    Result	:=vlr_sld_apurado -vlr_tot_ded	;
    if Result<0 then
    begin
      	vlr_sld_cred_trans :=Abs(Result)	;
        Result	:=0	;
    end;
end;

function Tregistro_E110.vlr_sld_apurado: Currency;
begin
    Result :=	vlr_tot_debitos +(vlr_ajt_debitos 	+vlr_tot_ajt_debitos) +
              vlr_estorn_cred -(vlr_tot_creditos	+vlr_ajt_cred 	+
              									vlr_tot_ajt_cred	+vlr_estorn_deb	+
                                vlr_sld_cred_ant);
    if Result>=0 then
    begin
        vlr_sld_cred_trans :=0	;
    end
    else begin
      	vlr_sld_cred_trans :=Abs(Result)	;
        Result	:=0;
    end;
end;

{ Tregistro_E116List }

function Tregistro_E116List.AddNew: Tregistro_E116;
begin
    //RightStr(Self.ClassName, 4);
    Result :=Tregistro_E116.Create('E116');
		Result.fOwner :=Self	;
    inherited Add(Result)	;

    // registra nos totalizadores
    fOwner.fOwner.fOwner.fOwner.fOwner.DoInc();
    fOwner.fOwner.fOwner.fOwner.fOwner.fBloco_9.UpdateReg(Result.reg) ;
end;

constructor Tregistro_E116List.Create(AOwner: Tregistro_E110);
begin
    inherited Create ;
    fOwner :=AOwner ;
end;

function Tregistro_E116List.Get(Index: Integer): Tregistro_E116;
begin
    Result :=Tregistro_E116(inherited Items[Index])	;
end;

function Tregistro_E116List.IndexOf(const cod_obg: string): Tregistro_E116;
var
    I:Integer	;
begin
    Result :=nil	;
    for I :=0 to Self.Count -1 do
    begin
        if Self.Items[i].cod_obg = cod_obg then
        begin
            Result :=Self.Items[I];
            Break	;
        end;
    end;
end;

{ Tregistro_E116 }

function Tregistro_E116.GetRow: string;
begin
    Result :=         Tefd_util.SEP_FIELD +Self.reg ;
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cod_obg,3,True,'000');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vlr_obg,'0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FDat(Self.dta_vcto);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cod_rec,8,False,'0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.num_proc,15,False,'0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_proc));
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.descr_proc,80);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.txt_compl,80);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.mes_ref,6);
    Result	:=Result +Tefd_util.SEP_FIELD ;
end;

{ Tregistro_E200List }

function Tregistro_E200List.AddNew: Tregistro_E200;
begin
    Result :=Tregistro_E200.Create	;
    Result.fOwner :=Self	;
    inherited Add(Result) ;

    // registra nos totalizadores
    fOwner.fOwner.DoInc();
    fOwner.fOwner.fBloco_9.UpdateReg(Result.reg) ;
end;

constructor Tregistro_E200List.Create(AOwner: Tregistro_E001);
begin
    inherited Create();
    fOwner :=AOwner ;
end;

function Tregistro_E200List.Get(Index: Integer): Tregistro_E200;
begin
    Result :=Tregistro_E200(inherited Items[Index])	;
end;

function Tregistro_E200List.IndexOf(const uf: string): Tregistro_E200;
var
  I:Integer	;
begin
    Result :=nil	;
    for I :=0 to Self.Count -1 do
    begin
        if Self.Items[I].uf=uf then
        begin
            Result :=Self.Items[i] ;
            Break	;
        end;
    end;
end;

{ Tregistro_E200 }

constructor Tregistro_E200.Create;
begin
    inherited Create('E200');
    registro_E210:=Tregistro_E210.Create(Self) ;
end;

destructor Tregistro_E200.Destroy;
begin
    registro_E210.Destroy ;
    inherited;
end;

function Tregistro_E200.GetRow: string;
begin
		Result :=         Tefd_util.SEP_FIELD +Self.reg ;
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.uf,2);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FDat(Self.dt_ini);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FDat(Self.dt_fin);
    Result	:=Result +Tefd_util.SEP_FIELD ;
end;

{ Tregistro_E210 }

constructor Tregistro_E210.Create(AOwner: Tregistro_E200);
begin
    inherited Create('E210');
    fOwner :=AOwner ;
end;

function Tregistro_E210.GetRow: string;
begin
		Result :=         Tefd_util.SEP_FIELD +Self.reg ;
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_mov_st));
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_sld_cre_ant_st,'0')	;
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_devol_st,'0')	;
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_res_st,'0')	;
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_out_cre_st,'0')	;
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_ajt_cre_st,'0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_ret_st,'0')	;
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_out_deb_st,'0')	;
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_ajt_deb_st,'0')	;
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_sld_dev_ant_st,'0')	;
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_ded_st,'0')	;
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_icms_st,'0')	;
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.sld_cre_st_transp,'0')	;
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.deb_esp_st,'0');
    Result	:=Result +Tefd_util.SEP_FIELD;
    fOwner.fOwner.fOwner.fOwner.DoInc();
    fOwner.fOwner.fOwner.fOwner.fBloco_9.UpdateReg(Self.reg);
end;

function Tregistro_E210.sld_cre_st_transp: Currency;
begin
    Result := (vl_devol_st 		+vl_res_st 			+vl_out_cre_st +vl_ajt_cre_st +vl_ret_st)-
              (vl_out_deb_st	+vl_ajt_deb_st	+vl_sld_dev_ant_st                      );
end;

end.
