{*******************************************************}
{                                                       }
{       Carta de Correção eletronica (CC-e) 2G          }
{       Copyright (c) 1992,2012 Suporteware             }
{       Created by Carlos Gonzaga                       }
{                                                       }
{*******************************************************}
unit unfeeventxml;

{*
================================================================================
Descrição:
  Classe e tipos para tratar o xml da Carta de  Correção eletronica (CC-e) 2G

Historico   Descrição
=========== ====================================================================
15.05.2012  Versão inicial (Manual de Integração do Contribuinte 5.0 Mar/2012)
*}

interface

{$REGION 'Uses'}
uses
  Windows    ,
  Messages   ,
  SysUtils   ,
  Variants   ,
  Classes    ,
  NativeXml  ,
  unfexml    ,
  unfeutil   ,
  ucapicom   ;
{$ENDREGION}


type

  { Indicador do tipo de evento }
  TIndTypEventNFe = (tpEventCCe, tpEventCancel, tpEventManifestDest);
  TEventoNfe = class
  private
    fId: string ;
    fcOrgao: Byte ;
    procedure SetcOrgao(const AValue: Byte) ;
  public
    const COD_PROCESS_LOTE = 128  ;
    const COD_EVENT_VINC_NFE = 135 ;
    const COD_EVENT_NVINC_NFE = 136 ;
  public
    tpAmb: TnfeAmb ;
    CNPJ: string ;
    chNFe: string ;
    dhEvento: TDateTime;
    tpEvento: Integer ;
    nSeqEvento: Integer;
    verEvento: string;
    property cOrgao: Byte read fcOrgao write SetcOrgao ;
  end;

  TEventoCCe = class(TEventoNfe)
  private
    function GetId: string ;
  private
    fXML: string ;
    function GetXML: String ;
    procedure SetXML(const AValue: String) ;
    procedure DoLoad ;
  protected
    fxCorrecao: string ;
    function GetdescEvento: string ;
    procedure SetxCorrecao(const AValue: String) ;
    function GetxCondUso: string ;
  public
    const VERSAO  ='1.00' ;
    const TYP_EVENTO =110110 ;
    const DESCR_EVENTO='Carta de Correcao';
  public
    property Id: string read GetId;
    property descEvento: string read GetdescEvento ;
    property xCorrecao: string read fxCorrecao write SetxCorrecao ;
    property xCondUso: string read GetxCondUso;
    property XML: string read GetXML write SetXML ;
    constructor Create ;

    function Assinar(Cert: ICertificate2; out retMsg: String): Boolean; virtual ;
  end;

  TEventoCancel = class(TEventoNfe)
  public
    const VERSAO  ='1.00';
    const TYP_EVENTO =110110;
    const DESCR_EVENTO='Carta de Correcao';
  end;

  TEventoManifestDest = class(TEventoNfe)
  public
    const VERSAO  ='1.00' ;
  end;


implementation

uses StrUtils ,
  unfews ;


{ TEventoCCe }

function TEventoCCe.Assinar(Cert: ICertificate2; out retMsg: String): Boolean;
var outMsg: String;
begin
    if Cert<>nil then
    begin
        Result  :=Tnfeutil.Assinar(Self.XML	,
                                    Cert 		,
                                    outMsg  ,
                                    retMsg);

        if Result then
        begin
            FXML	:=outMsg;
        end;
    end
    else
    begin
        retMsg :='Certificado não informado!';
    end;
end;

constructor TEventoCCe.Create;
begin
    inherited ;
    cOrgao :=90 ;
    tpAmb :=ambHom  ;
    tpEvento :=100110 ;
    nSeqEvento:=1;
    verEvento :='1.00';
end;

procedure TEventoCCe.DoLoad;
var
    DocXML: TNativeXml;
    p:TXmlNode;
begin
    DocXML :=TNativeXml.CreateName('evento');
    try
        DocXML.XmlFormat      :=xfCompact;
