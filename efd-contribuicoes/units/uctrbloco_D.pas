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
|   BLOCO D: DOCUMENTOS FISCAIS II – SERVIÇOS (ICMS)
|
|Historico  Descrição
|*******************************************************************************
|16.08.2012 Cada bloco possui sua unit (antiga uefd_piscofins.pas mapeada units)
|20.12.2011 Versão inicial (Guia Prático EFD-PIS/COFINS – Versão 1.0.3
|                           Atualização: 01 de setembro de 2011)
*}
unit uctrbloco_D;

interface

uses Windows,
	Messages,
  SysUtils,
  Classes ,
  Contnrs ,
  EFDCommon;

type
  //Indicador da Natureza do Frete Contratado, referente a:
  TIndNatFret = (
    natfret_0 , //0 – Operações de vendas, com ônus suportado pelo estabelecimento vendedor;
    natfret_1,  //1 – Operações de vendas, com ônus suportado pelo adquirente;
    natfret_2,  //2 – Operações de compras (bens para revenda, matériasprima e outros produtos, geradores de crédito);
    natfret_3,  //3 – Operações de compras (bens para revenda, matériasprima e outros produtos, não geradores de crédito);
    natfret_4,  //4 – Transferência de produtos acabados entre estabelecimentos da pessoa jurídica;
    natfret_5,  //5 – Transferência de produtos em elaboração entre estabelecimentos da pessoa jurídica
    natfret_9=9  //9 – Outras.
  );


