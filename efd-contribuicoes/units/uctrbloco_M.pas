{******************************************************************************}
{                                                                              }
{              SPED Sistema Publico de Escrituracao Digital                    }
{              EFD-Contribuições (PIS/COFINS)                                  }
{              BLOCO A: DOCUMENTOS FISCAIS - SERVIÇOS (ISS)                    }
{              Copyright (c) 1992,2012 Suporteware                             }
{              Created by Carlos Gonzaga                                       }
{                                                                              }
{******************************************************************************}

{*******************************************************************************
|   Classes/Objects e tipos para manipulação/tratar o
|   BLOCO M: APURAÇÃO DA CONTRIBUIÇÃO E CRÉDITO DE PIS/PASEP E DA COFINS
|
|Historico  Descrição
|*******************************************************************************
|16.08.2012 Cada bloco possui sua unit (antiga uefd_piscofins.pas mapeada units)
|20.12.2011 Versão inicial (Guia Prático EFD-PIS/COFINS – Versão 1.0.3
|                           Atualização: 01 de setembro de 2011)
*}
unit uctrbloco_M;

interface

uses Windows,
	Messages,
  SysUtils,
  Classes ,
  EFDCommon;

{$REGION 'BLOCO M: APURAÇÃO DA CONTRIBUIÇÃO E CRÉDITO DE PIS/PASEP E DA COFINS'}
type
  TBloco_M = class ;

  {$REGION 'REGISTRO M001: ABERTURA DO BLOCO M'}
  Tregistro_M001 = class(TOpenBloco)
  private
    fOwner: TBloco_M;
  protected
    function GetRow: string; override	;
  public
    constructor Create(AOwner: TBloco_M);
    destructor Destroy; override	;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO M990: ENCERRAMENTO DO BLOCO M'}
  Tregistro_M990 = class(TBaseRegistro)
  private
    fOwner: TBloco_M;
  protected
    function GetRow: string; override;
  public
    qtd_lin_BM:Integer;
    constructor Create(AOwner: TBloco_M) ;
  end;
  {$ENDREGION}

  TBloco_M = class
  private
    fBloco_9: TBloco_9 ;
    procedure DoInc(const qtd_lin: Integer=1) ;
  public
    registro_M001: Tregistro_M001;
    registro_M990: Tregistro_M990;
  public
    constructor Create(ABloco_9: TBloco_9);
    destructor Destroy; override;
    procedure DoExec(AFile: TFileEFD) ;
  end;

{$ENDREGION}


implementation

uses DateUtils, StrUtils,
  EFDUtils ;


{ TBloco_M }

constructor TBloco_M.Create(ABloco_9: TBloco_9);
begin
    inherited Create();
    fBloco_9 :=ABloco_9 ;
    registro_M001:=Tregistro_M001.Create(Self) ;
    registro_M990:=Tregistro_M990.Create(Self) ;
end;

destructor TBloco_M.Destroy;
begin
    registro_M001.Destroy ;
    registro_M990.Destroy ;
    inherited Destroy;
end;

procedure TBloco_M.DoExec(AFile: TFileEFD);
begin
    AFile.NewLine(registro_M001.Row);
    AFile.NewLine(registro_M990.Row);
end;

procedure TBloco_M.DoInc(const qtd_lin: Integer);
begin
    Inc(Self.registro_M990.qtd_lin_BM, qtd_lin) ;
end;

{ Tregistro_M001 }

constructor Tregistro_M001.Create(AOwner: TBloco_M);
begin
    inherited Create('M001');
    fOwner :=AOwner ;
    ind_mov:=movNoDat ;
end;

destructor Tregistro_M001.Destroy;
begin

    inherited;
end;

function Tregistro_M001.GetRow: string;
begin
    Result :=inherited GetRow ;
    fOwner.DoInc();
    fOwner.fBloco_9.UpdateReg(Self.reg);
end;

{ Tregistro_M990 }

constructor Tregistro_M990.Create(AOwner: TBloco_M);
begin
    inherited Create('M990');
    fOwner :=AOwner ;
end;

function Tregistro_M990.GetRow: string;
begin
    Inc(Self.qtd_lin_BM);
    Result :=        Tefd_util.SEP_FIELD +Self.reg ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.qtd_lin_BM) ;
    Result :=Result +Tefd_util.SEP_FIELD ;
    fOwner.fBloco_9.UpdateReg(Self.Reg);
end;

end.
