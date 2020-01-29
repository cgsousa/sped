{*****************************************************************************}
{                                                                             }
{              SPED Sistema Publico de Escrituracao Digital                   }
{              SPED Fiscal                                                    }
{              Copyright (c) 1992,2014                                        }
{              Created by Carlos Gonzaga                                      }
{                                                                             }
{*****************************************************************************}

{******************************************************************************
|   Classes/Objects e tipos para criar, manipular e tratar o
|   BLOCO K: CONTROLE DA PRODUÇÃO E DO ESTOQUE
|
|Historico  Descrição
|******************************************************************************
|05.18.2014 Versão inicial (Guia Prático EFD – Versão 2.0.14)
*}
unit ufisbloco_K;

interface

uses Windows,
	Messages,
  SysUtils,
  Classes ,
  Contnrs ,
  EFDCommon;

{$REGION 'BLOCO K: CONTROLE DA PRODUÇÃO E DO ESTOQUE'}
type
  TBloco_K = class ;
//  Tregistro_K100List = class;

  {$REGION 'REGISTRO K001: ABERTURA DO BLOCO K'}
  Tregistro_K001 = class(TOpenBloco)
  private
    fOwner: TBloco_K;
  protected
    function GetRow: string; override ;
  public
    constructor Create(AOwner: TBloco_K);
    destructor Destroy; override	;
  end;
  {$ENDREGION}


  {$REGION 'REGISTRO K100: PERÍODO DE APURAÇÃO DO ICMS/IPI'}
//  Tregistro_K100 = class(TBaseRegistro)
//  private
//    fOwner: Tregistro_K100List ;
//  protected
//    function GetRow: string; override ;
//  public
//    dt_ini: TDateTime;
//    dt_fin: TDateTime;
//    registro_H010: Tregistro_H010List;
//    constructor Create;
//  end;


//  Tregistro_H005List = class(TBaseEFDList)
//  private
//    fOwner: Tregistro_H001;
//    function Get(Index: Integer): Tregistro_H005;
//  public
//    constructor Create(AOwner: Tregistro_H001);
//    property Items[Index: Integer]: Tregistro_H005 read Get;
//    function AddNew: Tregistro_H005;
//    function IndexOf(const dta_iven: TDateTime): Tregistro_H005;
//  end;
  {$ENDREGION}


  {$REGION 'REGISTRO K990: ENCERRAMENTO DO BLOCO K'}
  Tregistro_K990 = class(TBaseRegistro)
  private
    fOwner: TBloco_K;
  protected
    function GetRow: string; override ;
  public
    qtd_lin_BK:Integer;
    constructor Create(AOwner: TBloco_K) ;
  end;
  {$ENDREGION}

  TBloco_K = class
  private
    fBloco_9: TBloco_9 ;
    procedure DoInc(const qtd_lin: Integer=1) ;
  public
    registro_K001: Tregistro_K001;
    registro_K990: Tregistro_K990;
  public
    constructor Create(ABloco_9: TBloco_9);
    destructor Destroy; override;
    procedure DoExec(AFile: TFileEFD) ;
  end;

{$ENDREGION}


implementation

uses DateUtils, StrUtils,
  EFDUtils ;


{ TBloco_K }

constructor TBloco_K.Create(ABloco_9: TBloco_9);
begin
    inherited Create();
    fBloco_9 :=ABloco_9 ;
    registro_K001:=Tregistro_K001.Create(Self) ;
    registro_K990:=Tregistro_K990.Create(Self) ;
end;

destructor TBloco_K.Destroy;
begin
    registro_K001.Destroy ;
    registro_K990.Destroy ;
    inherited Destroy;
end;

procedure TBloco_K.DoExec(AFile: TFileEFD);
begin
    AFile.NewLine(registro_K001.Row);
    AFile.NewLine(registro_K990.Row);
end;

procedure TBloco_K.DoInc(const qtd_lin: Integer);
begin
    Inc(Self.registro_K990.qtd_lin_BK, qtd_lin) ;
end;

{ Tregistro_K001 }

constructor Tregistro_K001.Create(AOwner: TBloco_K);
begin
    inherited Create('K001');
    fOwner :=AOwner ;
    ind_mov:=movNoDat ;
end;

destructor Tregistro_K001.Destroy;
begin

    inherited;
end;

function Tregistro_K001.GetRow: string;
begin
    Result :=inherited GetRow ;
//    Result :=        Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.reg) ;
//    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_mov),1,'0') ;
//    Result :=Result +Tefd_util.SEP_FIELD;

    fOwner.DoInc();
    fOwner.fBloco_9.UpdateReg(Self.reg);
end;

{ Tregistro_K990 }

constructor Tregistro_K990.Create(AOwner: TBloco_K);
begin
    inherited Create('K990');
    fOwner :=AOwner ;
end;

function Tregistro_K990.GetRow: string;
begin
    Inc(Self.qtd_lin_BK);
    Result :=        Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.reg) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.qtd_lin_BK) ;
    Result :=Result +Tefd_util.SEP_FIELD ;
    fOwner.fBloco_9.UpdateReg(Self.reg);
end;

end.