{$REGION 'BLOCO D: DOCUMENTOS FISCAIS II - SERVIÇOS (ICMS)'}
type
  TBloco_D = class ;
  Tregistro_D010List = class;
  Tregistro_D100 = class ;
  Tregistro_D100List = class;
  Tregistro_D101List = class;
  Tregistro_D105List = class;

  {$REGION 'REGISTRO D001: ABERTURA DO BLOCO D'}
  Tregistro_D001 = class(TOpenBloco)
  private
    fOwner: TBloco_D;
  protected
    function GetRow: string; override ;
  public
    registro_D010: Tregistro_D010List ;
    constructor Create(AOwner: TBloco_D);
    destructor Destroy; override	;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO D010: IDENTIFICAÇÃO DO ESTABELECIMENTO'}
  Tregistro_D010 = class(TBaseRegistro)
  private
    fOwner: Tregistro_D010List ;
  protected
    function GetRow: string; override ;
  public
    cnpj: string ;
    registro_D100: Tregistro_D100List;
    constructor Create();
    function NewReg_D100(const ind_emit: TIndEmiDoc ;
                         const num_doc: Integer ;
                         const cod_mod, ser_doc, sub_ser: string ;
                         const cod_part: string): Tregistro_D100;
  end;

  Tregistro_D010List = class(TBaseEFDList)
  private
    fOwner: Tregistro_D001 ;
    function Get(Index: Integer): Tregistro_D010	;
  public
    property Items[Index: Integer]: Tregistro_D010 read Get;
    function AddNew: Tregistro_D010;
    function IndexOf(const cnpj: string): Tregistro_D010;
  public
    constructor Create(AOwner: Tregistro_D001);
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
    const ind_oper = 0 ;
  public
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
    vl_icms: Currency  ;
    vl_nt_icms: Currency ;
    cod_inf: string ;
    cod_cta: string ;
    function vl_bc_icms: Currency  ;
  public
    registro_D101: Tregistro_D101List;
    registro_D105: Tregistro_D105List;
    constructor Create;
  end;

  Tregistro_D100List = class(TBaseEFDList)
  protected
    fOwner: Tregistro_D010 ;
    function Get(Index: Integer): Tregistro_D100 ;
  public
    property Items[Index: Integer]: Tregistro_D100 read Get;
    constructor Create(AOwner: Tregistro_D010); reintroduce ;
    function AddNew: Tregistro_D100;
    function IndexOf(const ind_emit: TIndEmiDoc ;
                     const num_doc: Integer ;
                     const cod_mod: string ;
                     const ser_doc: string ;
                     const sub_ser: string ;
                     const cod_part: string): Tregistro_D100;
  end;

  {$ENDREGION}

  {$REGION 'REGISTRO D101: COMPLEMENTO DO DOCUMENTO DE TRANSPORTE (Códigos 07,08,8B,09,10,11,26,27 e 57) – PIS/PASEP'}
  Tregistro_D101 = class(TBaseRegistro)
  private
    fOwner: Tregistro_D101List ;
  protected
    function GetRow: string; override ;
  public
    ind_nat_frt: TIndNatFret ;
    vlr_item: Currency  ;
    cst_pis: Byte ;
    nat_bc_cred: string;
    vlr_bc_pis: Currency  ;
    aliq_pis: Currency ;
    cod_cta: string ;
    function vlr_pis: Currency ;
  end	;

  Tregistro_D101List = class (TBaseEFDList)
  private
    fOwner: Tregistro_D100 ;
    function Get(Index: Integer): Tregistro_D101	;
  public
    property Items[Index: Integer]: Tregistro_D101 read Get;
    function AddNew: Tregistro_D101;
    function IndexOf(const nat_frt: TIndNatFret): Tregistro_D101;
  public
    constructor Create(AOwner: Tregistro_D100) ;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO D105: COMPLEMENTO DO DOCUMENTO DE TRANSPORTE (Códigos 07,08,8B,09,10,11,26,27 e 57) – COFINS'}
  Tregistro_D105 = class(TBaseRegistro)
  private
    fOwner: Tregistro_D105List ;
  protected
    function GetRow: string; override ;
  public
    ind_nat_frt: TIndNatFret ;
    vlr_item: Currency  ;
    cst_cofins: Byte ;
    nat_bc_cred: string;
    vlr_bc_cofins: Currency  ;
    aliq_cofins: Currency ;
    cod_cta: string ;
    function vlr_cofins: Currency;
  end	;

  Tregistro_D105List = class (TBaseEFDList)
  private
    fOwner: Tregistro_D100 ;
    function Get(Index: Integer): Tregistro_D105	;
  public
    property Items[Index: Integer]: Tregistro_D105 read Get;
    function AddNew: Tregistro_D105;
    function IndexOf(const nat_frt: TIndNatFret): Tregistro_D105;
  public
    constructor Create(AOwner: Tregistro_D100) ;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO D990: ENCERRAMENTO DO BLOCO D'}
  Tregistro_D990 = class(TBaseRegistro)
  private
    fOwner: TBloco_D;
  protected
    function GetRow: string; override ;
  public
    qtd_lin_BD:Integer;
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
    constructor Create(ABloco_9: TBloco_9); reintroduce ;
    destructor Destroy; override;
    procedure DoExec(AFile: TFileEFD) ;
  public
    function NewReg_D010(const cnpj: string): Tregistro_D010;
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
    I,J,K:Integer ;
var
    r_D010: Tregistro_D010 ;
    r_D100: Tregistro_D100 ;
    r_D101: Tregistro_D101 ;
    r_D105: Tregistro_D105 ;
begin
    AFile.NewLine(registro_D001.Row);

    for I :=0 to registro_D001.registro_D010.Count -1 do
    begin
        r_D010 :=registro_D001.registro_D010.Items[I] ;
        AFile.NewLine(r_D010.Row);
        for J :=0 to r_D010.registro_D100.Count - 1 do
        begin
            r_D100 :=r_D010.registro_D100.Items[J] ;
            AFile.NewLine(r_D100.Row);
            for K :=0 to r_D100.registro_D101.Count - 1 do
            begin
                r_D101 :=r_D100.registro_D101.Items[K];
                AFile.NewLine(r_D101.Row);
            end;
            for K :=0 to r_D100.registro_D105.Count - 1 do
            begin
                r_D105 :=r_D100.registro_D105.Items[K];
                AFile.NewLine(r_D105.Row);
            end;
        end;
    end;
    AFile.NewLine(registro_D990.Row);
end;

procedure TBloco_D.DoInc(const qtd_lin: Integer);
begin
    Inc(Self.registro_D990.qtd_lin_BD, qtd_lin) ;
end;