//        DocXML.Encodingstring	:='utf-8';
        DocXML.FloatSignificantDigits :=2;
        DocXML.FloatAllowScientific:=False;

        DocXML.LoadFromFile(fXML);
        p :=DocXML.Root ;
        p :=p.FindNode('infEvento') ;
        if p<>nil then
        begin
            Self.cOrgao :=p.ReadInteger('cOrgao') ;
            Self.tpAmb  :=TnfeAmb(p.ReadInteger('tpAmb'));
            Self.CNPJ :=p.ReadString('CNPJ') ;
            Self.chNFe:=p.ReadString('chNFe');
            Self.dhEvento:=p.ReadDateTime('dhEvento');
            Self.tpEvento :=p.ReadInteger('tpEvento');
            Self.nSeqEvento :=p.ReadInteger('nSeqEvento');
            Self.verEvento:=p.ReadString('verEvento');
            p :=p.FindNode('detEvento');
            if p<>nil then
            begin
                //Self.descEvento :=p.ReadString('descEvento');
                Self.xCorrecao  :=p.ReadString('xCorrecao');
                //Self.xCondUso  :=p.ReadString('xCondUso');
            end;
        end;
    finally
        DocXML.Free ;
    end;
end;

function TEventoCCe.GetdescEvento: string;
begin
    Result :=Self.DESCR_EVENTO;
end;

function TEventoCCe.GetId: string;
begin
    Result :='ID' ;
    Result :=Result +IntToStr(tpEvento);
    Result :=Result +chNFe  ;
    Result :=Result +Tnfeutil.FInt(nSeqEvento,2);
end;

function TEventoCCe.GetxCondUso: string;
begin
    Result  :='A Carta de Correcao e disciplinada pelo paragrafo 1o-A do' +
              ' art. 7o do Convenio S/N, de 15 de dezembro de 1970 e' +
              ' pode ser utilizada para regularizacao de erro ocorrido na' +
              ' emissao de documento fiscal, desde que o erro nao esteja' +
              ' relacionado com: I - as variaveis que determinam o valor' +
              ' do imposto tais como: base de calculo, aliquota, diferenca' +
              ' de preco, quantidade, valor da operacao ou da prestacao;' +
              ' II - a correcao de dados cadastrais que implique mudanca' +
              ' do remetente ou do destinatario; III - a data de emissao ou' +
              ' de saida.';
end;

function TEventoCCe.GetXML: String;
var
    DocXML: TNativeXml;
begin
    Result :='';
    if PosEx('<Signature', FXML)>0 then
    begin
        Result	:=FXML ;
    end
    else begin
        DocXML :=TNativeXml.CreateName('evento');
        try
            DocXML.XmlFormat      :=xfCompact;
//            DocXML.Encodingstring	:='utf-8';
            DocXML.FloatSignificantDigits :=2;
            DocXML.FloatAllowScientific:=False;
            //DocXML.SplitSecondDigits :=0 ;
            DocXML.UseLocalBias :=True ;

            DocXML.Root.AttributeAdd('versao', VERSAO);
            DocXML.Root.AttributeAdd('xmlns' , URL_PORTALFISCAL_INF_BR_NFE);

            with DocXML.Root.NodeNew('infEvento') do
            begin
                AttributeAdd('Id', Self.Id);
                WriteInteger('cOrgao', Self.cOrgao);
                WriteInteger('tpAmb', Ord(Self.tpAmb)+1);
                WriteString('CNPJ', Self.CNPJ);
                WriteString('chNFe', Self.chNFe);
                WriteDateTime('dhEvento', Self.dhEvento);
                WriteInteger('tpEvento', Self.tpEvento);
                WriteInteger('nSeqEvento', Self.nSeqEvento);
                WriteString('verEvento', Self.verEvento);
                with NodeNew('detEvento') do
                begin
                    AttributeAdd('versao', VERSAO);
                    WriteString('descEvento', Self.descEvento);
                    WriteString('xCorrecao', Self.xCorrecao);
                    WriteString('xCondUso', Self.xCondUso);
                end;
            end;

            Result :=DocXML.Root.WriteToString  ;

        finally
            DocXML.Free ;
        end;
    end;
end;

procedure TEventoCCe.SetxCorrecao(const AValue: String);
begin
    if (Length(AValue) < 5)and(Length(AValue) > 1000) then
    begin
        raise Exception.Create('Correção a ser aplicada deve ter no min 15 e no max 1000 bytes!');
    end
    else
    begin
        fxCorrecao :=Tnfeutil.TrataString(AValue) ;
    end;
end;


procedure TEventoCCe.SetXML(const AValue: String);
begin
    if AValue<>'' then
    begin
        fXML :=AValue ;
        DoLoad ;
    end;
end;


{ TEventoNfe }

procedure TEventoNfe.SetcOrgao(const AValue: Byte);
begin
//    case AValue of
//      15,21,22,24: fcOrgao :=90; //SVAN: PA,MA,PI,RN
//    else
//      fcOrgao :=AValue ;
//    end;
    fcOrgao :=AValue ;
end;

end.
