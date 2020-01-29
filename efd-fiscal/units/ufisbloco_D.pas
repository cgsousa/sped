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
|   BLOCO D: DOCUMENTOS FISCAIS II - SERVIÇOS (ICMS)
|
|Historico  Descrição
|******************************************************************************
|01.06.2012 Cada bloco possui sua unit (antiga uefd.pas mapeada para varias...)
|05.05.2011 Adaptado para o estoque
|07.12.2010 Versão inicial (Guia Prático EFD – Versão 2.0.2	Atualização:
|                           08 de setembro de 2010)
*}
unit ufisbloco_D;

interface

uses Windows,
	Messages,
  SysUtils,
  Classes ,
  Contnrs ,
  EFDCommon;

type
  // Indicador do tipo de operação:
  TIndTypOperD = (toAquis, toPrest) ;

{$REGION 'BLOCO D: DOCUMENTOS FISCAIS II - SERVIÇOS (ICMS)'}
type
  TBloco_D = class ;
  Tregistro_D100List = class;
  Tregistro_D190List = class;

  {$REGION 'REGISTRO D001: ABERTURA DO BLOCO D'}
  Tregistro_D001 = class(TOpenBloco)
  private
    fOwner: TBloco_D;
  protected
    function GetRow: string; override ;
  public
    registro_D100: Tregistro_D100List ;
    constructor Create(AOwner: TBloco_D);
    destructor Destroy; override	;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO D100: AQUISIÇÃO DE SERVIÇOS DE TRANSPORTE - NOTA FISCAL DE SERVIÇO DE TRANSPORTE (CÓDIGO 07)
  E CONHECIMENTOS DE TRANSPORTE RODOVIÁRIO DE CARGAS (CÓDIGO 08), CONHECIMENTO DE TRANSPORTE DE CARGAS AVULSO (CÓDIGO 8B),
  AQUAVIÁRIO DE CARGAS (CÓDIGO 09), AÉREO (CÓDIGO 10), FERROVIÁRIO DE CARGAS (CÓDIGO 11), MULTIMODAL DE CARGAS (CÓDIGO 26),
  NOTA FISCAL DE TRANSPORTE FERROVIÁRIO DE CARGA (CÓDIGO 27) E CONHECIMENTO DE TRANSPORTE ELETRÔNICO – CT-e (CÓDIGO 57)'}
  Tregistro_D100 = class(TBaseRegistro)
  private
    fOwner: Tregistro_D100List ;
  protected
    function GetRow: string; override ;
  public
    ind_oper: TIndTypOperD ;
    ind_emit: TIndEmiDoc ;
    cod_part: string ;
    cod_mod: string ;
    cod_sit: TCodSitDoc ;
    ser_doc: string ;
    sub_ser: string ;
    num_doc: Integer;
    chv_cte: string ;
    dta_doc: TDateTime;
    dta_a_p: TDateTime;
    typ_cte: string;
    chv_cte_ref: string ;
    vl_doc: Currency ;
    vl_desc: Currency  ;
    ind_fret: TIndTypFret;
    vl_serv: Currency  ;
    vl_nt_icms: Currency ;
    cod_inf: string ;
    cod_cta: string ;
    function vl_bc_icms: Currency  ;
    function vl_icms: Currency  ;
  public
    registro_D190: Tregistro_D190List ;
    constructor Create ;
  end;

  Tregistro_D100List = class(TBaseEFDList)
  protected
    fOwner: Tregistro_D001 ;
    function Get(Index: Integer): Tregistro_D100 ;
  public
    property Items[Index: Integer]: Tregistro_D100 read Get;
    constructor Create(AOwner: Tregistro_D001); reintroduce ;
    function AddNew: Tregistro_D100;
    function IndexOf(const ind_emit: TIndEmiDoc ;
                     const num_doc: Integer ;
                     const cod_mod: string ;
                     const ser_doc: string ;
                     const sub_ser: string ;
                     const cod_part: string): Tregistro_D100;
  end;

  {$ENDREGION}

  {$REGION 'REGISTRO D190: REGISTRO ANALÍTICO DOS DOCUMENTOS (CÓDIGO 07, 08, 8B, 09, 10, 11, 26, 27 e 57).'}
  Tregistro_D190 = class(TBaseRegistro)
  private
    fOwner: Tregistro_D190List ;
  protected
    function GetRow: string; override ;
  public
    //const reg = 'D190';
    cst_icms: Word ;
    cfop: Word ;
    aliq_icms: Currency ;
    vl_oper: Currency ;
    vl_bc_icms: Currency ;
    vl_icms: Currency ;
    vl_red_bc: Currency ;
    cod_obs: string ;
  end	;

  Tregistro_D190List = class (TBaseEFDList)
  private
    fOwner: Tregistro_D100 ;
    function Get(Index: Integer): Tregistro_D190	;
  public
    property Items[Index: Integer]: Tregistro_D190 read Get;
    constructor Create(AOwner: Tregistro_D100) ;
    function AddNew: Tregistro_D190;
    function IndexOf(const cst_icms, cfop: Word; const aliq_icms: Currency): Tregistro_D190;
    function vlr_bc_icms: Currency ;
    function vlr_icms: Currency	;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO D990: ENCERRAMENTO DO BLOCO D'}
  Tregistro_D990 = class(TBaseRegistro)
  private
    fOwner: TBloco_D;
  protected
    function GetRow: string; override ;
  public
    //const reg = 'D990' ;
    qtd_lin_BD:Integer	;
    constructor Create(AOwner: TBloco_D) ;
  end;
  {$ENDREGION}


  TBloco_D = class
  private
    fBloco_9: TBloco_9 ;
    procedure DoInc(const qtd_lin: Integer=1) ;
  public
    registro_D001: Tregistro_D001;
    registro_D990: Tregistro_D990;
  public
    constructor Create(ABloco_9: TBloco_9); reintroduce ;
    destructor Destroy; override;
    procedure DoExec(AFile: TFileEFD) ;

    function NewReg_D100(const ind_emit: TIndEmiDoc ;
                         const num_doc: Integer ;
                         const cod_mod, ser_doc, sub_ser: string ;
                         const cod_part: string): Tregistro_D100;

  end;