function TBloco_D.NewReg_D010(const cnpj: string): Tregistro_D010;
begin
    Result :=Self.registro_D001.registro_D010.IndexOf(cnpj) ;
    if Result = nil then
    begin
        Result :=Self.registro_D001.registro_D010.AddNew ;
        Result.cnpj :=cnpj ;
    end;
end;

{ Tregistro_D001 }

constructor Tregistro_D001.Create(AOwner: TBloco_D);
begin
    inherited Create('D001');
    fOwner :=AOwner ;
    ind_mov:=movNoDat ;
    registro_D010 :=Tregistro_D010List.Create(Self) ;
end;

destructor Tregistro_D001.Destroy;
begin
    registro_D010.Destroy;
    inherited;
end;

function Tregistro_D001.GetRow: string;
begin
    Result :=inherited GetRow;
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

{ Tregistro_D010List }

function Tregistro_D010List.AddNew: Tregistro_D010;
begin
    Result :=Tregistro_D010.Create;
    Result.fOwner :=Self  ;
    Result.Status :=rsNew ;
    inherited Add(Result) ;

    // indica movimento
    fOwner.ind_mov :=movDat;
    // registra nos totalizadores
    fOwner.fOwner.DoInc();
    fOwner.fOwner.fBloco_9.UpdateReg(Result.Reg) ;
end;

constructor Tregistro_D010List.Create(AOwner: Tregistro_D001);
begin
    inherited Create;
    fOwner :=AOwner ;
end;

function Tregistro_D010List.Get(Index: Integer): Tregistro_D010;
begin
    Result :=Tregistro_D010(inherited Items[Index]) ;
end;

function Tregistro_D010List.IndexOf(const cnpj: string): Tregistro_D010;
var
    I:Integer ;
begin
    Result :=nil ;
    for I :=0 to Self.Count -1 do
    begin
        if Self.Items[I].cnpj =cnpj then
        begin
            Result :=Self.Items[I] ;
            Result.Status :=rsRead ;
            Break ;
        end;
    end;
end;

{ Tregistro_D010 }

constructor Tregistro_D010.Create;
begin
    inherited Create('D010');
    registro_D100:=Tregistro_D100List.Create(Self);
end;

function Tregistro_D010.GetRow: string;
begin
    Result :=        Tefd_util.SEP_FIELD +Self.Reg ;
    Result :=Result +Tefd_util.SEP_FIELD +Self.cnpj ;
    Result :=Result +Tefd_util.SEP_FIELD ;
end;

function Tregistro_D010.NewReg_D100(const ind_emit: TIndEmiDoc ;
                              const num_doc: Integer;
                              const cod_mod, ser_doc, sub_ser: string ;
                              const cod_part: string): Tregistro_D100;
begin
    Result :=Self.registro_D100.IndexOf(ind_emit,
                                        num_doc ,
                                        cod_mod ,
                                        ser_doc ,
                                        sub_ser ,
                                        cod_part);
    if Result = nil then
    begin
        Result :=Self.registro_D100.AddNew ;
        Result.ind_emit :=ind_emit;
        Result.cod_part :=cod_part;
        Result.cod_mod  :=cod_mod;
        Result.ser_doc  :=ser_doc;
        Result.sub_ser  :=sub_ser;
        Result.num_doc  :=num_doc;
    end;
end;

{ Tregistro_D100List }

function Tregistro_D100List.AddNew: Tregistro_D100;
begin
    Result :=Tregistro_D100.Create  ;
    Result.fOwner :=Self  ;
    inherited Add(Result) ;

    // registra nos totalizadores
    fOwner.fOwner.fOwner.fOwner.DoInc();
    fOwner.fOwner.fOwner.fOwner.fBloco_9.UpdateReg(Result.Reg) ;
    // indica movimento
    fOwner.fOwner.fOwner.ind_mov :=movDat;
end;

constructor Tregistro_D100List.Create(AOwner: Tregistro_D010);
begin
    inherited Create();
    fOwner :=AOwner ;
end;

function Tregistro_D100List.Get(Index: Integer): Tregistro_D100;
begin
    Result :=Tregistro_D100(inherited Items[Index]);
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
    Self.ind_emit :=emiProp;
    Self.Status   :=rsNew ;
    registro_D101:=Tregistro_D101List.Create(Self) ;
    registro_D105:=Tregistro_D105List.Create(Self) ;
