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
|   BLOCO G: CONTROLE DO CRÉDITO DE ICMS DO ATIVO PERMANENTE – CIAP
|
|Historico  Descrição
|******************************************************************************
|01.06.2012 Cada bloco possui sua unit (antiga uefd.pas mapeada para varias...)
|05.05.2011 Adaptado para o estoque
|07.12.2010 Versão inicial (Guia Prático EFD – Versão 2.0.2	Atualização:
|                           08 de setembro de 2010)
*}
unit ufisbloco_G;

interface

uses Windows,
	Messages,
  SysUtils,
  Classes ,
  Contnrs ,
  EFDCommon;

{$REGION 'BLOCO G: CONTROLE DO CRÉDITO DE ICMS DO ATIVO PERMANENTE – CIAP'}
type
  TBloco_G = class ;

  {$REGION 'REGISTRO G001: ABERTURA DO BLOCO G'}
  Tregistro_G001 = class(TOpenBloco)
  private
    fOwner: TBloco_G;
  protected
    function GetRow: string; override ;
  public
    constructor Create(AOwner: TBloco_G);
    destructor Destroy; override	;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO G990: ENCERRAMENTO DO BLOCO G'}
  Tregistro_G990 = class(TBaseRegistro)
  private
    fOwner: TBloco_G;
  protected
    function GetRow: string; override ;
  public
    qtd_lin_BG:Integer;
    constructor Create(AOwner: TBloco_G) ;
  end;
  {$ENDREGION}

  TBloco_G = class
  private
    fBloco_9: TBloco_9 ;
    procedure DoInc(const qtd_lin: Integer=1) ;
  public
    registro_G001: Tregistro_G001;
    registro_G990: Tregistro_G990;
  public
    constructor Create(ABloco_9: TBloco_9);
    destructor Destroy; override;
    procedure DoExec(AFile: TFileEFD) ;
  end;

{$ENDREGION}


implementation

uses DateUtils, StrUtils,
  EFDUtils ;


{ TBloco_G }

constructor TBloco_G.Create(ABloco_9: TBloco_9);
begin
    inherited Create();
    fBloco_9 :=ABloco_9 ;
    registro_G001:=Tregistro_G001.Create(Self) ;
    registro_G990:=Tregistro_G990.Create(Self) ;
end;

destructor TBloco_G.Destroy;
begin
    registro_G001.Destroy ;
    registro_G990.Destroy ;
    inherited Destroy;
end;

procedure TBloco_G.DoExec(AFile: TFileEFD);
begin
    AFile.NewLine(registro_G001.Row);
    AFile.NewLine(registro_G990.Row);
end;

procedure TBloco_G.DoInc(const qtd_lin: Integer);
begin
    Inc(Self.registro_G990.qtd_lin_BG, qtd_lin) ;
end;

{ Tregistro_G001 }

constructor Tregistro_G001.Create(AOwner: TBloco_G);
begin
    inherited Create('G001');
    fOwner :=AOwner ;
    ind_mov:=movNoDat ;
end;

destructor Tregistro_G001.Destroy;
begin

    inherited;
end;

function Tregistro_G001.GetRow: string;
begin
    Result :=inherited GetRow ;
//    Result :=        Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.reg) ;
//    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_mov),1,'0') ;
//    Result :=Result +Tefd_util.SEP_FIELD;

    fOwner.DoInc();
    fOwner.fBloco_9.UpdateReg(Self.reg);
end;

{ Tregistro_G990 }

constructor Tregistro_G990.Create(AOwner: TBloco_G);
begin
    inherited Create('G990');
    fOwner :=AOwner ;
end;

function Tregistro_G990.GetRow: string;
begin
    Inc(Self.qtd_lin_BG);
    Result :=        Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.reg) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.qtd_lin_BG) ;
    Result :=Result +Tefd_util.SEP_FIELD ;
    fOwner.fBloco_9.UpdateReg(Self.reg);
end;

end.