{$ENDREGION}


implementation

uses DateUtils, StrUtils,
  EFDUtils ;



{ TBloco_D }

constructor TBloco_D.Create(ABloco_9: TBloco_9);
begin
    inherited Create();
    fBloco_9 :=ABloco_9 ;
    registro_D001:=Tregistro_D001.Create(Self) ;
    registro_D990:=Tregistro_D990.Create(Self) ;
end;

destructor TBloco_D.Destroy;
begin
    registro_D001.Destroy ;
    registro_D990.Destroy ;
    inherited Destroy ;
end;

procedure TBloco_D.DoExec(AFile: TFileEFD);
var
    I,J:Integer ;
var
    r_D100: Tregistro_D100 ;
begin
    AFile.NewLine(registro_D001.Row);
    if registro_D001.ind_mov=movDat then
    begin
        for I :=0 to registro_D001.registro_D100.Count -1 do
        begin
            r_D100 :=registro_D001.registro_D100.Items[I] ;
            AFile.NewLine(r_D100.Row);
            AFile.NewLine(r_D100.registro_D190.Items[0].Row);
        end;
    end;
    AFile.NewLine(registro_D990.Row);
end;

procedure TBloco_D.DoInc(const qtd_lin: Integer);
begin
    Inc(Self.registro_D990.qtd_lin_BD, qtd_lin) ;
end;

function TBloco_D.NewReg_D100(const ind_emit: TIndEmiDoc ;
                              const num_doc: Integer;
                              const cod_mod, ser_doc, sub_ser: string ;
                              const cod_part: string): Tregistro_D100;