end;

function Tregistro_D100.GetRow: string;
begin
    Result :=        Tefd_util.SEP_FIELD +Self.reg;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.ind_oper,1,'0');
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
    Result :=Self.vl_serv -Self.vl_nt_icms  ;
end;

{ Tregistro_D101List }

function Tregistro_D101List.AddNew: Tregistro_D101;
begin
    Result :=Tregistro_D101.Create('D101');
    Result.fOwner :=Self ;
    Result.Status :=rsNew;
    inherited Add(Result);

    // registra nos totalizadores
    fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.DoInc();
    fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.fBloco_9.UpdateReg(Result.Reg) ;
end;

constructor Tregistro_D101List.Create(AOwner: Tregistro_D100);
begin
    inherited Create();
    fOwner :=AOwner ;
end;

function Tregistro_D101List.Get(Index: Integer): Tregistro_D101;
begin
    Result :=Tregistro_D101(inherited Items[Index]) ;
end;

function Tregistro_D101List.IndexOf(const nat_frt: TIndNatFret): Tregistro_D101;
var
    I:Integer ;
begin
    Result :=nil ;
    for I :=0 to Self.Count -1 do
    begin
        if Self.Items[I].ind_nat_frt = nat_frt then
        begin
            Result :=Self.Items[I] ;
            Break ;
        end;
    end;
end;

{ Tregistro_D101 }

function Tregistro_D101.GetRow: string;
begin
    Result :=        Tefd_util.SEP_FIELD +Self.Reg ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_nat_frt),1,'0') ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vlr_item,'0') ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cst_pis) ;
    Result :=Result +Tefd_util.SEP_FIELD +Self.nat_bc_cred ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vlr_bc_pis) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.aliq_pis,'0.0000') ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vlr_pis) ;
    Result :=Result +Tefd_util.SEP_FIELD +Self.cod_cta ;
    Result :=Result +Tefd_util.SEP_FIELD ;
end;

function Tregistro_D101.vlr_pis: Currency;
begin
    Result :=(Self.vlr_bc_pis *Self.aliq_pis)/100 ;
end;

{ Tregistro_D105List }

function Tregistro_D105List.AddNew: Tregistro_D105;
begin
    Result :=Tregistro_D105.Create('D105');
    Result.fOwner :=Self ;
    Result.Status :=rsNew;
    inherited Add(Result);

    // registra nos totalizadores
    fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.DoInc();
    fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.fBloco_9.UpdateReg(Result.Reg) ;
end;

constructor Tregistro_D105List.Create(AOwner: Tregistro_D100);
begin
    inherited Create();
    fOwner :=AOwner ;
end;

function Tregistro_D105List.Get(Index: Integer): Tregistro_D105;
begin
    Result :=Tregistro_D105(inherited Items[Index]) ;
end;

function Tregistro_D105List.IndexOf(const nat_frt: TIndNatFret): Tregistro_D105;
var
    I:Integer ;
begin
    Result :=nil ;
    for I :=0 to Self.Count -1 do
    begin
        if Self.Items[I].ind_nat_frt = nat_frt then
        begin
            Result :=Self.Items[I] ;
            Break ;
        end;
    end;
end;

{ Tregistro_D105 }

function Tregistro_D105.GetRow: string;
begin
    Result :=        Tefd_util.SEP_FIELD +Self.Reg ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_nat_frt),1,'0') ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vlr_item,'0') ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cst_cofins) ;
    Result :=Result +Tefd_util.SEP_FIELD +Self.nat_bc_cred ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vlr_bc_cofins) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.aliq_cofins,'0.0000') ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vlr_cofins) ;
    Result :=Result +Tefd_util.SEP_FIELD +Self.cod_cta ;
    Result :=Result +Tefd_util.SEP_FIELD ;
end;

function Tregistro_D105.vlr_cofins: Currency;
begin
    Result :=(Self.vlr_bc_cofins *Self.aliq_cofins)/100 ;
end;

end.
