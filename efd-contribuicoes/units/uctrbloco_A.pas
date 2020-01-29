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
|   BLOCO A: DOCUMENTOS FISCAIS - SERVIÇOS (ISS)
|
|Historico  Descrição
|*******************************************************************************
|16.08.2012 Cada bloco possui sua unit (antiga uefd_piscofins.pas mapeada units)
|20.12.2011 Versão inicial (Guia Prático EFD-PIS/COFINS – Versão 1.0.3
|                           Atualização: 01 de setembro de 2011)
*}
unit uctrbloco_A;

interface

uses Windows,
	Messages,
  SysUtils,
  Classes ,
  EFDCommon;

{$REGION 'BLOCO A: DOCUMENTOS FISCAIS - SERVIÇOS (ISS)'}
type
  TBloco_A = class ;

  {$REGION 'REGISTRO A001: ABERTURA DO BLOCO A'}
  Tregistro_A001 = class(TOpenBloco)
  private
    fOwner: TBloco_A;
  protected
    function GetRow: string; override	;
  public
    constructor Create(AOwner: TBloco_A);
    destructor Destroy; override	;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO A990: ENCERRAMENTO DO BLOCO A'}
  Tregistro_A990 = class(TBaseRegistro)
  private
    fOwner: TBloco_A;
  protected
    function GetRow: string; override;
  public
    qtd_lin_BA: Integer;
    constructor Create(AOwner: TBloco_A) ;
  end;
  {$ENDREGION}

  TBloco_A = class
  private
    fBloco_9: TBloco_9 ;
    procedure DoInc(const qtd_lin: Integer=1) ;
  public
    registro_A001: Tregistro_A001;
    registro_A990: Tregistro_A990;
  public
    constructor Create(ABloco_9: TBloco_9);
    destructor Destroy; override;
    procedure DoExec(AFile: TFileEFD) ;
  end;

{$ENDREGION}


implementation

uses DateUtils, StrUtils,
  EFDUtils ;


{ TBloco_A }

constructor TBloco_A.Create(ABloco_9: TBloco_9);
begin
    inherited Create();
    fBloco_9 :=ABloco_9 ;
    registro_A001:=Tregistro_A001.Create(Self) ;
    registro_A990:=Tregistro_A990.Create(Self) ;
end;

destructor TBloco_A.Destroy;
begin
    registro_A001.Destroy ;
    registro_A990.Destroy ;
    inherited Destroy;
end;

procedure TBloco_A.DoExec(AFile: TFileEFD);
begin
    AFile.NewLine(registro_A001.Row);
    AFile.NewLine(registro_A990.Row);
end;

procedure TBloco_A.DoInc(const qtd_lin: Integer);
begin
    Inc(Self.registro_A990.qtd_lin_BA, qtd_lin) ;
end;

{ Tregistro_A001 }

constructor Tregistro_A001.Create(AOwner: TBloco_A);
begin
    inherited Create('A001');
    fOwner :=AOwner ;
    ind_mov:=movNoDat ;
end;

destructor Tregistro_A001.Destroy;
begin

    inherited;
end;

function Tregistro_A001.GetRow: string;
begin
    Result :=inherited GetRow ;
    fOwner.DoInc();
    fOwner.fBloco_9.UpdateReg(Self.reg);
end;

{ Tregistro_A990 }

constructor Tregistro_A990.Create(AOwner: TBloco_A);
begin
    inherited Create('A990');
    fOwner :=AOwner ;
end;

function Tregistro_A990.GetRow: string;
begin
    Inc(Self.qtd_lin_BA);
    Result :=        Tefd_util.SEP_FIELD +Self.reg ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.qtd_lin_BA) ;
    Result :=Result +Tefd_util.SEP_FIELD ;
    fOwner.fBloco_9.UpdateReg(Self.Reg);
end;

end.