begin
    Result :=Self.registro_D001.registro_D100.IndexOf(ind_emit,
                                                      num_doc ,
                                                      cod_mod ,
                                                      ser_doc ,
                                                      sub_ser ,
                                                      cod_part);
    if Result = nil then
    begin
        Result :=Self.registro_D001.registro_D100.AddNew ;
        Result.ind_oper :=toAquis ;
        Result.ind_emit :=ind_emit;
        Result.cod_part :=cod_part;
        Result.cod_mod  :=cod_mod;
        Result.ser_doc  :=ser_doc;
        Result.sub_ser  :=sub_ser;
        Result.num_doc  :=num_doc;
    end;
end;

{ Tregistro_D001 }

constructor Tregistro_D001.Create(AOwner: TBloco_D);
begin
    inherited Create('D001');
    fOwner :=AOwner ;
    ind_mov:=movNoDat ;
    registro_D100 :=Tregistro_D100List.Create(Self) ;
end;

destructor Tregistro_D001.Destroy;
begin
    registro_D100.Destroy;
    inherited;
end;

function Tregistro_D001.GetRow: string;
begin
    Result :=inherited GetRow;
//    Result :=        Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.reg) ;
//    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_mov),1,'0') ;
//    Result :=Result +Tefd_util.SEP_FIELD ;

    fOwner.DoInc();
    fOwner.fBloco_9.UpdateReg(Self.reg);
end;

{ Tregistro_D990 }

constructor Tregistro_D990.Create(AOwner: TBloco_D);
begin
    inherited Create('D990');
    fOwner :=AOwner ;
end;

function Tregistro_D990.GetRow: string;
begin
    Inc(Self.qtd_lin_BD)	;
    Result :=        Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.reg) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.qtd_lin_BD) ;
    Result :=Result +Tefd_util.SEP_FIELD ;
    fOwner.fBloco_9.UpdateReg(Self.reg);
end;

{ Tregistro_D100List }

function Tregistro_D100List.AddNew: Tregistro_D100;
begin
    Result :=Tregistro_D100.Create  ;
    Result.fOwner :=Self  ;
    inherited Add(Result) ;

    // registra nos totalizadores
    fOwner.fOwner.DoInc();
    fOwner.fOwner.fBloco_9.UpdateReg(Result.Reg) ;
    // indica movimento
    fOwner.ind_mov :=movDat;
end;

constructor Tregistro_D100List.Create(AOwner: Tregistro_D001);
begin
    inherited Create();
    fOwner :=AOwner ;
end;

function Tregistro_D100List.Get(Index: Integer): Tregistro_D100;
begin
    Result :=Tregistro_D100(inherited Items[Index]) ;
end;

function Tregistro_D100List.IndexOf(const ind_emit: TIndEmiDoc ;
                                    const num_doc: Integer;
                                    const cod_mod: string ;
                                    const ser_doc: string ;
                                    const sub_ser: string ;
                                    const cod_part: string): Tregistro_D100;
var
    I:Integer;
begin
    Result :=nil  ;
    for I :=0 to Self.Count -1 do
    begin
        Result :=Self.Items[I];
        if(Result.ind_emit =ind_emit)and
          (Result.num_doc  =num_doc )and
          (Result.cod_mod  =cod_mod )and
          (Result.ser_doc  =ser_doc )and
          (Result.sub_ser  =sub_ser )and
          (Result.cod_part =cod_part)then
        begin
            Result.Status :=rsRead ;
            Break ;
        end
        else
        begin
            Result :=nil ;
        end;
    end;
end;

{ Tregistro_D100 }

constructor Tregistro_D100.Create;
begin
    inherited Create('D100') ;
    Self.ind_oper :=toPrest;
    Self.ind_emit :=emiProp;
    Self.Status :=rsNew ;
    registro_D190:=Tregistro_D190List.Create(Self) ;
end;

function Tregistro_D100.GetRow: string;
begin
    Result :=        Tefd_util.SEP_FIELD +Self.reg;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_oper),1,'0');
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_emit),1,'0');
    Result :=Result +Tefd_util.SEP_FIELD +Self.cod_part ;
    Result :=Result +Tefd_util.SEP_FIELD +Self.cod_mod  ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.cod_sit),2,'00') ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.ser_doc,4) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.sub_ser,3) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.num_doc,9) ;
    Result :=Result +Tefd_util.SEP_FIELD +Self.chv_cte  ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FDat(Self.dta_doc) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FDat(Self.dta_a_p) ;
    Result :=Result +Tefd_util.SEP_FIELD +Self.typ_cte  ;
    Result :=Result +Tefd_util.SEP_FIELD +Self.chv_cte_ref  ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_doc,'0') ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_desc) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_fret)) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_serv,'0') ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_bc_icms) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_icms) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_nt_icms) ;
    Result :=Result +Tefd_util.SEP_FIELD +Self.cod_inf  ;
    Result :=Result +Tefd_util.SEP_FIELD +Self.cod_cta  ;
    Result :=Result +Tefd_util.SEP_FIELD ;
end;

function Tregistro_D100.vl_bc_icms: Currency;
begin
  	Result :=Self.registro_D190.vlr_bc_icms ;
end;

function Tregistro_D100.vl_icms: Currency;
begin
  	Result :=Self.registro_D190.vlr_icms ;
end;

{ Tregistro_D190List }

function Tregistro_D190List.AddNew: Tregistro_D190;
begin
    Result :=Tregistro_D190.Create('D190');
    Result.fOwner :=Self ;
    inherited Add(Result);

    // registra nos totalizadores
    fOwner.fOwner.fOwner.fOwner.DoInc();
    fOwner.fOwner.fOwner.fOwner.fBloco_9.UpdateReg(Result.reg);
end;

constructor Tregistro_D190List.Create(AOwner: Tregistro_D100);
begin
    inherited Create();
    fOwner :=AOwner ;
end;

function Tregistro_D190List.Get(Index: Integer): Tregistro_D190;
begin
    Result :=Tregistro_D190(inherited Items[Index]) ;
end;

function Tregistro_D190List.IndexOf(const cst_icms, cfop: Word;
  const aliq_icms: Currency): Tregistro_D190;
var
    I:Integer ;
begin
    Result :=nil ;
    for I :=0 to Self.Count -1 do
    begin
        if(Self.Items[I].cst_icms =cst_icms )and
          (Self.Items[I].cfop     =cfop     )and
          (Self.Items[I].aliq_icms=aliq_icms)then
        begin
            Result :=Self.Items[I] ;
            Break ;
        end ;
    end;
end;

function Tregistro_D190List.vlr_bc_icms: Currency;
var
    I:Integer ;
begin
    Result :=0;
    for I :=0 to Self.Count -1 do
    begin
        Result :=Result +Self.Items[I].vl_bc_icms  ;
    end;
end;

function Tregistro_D190List.vlr_icms: Currency;
var
    I:Integer ;
begin
    Result :=0;
    for I :=0 to Self.Count -1 do
    begin
        Result :=Result +Self.Items[I].vl_icms  ;
    end;
end;

{ Tregistro_D190 }

function Tregistro_D190.GetRow: string;
begin
    Result :=        Tefd_util.SEP_FIELD +Self.reg ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cst_icms, 3) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cfop, 4) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.aliq_icms, '0.00', '0') ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_oper, '0') ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_bc_icms, '0') ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_icms, '0') ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_red_bc, '0') ;
    Result :=Result +Tefd_util.SEP_FIELD +Self.cod_obs ;
    Result :=Result +Tefd_util.SEP_FIELD ;
end;


end.
