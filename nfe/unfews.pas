{*******************************************************}
{                                                       }
{       Web Services Nota Fiscal Eletronica (NF-e) 2G   }
{       Copyright (c) 1992,2012 Suporteware             }
{       Created by Carlos Gonzaga                       }
{                                                       }
{*******************************************************}
{*
Descrição:  unidade responsavel para consumir
            serviços web da NF-e 2G

Historico   Descrição
=========== =============================================
01.04.2010	Versão inicial
30.10.2010	Capa de lote eletonica - CL-e
01.03.2011  leiaute e schemas da versão 4.0.1 do Manual de Integração do Contribuinte.
            O pacote de liberação PL_006f (NT2010.004).
15.05.2012  Eventos vincualado da NF-e (Carta de Correção eletronica CC-e)
18.12.2012  Implementação da versão 2.01 do Web Service que possibilita a consulta
            dos eventos deve ser disponbilizada pelas SEFAZ que oferecem a CC-e.
19.12.2012  Centraliza (otimiza) a chamada do WS no Method (Exec) da classe base (Tbasews)
19.12.2013  NT2013.007 - SEFAZ VIRTUAL DE CONTINGÊNCIA - SVC:
            Ambiente de Homologação: 01/12/2013;
            Ambiente de Produção: 03/01/2014;
*}

unit unfews;

interface

{$REGION 'Uses'}
uses
  Windows         ,
  Messages        ,
  SysUtils        ,
  Variants        ,
  Classes         ,
  Contnrs         ,
  //
  ComObj          ,
  InvokeRegistry  ,
  SOAPHTTPClient  ,
  SOAPHTTPTrans   ,
  WinINet         ,
  Types           ,
  XSBuiltIns      ,
  //
  ucapicom        ,
  umsxml          ,
  //
  NativeXml       ,
  //
  unfexml         ,
  unfeeventxml    ,
  unfeutil        ;

{$ENDREGION}

{$REGION 'JwaWinCrypt'}
type
  LPBYTE = {$IFDEF USE_DELPHI_TYPES} Windows.PBYTE {$ELSE} ^Byte {$ENDIF};
  {$EXTERNALSYM LPBYTE}

type
  _CRYPTOAPI_BLOB = record
    cbData: DWORD;
    pbData: LPBYTE;
  end;
  {$EXTERNALSYM _CRYPTOAPI_BLOB}
  CRYPT_INTEGER_BLOB = _CRYPTOAPI_BLOB;
  TCryptIntegerBlob = CRYPT_INTEGER_BLOB;
  {$EXTERNALSYM CRYPT_INTEGER_BLOB}
  PCRYPT_INTEGER_BLOB = ^_CRYPTOAPI_BLOB;
  {$EXTERNALSYM PCRYPT_INTEGER_BLOB}
  PCryptIntegerBlob = PCRYPT_INTEGER_BLOB;
  CRYPT_UINT_BLOB = _CRYPTOAPI_BLOB;
  {$EXTERNALSYM CRYPT_UINT_BLOB}
  TCryptUintBlob = CRYPT_UINT_BLOB;
  PCRYPT_UINT_BLOB = ^_CRYPTOAPI_BLOB;
  {$EXTERNALSYM PCRYPT_UINT_BLOB}
  PCryptUintBlob = PCRYPT_UINT_BLOB;
  CRYPT_OBJID_BLOB = _CRYPTOAPI_BLOB;
  {$EXTERNALSYM CRYPT_OBJID_BLOB}
  TCryptObjIdBlob = CRYPT_OBJID_BLOB;
  PCRYPT_OBJID_BLOB = ^_CRYPTOAPI_BLOB;
  {$EXTERNALSYM PCRYPT_OBJID_BLOB}
  PCryptObjIdBlob = PCRYPT_OBJID_BLOB;
  CERT_NAME_BLOB = _CRYPTOAPI_BLOB;
  {$EXTERNALSYM CERT_NAME_BLOB}
  TCertNameBlob = CERT_NAME_BLOB;
  PCERT_NAME_BLOB = ^_CRYPTOAPI_BLOB;
  {$EXTERNALSYM PCERT_NAME_BLOB}
  PCertNameBlob = PCERT_NAME_BLOB;
  CERT_RDN_VALUE_BLOB = _CRYPTOAPI_BLOB;
  {$EXTERNALSYM CERT_RDN_VALUE_BLOB}
  TCertRdnValueBlob = CERT_RDN_VALUE_BLOB;
  PCERT_RDN_VALUE_BLOB = ^_CRYPTOAPI_BLOB;
  {$EXTERNALSYM PCERT_RDN_VALUE_BLOB}
  PCertRdnValueBlob = PCERT_RDN_VALUE_BLOB;
  CERT_BLOB = _CRYPTOAPI_BLOB;
  {$EXTERNALSYM CERT_BLOB}
  TCertBlob = CERT_BLOB;
  PCERT_BLOB = ^_CRYPTOAPI_BLOB;
  {$EXTERNALSYM PCERT_BLOB}
  PCertBlob = PCERT_BLOB;
  CRL_BLOB = _CRYPTOAPI_BLOB;
  {$EXTERNALSYM CRL_BLOB}
  TCrlBlob = CRL_BLOB;
  PCRL_BLOB = ^_CRYPTOAPI_BLOB;
  {$EXTERNALSYM PCRL_BLOB}
  PCrlBlob = PCRL_BLOB;
  DATA_BLOB = _CRYPTOAPI_BLOB;
  {$EXTERNALSYM DATA_BLOB}
  TDataBlob = DATA_BLOB;
  PDATA_BLOB = ^_CRYPTOAPI_BLOB;
  {$EXTERNALSYM PDATA_BLOB}
  PDataBlob = PDATA_BLOB;
  CRYPT_DATA_BLOB = _CRYPTOAPI_BLOB;
  {$EXTERNALSYM CRYPT_DATA_BLOB}
  TCryptDataBlob = CRYPT_DATA_BLOB;
  PCRYPT_DATA_BLOB = ^_CRYPTOAPI_BLOB;
  {$EXTERNALSYM PCRYPT_DATA_BLOB}
  PCryptDataBlob = PCRYPT_DATA_BLOB;
  CRYPT_HASH_BLOB = _CRYPTOAPI_BLOB;
  {$EXTERNALSYM CRYPT_HASH_BLOB}
  TCryptHashBlob = CRYPT_HASH_BLOB;
  PCRYPT_HASH_BLOB = ^_CRYPTOAPI_BLOB;
  {$EXTERNALSYM PCRYPT_HASH_BLOB}
  PCryptHashBlob = PCRYPT_HASH_BLOB;
  CRYPT_DIGEST_BLOB = _CRYPTOAPI_BLOB;
  {$EXTERNALSYM CRYPT_DIGEST_BLOB}
  TCryptDigestBlob = CRYPT_DIGEST_BLOB;
  PCRYPT_DIGEST_BLOB = ^_CRYPTOAPI_BLOB;
  {$EXTERNALSYM PCRYPT_DIGEST_BLOB}
  PCryptDigestBlob = PCRYPT_DIGEST_BLOB;
  CRYPT_DER_BLOB = _CRYPTOAPI_BLOB;
  {$EXTERNALSYM CRYPT_DER_BLOB}
  TCyptDerBlob = CRYPT_DER_BLOB;
  PCRYPT_DER_BLOB = ^_CRYPTOAPI_BLOB;
  {$EXTERNALSYM PCRYPT_DER_BLOB}
  PCyptDerBlob = PCRYPT_DER_BLOB;
  CRYPT_ATTR_BLOB = _CRYPTOAPI_BLOB;
  {$EXTERNALSYM CRYPT_ATTR_BLOB}
  TCryptAttrBlob = CRYPT_ATTR_BLOB;
  PCRYPT_ATTR_BLOB = ^_CRYPTOAPI_BLOB;
  {$EXTERNALSYM PCRYPT_ATTR_BLOB}
  PCryptAttrBlob = PCRYPT_ATTR_BLOB;

type
  PCRYPT_ALGORITHM_IDENTIFIER = ^CRYPT_ALGORITHM_IDENTIFIER;
  {$EXTERNALSYM PCRYPT_ALGORITHM_IDENTIFIER}
  _CRYPT_ALGORITHM_IDENTIFIER = record
    pszObjId: LPSTR;
    Parameters: CRYPT_OBJID_BLOB;
  end;
  {$EXTERNALSYM _CRYPT_ALGORITHM_IDENTIFIER}
  CRYPT_ALGORITHM_IDENTIFIER = _CRYPT_ALGORITHM_IDENTIFIER;
  {$EXTERNALSYM CRYPT_ALGORITHM_IDENTIFIER}
  TCryptAlgorithmIdentifier = CRYPT_ALGORITHM_IDENTIFIER;
  PCryptAlgorithmIdentifier = PCRYPT_ALGORITHM_IDENTIFIER;


type
  PCRYPT_BIT_BLOB = ^CRYPT_BIT_BLOB;
  {$EXTERNALSYM PCRYPT_BIT_BLOB}
  _CRYPT_BIT_BLOB = record
    cbData: DWORD;
    pbData: LPBYTE;
    cUnusedBits: DWORD;
  end;
  {$EXTERNALSYM _CRYPT_BIT_BLOB}
  CRYPT_BIT_BLOB = _CRYPT_BIT_BLOB;
  {$EXTERNALSYM CRYPT_BIT_BLOB}
  TCryptBitBlob = CRYPT_BIT_BLOB;
  PCryptBitBlob = PCRYPT_BIT_BLOB;

type

  PCERT_PUBLIC_KEY_INFO = ^CERT_PUBLIC_KEY_INFO;
  {$EXTERNALSYM PCERT_PUBLIC_KEY_INFO}
  _CERT_PUBLIC_KEY_INFO = record
    Algorithm: CRYPT_ALGORITHM_IDENTIFIER;
    PublicKey: CRYPT_BIT_BLOB;
  end;
  {$EXTERNALSYM _CERT_PUBLIC_KEY_INFO}
  CERT_PUBLIC_KEY_INFO = _CERT_PUBLIC_KEY_INFO;
  {$EXTERNALSYM CERT_PUBLIC_KEY_INFO}
  TCertPublicKeyInfo = CERT_PUBLIC_KEY_INFO;
  PCertPublicKeyInfo = PCERT_PUBLIC_KEY_INFO;

type
  PCERT_EXTENSION = ^CERT_EXTENSION;
  {$EXTERNALSYM PCERT_EXTENSION}
  _CERT_EXTENSION = record
    pszObjId: LPSTR;
    fCritical: BOOL;
    Value: CRYPT_OBJID_BLOB;
  end;
  {$EXTERNALSYM _CERT_EXTENSION}
  CERT_EXTENSION = _CERT_EXTENSION;
  {$EXTERNALSYM CERT_EXTENSION}
  TCertExtension = CERT_EXTENSION;
  PCertExtension = PCERT_EXTENSION;

type
  PCERT_INFO = ^CERT_INFO;
  {$EXTERNALSYM PCERT_INFO}
  _CERT_INFO = record
    dwVersion: DWORD;
    SerialNumber: CRYPT_INTEGER_BLOB;
    SignatureAlgorithm: CRYPT_ALGORITHM_IDENTIFIER;
    Issuer: CERT_NAME_BLOB;
    NotBefore: FILETIME;
    NotAfter: FILETIME;
    Subject: CERT_NAME_BLOB;
    SubjectPublicKeyInfo: CERT_PUBLIC_KEY_INFO;
    IssuerUniqueId: CRYPT_BIT_BLOB;
    SubjectUniqueId: CRYPT_BIT_BLOB;
    cExtension: DWORD;
    rgExtension: PCERT_EXTENSION;
  end;
  {$EXTERNALSYM _CERT_INFO}
  CERT_INFO = _CERT_INFO;
  {$EXTERNALSYM CERT_INFO}
  TCertInfo = CERT_INFO;
  PCertInfo = PCERT_INFO;


//+-------------------------------------------------------------------------
//  Certificate context.
//
//  A certificate context contains both the encoded and decoded representation
//  of a certificate. A certificate context returned by a cert store function
//  must be freed by calling the CertFreeCertificateContext function. The
//  CertDuplicateCertificateContext function can be called to make a duplicate
//  copy (which also must be freed by calling CertFreeCertificateContext).
//--------------------------------------------------------------------------

type
  HCERTSTORE = Pointer;
  {$EXTERNALSYM HCERTSTORE}
  PHCERTSTORE = ^HCERTSTORE;
  {$NODEFINE PHCERTSTORE}


type
  PCERT_CONTEXT = ^CERT_CONTEXT;
  {$EXTERNALSYM CERT_CONTEXT}
  _CERT_CONTEXT = record
    dwCertEncodingType: DWORD;
    pbCertEncoded: LPBYTE;
    cbCertEncoded: DWORD;
    pCertInfo: PCERT_INFO;
    hCertStore: HCERTSTORE;
  end;
  {$EXTERNALSYM _CERT_CONTEXT}
  CERT_CONTEXT = _CERT_CONTEXT;
  {$EXTERNALSYM CERT_CONTEXT}
  TCertContext = CERT_CONTEXT;
  PCertContext = PCERT_CONTEXT;

  PCCERT_CONTEXT = PCERT_CONTEXT;
  {$EXTERNALSYM PCCERT_CONTEXT}
  PPCCERT_CONTEXT = ^PCCERT_CONTEXT;
  {$NODEFINE PCCERT_CONTEXT}

{$ENDREGION}

type

  TnfeInfProt = class
    Id: string ;
    tpAmp   :TnfeAmb;
    verAplic:string;
    chNFe   :string;
    dhRecbto:TDateTime;
    nProt   :string;
    digVal  :string;
    cStat   :Integer;
    xMotivo :string;
  end;

  { Tipo Evento }
  TEvento = class
  private
    type
      TDetEvento = record
        versao: string;
        descEvento: string;
        nProt: string; //Cancelamento
        xJust: string; //Cancelamento
      end;
      TInfEvento = record
        cOrgao: Byte ;
        tpAmb: TnfeAmb;
        CNPJ: string ;
        chNFe: string ;
        dhEvento: TDateTime;
        tpEvento: Integer;
        nSeqEvento: Integer;
        detEvento: TDetEvento;
      end;
  public
    versao: string;
    infEvento: TInfEvento;
    xml: string ;
  end;

  { Tipo retorno do Evento }
  TRetEvento = class
    tpAmb: TnfeAmb;
    verAplic: string;
    cOrgao: Byte ;
    cStat : Integer;
    xMotivo : string;
    chNFe: string ;
    tpEvento: Integer ;
    nSeqEvento: Integer;
    emailDest: string ;
    dhRegEvento: TDateTime;
    nProt: string;
    xml: string ;
  end;

  TnfeProcEventoList = class;
  TnfeProcEvento = class
  private
    owner: TnfeProcEventoList ;
  public
    versao: string;
    evento: TEvento ;
    retEvento: TRetEvento;
    constructor Create ;
    destructor Destroy; override ;
  end;

  TnfeProcEventoList = class(TObjectList)
  private
    function Get(Index: Integer): TnfeProcEvento;
  public
    property Items[Index: Integer]: TnfeProcEvento read Get;
    function AddNew: TnfeProcEvento ;
    function GetLast(): TnfeProcEvento ;
  end;


{$REGION 'TnfeCustomLayout'}
//  TnfeCustomLayout = class(TNativeXml)
  TnfeCustomLayout = class
  private
    fversao: string ;
    ftpAmb : TnfeAmb;
    fverAplic: string;
    fcStat : Integer;
    fxMotivo : string;
    fcUF : Integer;
    function getXML: UTF8String ;
    procedure DoSave(const ALocal, AFileName: string);
  protected
    docXML: TNativeXml ;
    procedure DoLoad(AReturn: UTF8String); virtual ;
    constructor NewConsStatServNFe(const ATpAmb: TnfeAmb);
    constructor NewConsReciNFe(const ATpAmb: TnfeAmb; const ANroRec, AVersao: string);
    constructor NewConsSitNFe(const ATpAmb: TnfeAmb; const AchNFe, AVersao: string);
    constructor NewEnvEventoNFe(ALote: Integer);
//    constructor NewReturn(AReturn: AnsiString);
  public
    property versao: string read fversao ;
    property tpAmb : TnfeAmb read ftpAmb ;
    property verAplic: string read fverAplic;
    property cStat : Integer read fcStat ;
    property xMotivo : string read fxMotivo;
    property cUF : Integer read fcUF;
    property XML: UTF8String read getXML;

  public
    function NodeNew(const AName: Utf8String): TXmlNode;
    function NodeByNameOrTree(const ANameOrTree: Utf8String): TXmlNode;
    function ReadDateTime(const AName: Utf8String; const ARootName: Utf8String = ''): TDateTime;
    procedure WriteInt(const AName: Utf8String; const AValue: Integer; const ARootName: Utf8String = '');
    procedure WriteStr(const AName, AValue: Utf8String; const ARootName: Utf8String = '');
    procedure ImportFromStr(const AValue: Utf8String);

    constructor Create(const ARetXML: UTF8String = ''; const AUseLocalBias: Boolean =False);
    constructor CreateName(const ARootName, AVersao: UTF8String);
    destructor Destroy; override ;
  end;
{$ENDREGION}

  TnfeRetConsSit = class(TnfeCustomLayout)
  private
    fchNFe: string ;
    fProtNFe: TnfeInfProt;
    fProcEventoNFeList: TnfeProcEventoList;
  protected
    procedure DoLoad(ARetConsSit: UTF8String); override;
  public
    property chNFe: string read fchNFe;
    property protNFe: TnfeInfProt read fProtNFe;
    property procEventoNFeList: TnfeProcEventoList read fProcEventoNFeList;
    constructor Create; reintroduce ;
    destructor Destroy; override ;
  end;

  { Tipo Retorno de Lote de Envio }
  TRetEnvEvento = class(TnfeCustomLayout)
  private
  protected
    fcOrgao: Byte;
    fRetEvento: TRetEvento;
    procedure DoLoad(ARetEvento: UTF8String); override;
  public
    property cOrgao: Byte read fcOrgao;
    property retEvento: TRetEvento read fRetEvento;
    constructor Create; reintroduce ;
    destructor Destroy; override ;
  end;


type
  { base para todos os serviços de consumo }
  TBaseNFeWS = class
  private
    procedure DoNFeStatusServico;
    procedure DoNFeRecepcao;
    procedure DoNFeRetRecepcao;
    procedure DoNFeConsulta;
    procedure DoNFeInutilizacao;
    procedure DoNFeRecepcaoEvento;
    //
    procedure OnBeforePost(const HTTPReqResp: THTTPReqResp; Data:Pointer);

    //(AC,AL,AP,AM,BA,CE,DF,ES,GO,MA,MT,MS,MG,PA,PB,PR,PE,PI,RJ,RN,RS,RO,RR,SC,SP,SE,TO);
    //AC,AL,AP,MA,PA,PB,PI,RJ,RN,RR,SC,SE,TO - Estados sem WebServices próprios
    //Unidades Federadas que utilizam as SEFAZ Virtuais para recepção de NF-e:
    {* SEFAZ Virtual AN (SVAN): CE, ES, MA, PA, PI e RN.*}
    {* SEFAZ Virtual RS (SVRS): AC, AL, AP, DF, MS, PB, RJ, RR, SC, SE, TO e RO; (atualizado em 25/09/2009) *}
  	function GetURLSVAN(): String;
    function GetURLSVRS(): String;
    function GetURLSCAN(): String;

    {* SEFAZ Virtual Contingência AN (SVC-AN): AC, AL, AP, MG, PB, RJ, RS, RO, RR, SC, SE, SP, TO e DF *}
    {* SEFAZ Virtual Contingência RS (SVC-RS): AM, BA, CE, ES, GO, MA, MT, MS, PA, PE, PI, PR e RN; (atualizado em 12/2013) *}
    function GetURL_SVCAN(): String;
    function GetURL_SVCRS(): String;

  private
    fTpAmb : TnfeAmb;
    fVerAplic: String;
    fCodStat : Integer;
    fxMotivo : String;
    fCodUF : Byte;
    fdhRecbto : TDateTime;
    fDadosMsg: string ;//AnsiString;

    fMsg: string ;

    fXMLSave: Boolean;
    fXMLPath: string ;

  protected
    fVersao: string;
    fCodVer: TnfeCodVer ;

    fWS_Result: String;
    fReqResp: THTTPReqResp;
    procedure SetCodVer(const Value: TnfeCodVer) ;
  public
    function GetURL(out Url: String): Boolean;
  public
    property DadosMsg: String read fDadosMsg write fDadosMsg ;
    property FormatMsg: String read fMsg;
    property tpAmb : TnfeAmb read fTpAmb;
    property verAplic: String read fVerAplic;
    property cStat : Integer read fCodStat ;
    property xMotivo : String read fxMotivo ;
    property cUF : Byte read fCodUF ;
    property dhRecbto : TDateTime read fdhRecbto ;

    property XMLSave: Boolean read fXMLSave write fXMLSave;
    property XMLPath: string read fXMLPath write fXMLPath ;

    property CodVer: TnfeCodVer read fCodVer write SetCodVer ;

    constructor Create;
    destructor Destroy; override ;
    function Execute: Boolean; virtual;

  end;

  { Pedido consuta status do serviço }
  TNFeStatusServico2 = class(TBaseNFeWS)
  private
    FTMed : Integer;
    FdhRetorno: TDateTime;
    FxObs :  String;
  protected
    dhCons: TDateTime ;
  public
    function Execute: Boolean; override;
    property TMed : Integer read FTMed;
    property dhRetorno : TDateTime read FdhRetorno;
    property xObs :  string read FxObs;
  end;

  TNFeRecepcao2 = class(TBaseNFeWS)
  private
    FLote: Integer;
    FIndSinc: Boolean; //Indicador de processamento síncrono. 0=NÃO; 1=SIM
  protected
    FRecibo : String;
    FTMed: Integer;
    fProtNFe: TnfeInfProt;
  public
    property Lote: Integer    read FLote write FLote;
    property IndSinc: Boolean read FIndSinc write FIndSinc;
    property Recibo: String   read FRecibo;
    property TMed: Integer   read FTMed;
    property ProtNFe: TnfeInfProt read fProtNFe ;

    constructor Create;
    destructor Destroy; override;
    function Execute: Boolean; override;
  end;

  TNFeRetRecepcao2 = class(TBaseNFeWS)
  private
    fRecibo: String;
    fRetConsReciNFe: TretConsReciNFe;
    fcMsg: Integer;
    fxMsg: string	;
  public
    constructor Create;
    destructor Destroy; override;
    function Execute: Boolean; override;
  public
    property Recibo: String read FRecibo write FRecibo;
    property RetConsReciNFe: TretConsReciNFe read fRetConsReciNFe write fRetConsReciNFe;
    property cMsg: Integer	read FcMsg;
    property xMsg: string	read FxMsg	;
  end;

  TNFeConsulta2 = class(TBaseNFeWS)
  private
    fchNFe: String;
    fRetConsSit: TnfeRetConsSit;
  public
    function Execute: Boolean; override;
    constructor Create;
    destructor Destroy; override;
  public
    property chNFe: String read fchNFe write fchNFe;
    property retConsSitNFe: TnfeRetConsSit read fRetConsSit;
  end;

  TNFeInutilizacao2 = class(TBaseNFeWS)
  private
    FModelo: Byte;
    FSerie: Word;
    FCNPJ: String;
    FAno: Integer;
    FNroIni: Integer;
    FNroFin: Integer;
    FJust: string;
    procedure SetJust(const AValue: string);
  protected
    FId: string;
    FdhReceb:TDateTime;
    FNProt: string;
    function GetId: string;
  public
    function Execute: Boolean; override;
  public
    property Modelo: Byte      read FModelo      write FModelo;
    property Serie: Word       read FSerie       write FSerie;
    property CNPJ: String         read FCNPJ        write FCNPJ;
    property Ano: Integer         read FAno         write FAno;
    property NroIni: Integer      read FNroIni      write FNroIni;
    property NroFin: Integer      read FNroFin      write FNroFin;
    property Justif: String     read FJust        write SetJust;
    property Id: String       read GetId;
    property dhReceb: TDateTime   read FdhReceb;
    property NroProt: String    read FNProt;
  end;

  TNFeRecepcaoEvento = class(TBaseNFeWS)
  private
    tpEvento: Integer ;
    fLote: Integer;
    fcOrgao: Byte ;
    fchNFe: String;
    fRetEnvEvento: TRetEnvEvento;
  public
    property Lote: Integer read fLote write fLote ;
    property cOrgao: Byte read fcOrgao write fcOrgao ;
    property chNFe: String read fchNFe write fchNFe;
    property retEnvEvento: TRetEnvEvento read fRetEnvEvento;
    constructor Create(ATpEvento: Integer);
    destructor Destroy; override;
  public
    function Execute: Boolean; override;
  end;


{$REGION 'TconfigNFe'}
type
  Temit = record
  public
    codigo: Integer ;
    rzSoci: string	;
    ufCodigo: Integer;
    ufSigla : string ;
    logo		: string ;
    typAmb  :TnfeAmb ;
    typEmi  :TnfeEmis;
  end;

  TjustCont = record
  public
    DataHora: TDateTime	;
    Justifica: string	;
  end;

  Tdanfe = record
  public
    saida: Byte;
    copias: Byte	;
    local: string	;
    printer: string ;
    msg_cf: Boolean	;
    sendmail: Boolean;
  end;

  Tcertificado = record
  public
    SerialNumber: string;
    SubjectName: string;
    ValidFromDate: TDateTime;
    ValidToDate: TDateTime;
    CheckValid: Boolean ;
    DiasExibir: Word;
    NumVezExib: Word;
  end;

  TconfigNFe = class
  public
    typAmb      :TnfeAmb  ;
    typEmi      :TnfeEmis ;
    incCadBai   :Boolean  ;
    lotePorCarga:Boolean  ;
    codemp     	:Integer  ;
    ufCodigo    :Integer  ;
    ufSigla     :string   ;
    emit				:Temit;
    justCont		:TjustCont;
    danfe				:Tdanfe	;
    localnfe: string ;
    localschema: string ;
    certificado: Tcertificado;
  protected
    fConfig:TNativeXml;
    fFileName:string;
    function GetFileName: string;
    procedure CreateCfg;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SelCertificado;
    function GetCertificado: ICertificate2;
    function Load: Boolean; virtual ;
    function Save: Boolean; virtual ;
    property FileName:string read GetFileName	;
  end;
{$ENDREGION}

{$REGION 'web.service'}

type

  { Schema XML de validação do cabeçalho da mensagem de Web Service da NF-e }
  TcabecMsg = class
  private
    Fversao       :string;
    FversaoDados  :string;
    FcabecXML     :TNativeXml;
  public
    property versao      : string read Fversao      write Fversao;
    property versaoDados : string read FversaoDados write FversaoDados;
    function MsgXML: WideString;
    constructor Create;
    destructor Destroy;override;
  end;

  { }

  { classe base para todas as mensagens de Web Service }
  Tbasews = class
  private
    FLayOut : TLayOut;
    FVersao : string;
    FTypAmb : TnfeAmb;
    FVerApp : string;
    FCodStt : Word;
    FMotivo : string;
    FUF     : Integer;
    FdhRecbto: TDateTime;
  private
    fPathXML: string ;
    fFileXML: string ;
    fSaveXML: Boolean;
    //(AC,AL,AP,AM,BA,CE,DF,ES,GO,MA,MT,MS,MG,PA,PB,PR,PE,PI,RJ,RN,RS,RO,RR,SC,SP,SE,TO);
    //AC,AL,AP,MA,PA,PB,PI,RJ,RN,RR,SC,SE,TO - Estados sem WebServices próprios
    //Unidades Federadas que utilizam as SEFAZ Virtuais para recepção de NF-e:
    {* SEFAZ Virtual AN (SVAN): CE, ES, MA, PA, PI e RN.*}
    {* SEFAZ Virtual RS (SVRS): AC, AL, AP, DF, MS, PB, RJ, RR, SC, SE, TO e RO; (atualizado em 25/09/2009) *}
  	function GetURLSVAN(const AAmb: TnfeAmb): WideString;
    function GetURLSVRS(const AAmb: TnfeAmb): WideString;
    function GetURLSCAN(const AAmb: TnfeAmb): WideString;
    function GetURLAM(const AAmb: TnfeAmb): WideString;
    function GetURLBA(const AAmb: TnfeAmb): WideString;
    function GetURLCE(const AAmb: TnfeAmb): WideString;
    function GetURLDF(const AAmb: TnfeAmb): WideString;
    function GetURLES(const AAmb: TnfeAmb): WideString;
    function GetURLGO(const AAmb: TnfeAmb): WideString;
    function GetURLMT(const AAmb: TnfeAmb): WideString;
    function GetURLMS(const AAmb: TnfeAmb): WideString;
    function GetURLMG(const AAmb: TnfeAmb): WideString;
    function GetURLPR(const AAmb: TnfeAmb): WideString;
    function GetURLPE(const AAmb: TnfeAmb): WideString;
    function GetURLRS(const AAmb: TnfeAmb): WideString;
    function GetURLRO(const AAmb: TnfeAmb): WideString;
    function GetURLSP(const AAmb: TnfeAmb): WideString;
    //
    procedure DoNFeStatusServico;
    procedure DoNFeRecepcao;
    procedure DoNFeRetRecepcao;
    procedure DoNFeConsulta;
    procedure DoNFeCancelamento;
    procedure DoNFeInutilizacao;
    //
    procedure ConfigReqResp(ReqResp: THTTPReqResp);
    procedure OnBeforePost(const HTTPReqResp: THTTPReqResp; Data:Pointer);
    //
  private
    // 30.10.2010 - Capa de Lote Eletronica (CL-e)
    function GetURLCLe(const AAmb: TnfeAmb): WideString;
    procedure DoCleCadastro	;

  private
    // 15.05.2012 Eventos vincualado a NF-e
    procedure DoRecepEvento;

  protected
    FCabMsg: WideString;
    FDadosMsg: String;
    FRetWS: String;
    FUrl    : string;
    FConfig : TconfigNFe;
    FReqResp: THTTPReqResp;
    FWS_Local: string ;
    FWS_Result: string;
    FRetXML: TNativeXml;
    procedure LoadMsgEntrada;
    procedure LoadURL;
  public
    retMsg  :String;
    msg     :String;
    dados: string ;
    property CabMsg: WideString read FCabMsg write FCabMsg ;
    property DadosMsg: String read FDadosMsg write FDadosMsg ;
    property RetWS: String read FRetWS;
    property RetXML: TNativeXml read FRetXML;

    constructor Create(AConfig: TconfigNFe); virtual;
    destructor Destroy; override ;
    function Execute: Boolean; virtual;
    function Exec(): Boolean; virtual;
    function SetMsgDlg(const AMsg: string): string;
//    procedure DoExec(); virtual;

  public
    property Versao: string       read FVersao;
    property TypAmb: TnfeAmb      read FTypAmb write FTypAmb;
    property VerApp: string       read FVerApp;
    property CodStt: Word         read FCodStt;
    property Motivo: string       read FMotivo;
    property UF: Integer          read fUF write fUF;
    property dhRecbto: TDateTime	read FdhRecbto;
    property PathXML: string 			read FPathXML write FPathXML;
    property SaveXML: Boolean			read FSaveXML write FSaveXML;
  end;

  TnfeStatusServico = class(Tbasews)
  private
    FTMed : Integer;
    FdhRetorno : TDateTime;
    FObs :  String;
  public
    function Execute: Boolean; override;
    function Exec(): Boolean; override;
    property TMed : Integer read FTMed;
    property dhRetorno : TDateTime read FdhRetorno;
    property Obs :  String read FObs;
  end;

  TnfeRecepcao = class(Tbasews)
  private
    FLote: Integer;
  protected
    FRecibo : String;
    FTMed: Integer;
  public
    function Execute: Boolean; override;
    function Exec(): Boolean; override;
    property Lote: Integer    read FLote write FLote;
    property Recibo: String   read FRecibo;
    property TMed: Integer   read FTMed;
  end;

  TnfeRetRecepcao = class(Tbasews)
  private
    fRecibo: String;
    fRetConsReciNFe: TretConsReciNFe;
    fcMsg: Integer;
    fxMsg: string	;
  public
    function Execute(): Boolean; override;
    function Exec(): Boolean; override;
    constructor Create(AConfig: TconfigNFe); override;
    destructor Destroy; override;
  public
    property Recibo: String read FRecibo write FRecibo;
    property RetConsReciNFe: TretConsReciNFe read fRetConsReciNFe write fRetConsReciNFe;
    property cMsg: Integer	read FcMsg	;
    property xMsg: string	read FxMsg	;
  end;

  TnfeConsulta = class(Tbasews)
  private
    FNFeKey: String;
    FNProt: String;
    FinfProt :TinfProt;
    FRetConsSitNFe: TRetConsSitNFe;
  public
    function Execute: Boolean; override;
    function Exec(): Boolean; override;
    constructor Create(AConfig: TconfigNFe); override;
    destructor Destroy; override;
  public
    property NFeKey: String read FNFeKey write FNFeKey;
    property NProt: String read FNProt ;
    property infProt: TinfProt  read FinfProt write FinfProt;
    property retConsSitNFe: TRetConsSitNFe  read FRetConsSitNFe ;
  end;

  TnfeCancelamento = class(Tbasews)
  private
    FNFeKey: AnsiString;
    FNProt: AnsiString;
    FJust: AnsiString;
    procedure SetJust(AValue: AnsiString);
  public
    function Execute: Boolean; override;
  public
    property NFeKey : AnsiString  read FNFeKey  write FNFeKey;
    property NProt  : AnsiString  read FNProt   write FNProt;
    property Just   : AnsiString  read FJust    write SetJust;
  end;

  TnfeInutilizacao = class(Tbasews)
  private
    FModelo: Integer;
    FSerie: Integer;
    FCNPJ: String;
    FAno: Integer;
    FNroIni: Integer;
    FNroFin: Integer;
    FJust: AnsiString;
    procedure SetAno(AValue: Integer);
    procedure SetJust(AValue: AnsiString);
  protected
    FId:WideString;
    FdhReceb:TDateTime;
    FNProt: AnsiString;
    function GetId: AnsiString;
  public
    function Execute: Boolean;  override;
  public
    property Modelo: Integer      read FModelo      write FModelo;
    property Serie: Integer       read FSerie       write FSerie;
    property CNPJ: String         read FCNPJ        write FCNPJ;
    property Ano: Integer         read FAno         write SetAno;
    property NroIni: Integer      read FNroIni      write FNroIni;
    property NroFin: Integer      read FNroFin      write FNroFin;
    property Just: AnsiString     read FJust        write SetJust;
    property Id: AnsiString       read GetId;
    property dhReceb: TDateTime   read FdhReceb;
    property NProt: AnsiString    read FNProt;
  end;

  // 15.05.2012  Eventos vinculado a NF-e 2G
  TRecepcaoEvento = class(Tbasews)
  private
    FCodOrg: Word ;
    FLote: Integer;
    FDtHReg: TDateTime ;
    FNrProt: string;
    FXML: string ;
  protected
    fIndTypEvent: TIndTypEventNFe;
  public
    constructor Create(AConfig: TconfigNFe; AIndTypEvent: TIndTypEventNFe); reintroduce ;
    function Execute: Boolean; override;
    property Lote: Integer      read FLote write FLote;
    property CodOrg: Word read FCodOrg write FCodOrg;
    property DtHReg: TDateTime read FDtHReg ;
    property NrProt: string read FNrProt ;
    property XML: string read FXML ;
  end;


{$ENDREGION}

const
  INTERNET_OPTION_CLIENT_CERT_CONTEXT = 84;

const
  IS_OPTN = $0001;


{$REGION 'const.NFE'}
const
//  NFE_VER_APP             = 'SW NF-e v3.0';
  NFE_VER_CAB_MSG         = '1.00';
  NFE_VER_CONS_STT_SERV   = '2.00';
  NFE_VER_ENVI_NFE        = '2.00';
  NFE_VER_NFE             = '2.00';
  NFE_VER_CONS_RECI_NFE   = '2.00';
//  NFE_VER_CONS_SIT_NFE    = '2.00';
  NFE_VER_CONS_SIT_NFE    = '2.01';
  NFE_VER_CANC_NFE        = '2.00';
  NFE_VER_INUT_NFE        = '2.00';
  NFE_VER_NFE_PROC        = '2.00';
  NFE_VER_PROC_CANC_NFE		= '2.00';

  NFCE_VER_NFCE     = '3.00';
  NFCE_WEB_SERVICE = 'NfeAutorizacao';
  NFCE_WS_METHOD = 'NfeAutorizacaoLote';


const //evento NF-e
  NFE_VER_EVT_CCE = '1.00';
  NFE_VER_EVT_CAN = '1.00';

const // 30.10.2010
  CLE_VER_CAB_MSG         = '1.00';
  CLE_VER_CLE 						= '1.00';

const
  URL_PORTALFISCAL_INF_BR_NFE = 'http://www.portalfiscal.inf.br/nfe';
  NFE_PORTALFISCAL_INF_BR = 'http://www.portalfiscal.inf.br/nfe';
  //NFE_NAMESPACE           = 'http://www.portalfiscal.inf.br/nfe';
  ENCODING_UTF8 = '?xml version="1.0" encoding="UTF-8"?';
  ENCODING_UTF8_STD = '?xml version="1.0" encoding="UTF-8" standalone="no"?';

{$ENDREGION}


implementation

uses
  SOAPConst, DateUtils, StrUtils, Dialogs;


{ TconfigNFe }

constructor TconfigNFe.Create;
begin
    inherited Create;
    fConfig :=TNativeXml.CreateName('AppConfig');
    fConfig.XmlFormat  :=xfReadable;
    //fConfig.Utf8Encoded :=True;
    if FileExists(FileName) then
    begin
        Load;
    end
    else begin
        CreateCfg;
    end;
end;

procedure TconfigNFe.CreateCfg;
var p: TXmlNode;
begin
    p :=fConfig.Root;
    //p.AttributeAdd('xmlns:xsi','http://www.w3.org/2001/XMLSchema-instance');
    p.WriteInteger('typAmb', Ord(TypAmb));
    p.WriteInteger('typEmi', Ord(TypEmi));
    p.WriteInteger('incCadBai', Ord(IncCadBai));
    p.WriteInteger('lotePorCarga', Ord(lotePorCarga));
    p.WriteString('localnfe', Self.localnfe);
    p.WriteString('localschema', Self.localschema);

    p :=fConfig.Root.NodeNew('emit');
  	p.WriteInteger('codigo' , emit.codigo);
    p.WriteString('rzSoci'   , emit.rzSoci);
    p.WriteInteger('ufCodigo' ,emit.ufCodigo);
    p.WriteString('ufSigla'   ,emit.ufSigla);
    p.WriteString('logo'   ,emit.logo);

    p :=fConfig.Root.NodeNew('cert');
//    p.WriteString('serialNumber', CertSerial);
//    p.WriteString('subjectName', CertName);
    p.WriteString('serialNumber', certificado.SerialNumber);
    p.WriteString('subjectName', certificado.SubjectName);
    p.WriteDateTime('ValidFromDate', certificado.ValidFromDate);
    p.WriteDateTime('ValidToDate', certificado.ValidToDate);
    p.WriteBool('CheckValid', certificado.CheckValid);
    p.WriteInteger('DiasExibir', certificado.DiasExibir);
    p.WriteInteger('NumVezExib', certificado.NumVezExib);

    p :=fConfig.Root.NodeNew('danfe');
    p.WriteInteger('saida' 	, danfe.saida);
    p.WriteInteger('copias' , danfe.copias);
    p.WriteString	('printer',	danfe.printer);
    p.WriteString	('local'  ,	danfe.local);
    p.WriteBool		('msg_cf', danfe.msg_cf);
    p.WriteBool		('sendmail', danfe.sendmail);

    fConfig.SaveToFile(FileName);
end;

destructor TconfigNFe.Destroy;
begin
    fConfig.Destroy;
    inherited Destroy;
end;

function TconfigNFe.GetCertificado: ICertificate2;
var
    Store        : IStore3;
    Certs        : ICertificates2;
    Cert         : ICertificate2;
    i            : Integer;
begin
    Result  :=nil;
    Store   :=CoStore.Create;
    Store.Open(CAPICOM_CURRENT_USER_STORE, 'My', CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED);

    Certs :=Store.Certificates as ICertificates2;
    for i:= 1 to Certs.Count do
    begin

      OleCheck(IDispatch(Certs.Item[i]).QueryInterface(ICertificate2, Cert));
      if Cert.SerialNumber = certificado.SerialNumber then
      begin
          Result := Cert;
          Break;
      end;
    end;

    if not(Assigned(Result)) then
      raise Exception.Create('Certificado Digital não encontrado!');
end;

function TconfigNFe.GetFileName: string;
begin
    Result  :=ExtractFilePath(ParamStr(0));
    Result  :=Result + '\config\nfe'	;
    if not DirectoryExists(Result) then
    begin
        ForceDirectories(Result) ;
    end;
    Result  :=Format('%s\sistema_nfe.xml',[Result]);
end;

function TconfigNFe.Load: Boolean;
var p: TXmlNode ;
//var r: Tregmov00;
begin
    Result  :=FileExists(FileName) ;
    if Result then
    begin
        fConfig.LoadFromFile(FileName);

    //        r :=Tregmov00.Create;
    //        if r.cuse_nfe_trans_tipo_ambiente then
    //        begin
    //            TypAmb     :=ambPro;
    //        end
    //        else begin
    //            TypAmb     :=ambHom;
    //        end;
    //        r.Destroy;

        p						:=fConfig.Root;
        TypAmb     	:=TnfeAmb(p.ReadInteger('typAmb' ));
        typEmi      :=TnfeEmis(p.ReadInteger('typEmi'));
        incCadBai   :=p.ReadBool		('incCadBai'   	);
        lotePorCarga:=p.ReadBool		('lotePorCarga'	);

        localnfe    :=p.ReadString('localnfe');
        localschema :=p.ReadString('localschema');

        p	:=fConfig.Root.NodeByName('emit')	;
        if p<>nil then
        begin
            emit.codigo		:=p.ReadInteger('codigo')	;
            emit.rzSoci		:=p.ReadString('rzSoci');
            emit.ufCodigo	:=p.ReadInteger('ufCodigo')	;
            emit.ufSigla	:=p.ReadString('ufSigla');
            emit.logo			:=p.ReadString('logo');
        end ;

        p	:=fConfig.Root.NodeByName('cert')	;
        if p<>nil then
        begin
            certificado.SerialNumber:=p.ReadString('serialNumber');
            certificado.SubjectName	:=p.ReadString('subjectName');
            certificado.ValidFromDate	:=p.ReadDateTime('ValidFromDate');
            certificado.ValidToDate	:=p.ReadDateTime('ValidToDate');
            certificado.CheckValid	:=p.ReadBool('CheckValid');
            certificado.DiasExibir	:=p.ReadInteger('DiasExibir');
            certificado.NumVezExib	:=p.ReadInteger('NumVezExib');
        end;

        p	:=fConfig.Root.NodeByName('justCont')	;
        if p<>nil then
        begin
            justCont.DataHora	:=p.ReadDateTime('datahora')	;
            justCont.Justifica:=p.ReadString('justifica');
        end ;

        p	:=fConfig.Root.NodeByName('danfe')	;
        if p<>nil then
        begin
            danfe.saida	:=p.ReadInteger('saida');
            danfe.copias:=p.ReadInteger('copias');
            danfe.printer :=p.ReadString ('printer');
            danfe.local :=p.ReadString ('local');
            danfe.msg_cf:=p.ReadBool	 ('msg_cf');
            danfe.sendmail:=p.ReadBool ('sendmail');
        end ;

    end;
end;

function TconfigNFe.Save: Boolean;
var p: TXmlNode;
begin
  p :=fConfig.Root;
  try
    	p.WriteInteger('typAmb'				, Ord(typAmb)		);
      p.WriteInteger('typEmi'				, Ord(typEmi)		);
      p.WriteBool		('incCadBai'		, incCadBai  		);
      p.WriteBool		('lotePorCarga'	,	lotePorCarga	);
      p.WriteString('localnfe', Self.localnfe);
      p.WriteString('localschema', Self.localschema);

      p :=fConfig.Root.NodeByName('emit') ;
      if p=nil then
      begin
        p :=fConfig.Root.NodeNew('emit') ;
      end;
      p.WriteInteger('codigo'				,	emit.codigo   );
      p.WriteString	('rzSoci'				,	emit.rzSoci 	);
      p.WriteInteger('ufCodigo'			,	emit.ufCodigo );
      p.WriteString	('ufSigla'			,	emit.ufSigla	);
      p.WriteString	('logo'					,	emit.logo			);

      p :=fConfig.Root.NodeByName('cert') ;
      if p=nil then
      begin
        p :=fConfig.Root.NodeNew('cert') ;
      end;
      p.WriteString('serialNumber', certificado.SerialNumber);
      p.WriteString('subjectName', certificado.SubjectName);
      p.WriteDateTime('ValidFromDate', certificado.ValidFromDate);
      p.WriteDateTime('ValidToDate', certificado.ValidToDate);
      p.WriteBool('CheckValid', certificado.CheckValid);
      p.WriteInteger('DiasExibir', certificado.DiasExibir);
      p.WriteInteger('NumVezExib', certificado.NumVezExib);

      p	:=fConfig.Root.NodeByName('justCont')	;
      if p=nil then
      begin
        p :=fConfig.Root.NodeNew('justCont') ;
      end;
      p.WriteDateTime	('datahora'		,	justCont.DataHora	);
      p.WriteString		('justifica'	,	justCont.Justifica);

      p :=fConfig.Root.NodeByName('danfe') ;
      if p=nil then
      begin
        p :=fConfig.Root.NodeNew('danfe') ;
      end;
      p.WriteInteger	('saida'	,danfe.saida);
      p.WriteInteger	('copias'	,danfe.copias);
      p.WriteString		('printer'	,danfe.printer);
      p.WriteString		('local'	,danfe.local);
      p.WriteBool			('msg_cf'	,danfe.msg_cf);
      p.WriteBool			('sendmail'	,danfe.sendmail);

      fConfig.SaveToFile(FileName);
      Result :=True ;
  except
      Result  :=False;
  end;
end;

procedure TconfigNFe.SelCertificado;
var
  Store        : IStore3;
  Certs        : ICertificates2;
  Certs2       : ICertificates2;
  Cert         : ICertificate2;
begin
    Store := CoStore.Create;
    Store.Open(CAPICOM_CURRENT_USER_STORE, 'My', CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED);

    Certs   :=Store.Certificates as ICertificates2;
    Certs2  :=Certs.Select('Certificado(s) Digital(is) disponível(is)', 'Selecione o certificado digital para uso no aplicativo NF-e', false);
    if not(Certs2.Count = 0) then
    begin
        Cert :=IInterface(Certs2.Item[1]) as ICertificate2;
//        CertSerial :=Cert.SerialNumber;
//        CertName   :=Cert.SubjectName;
				certificado.SerialNumber:=Cert.SerialNumber;
        certificado.SubjectName	:=Cert.SubjectName;
    end;
end;

{ TcabecMsg }

function TcabecMsg.MsgXML: WideString;
//var p:TXmlNode;
begin
  if Fversao <> '' then
  begin
      {p :=FcabecXML.Root;

      p.AttributeByName['versao']  :=Fversao;
      if FversaoDados <> '' then
      begin
        p.NodeByName('versaoDados').ValueAsString :=FversaoDados;
        Result := FcabecXML.WriteToString;
      end
      else
        raise Exception.Create('Versão do leiaute dos dados não informada!');
     }
  end
  else begin
      raise Exception.Create('Versão do leiaute do cabeçalho não informada!');
  end;
end;

constructor TcabecMsg.Create;
begin
  inherited Create;
  FcabecXML :=TNativeXml.CreateName('cabecMsg');
//  FcabecXML.Utf8Encoded     := True;
//  FcabecXML.EncodingString  := 'utf-8';
  FcabecXML.Root.AttributeAdd('xmlns', NFE_PORTALFISCAL_INF_BR);
  FcabecXML.Root.AttributeAdd('versao', Fversao);
  FcabecXML.Root.WriteString('versaoDados', FversaoDados);
end;

destructor TcabecMsg.Destroy;
begin
  FcabecXML.Destroy;
  inherited Destroy;
end;

{ Tbasews }

procedure Tbasews.ConfigReqResp(ReqResp: THTTPReqResp);
begin
  	ReqResp.OnBeforePost :=OnBeforePost;
end;

constructor Tbasews.Create(AConfig: TconfigNFe);
begin
    FConfig  :=AConfig;
    FPathXML :=ExtractFilePath(ParamStr(0))	;

    FReqResp := THTTPReqResp.Create(nil);
    FReqResp.OnBeforePost :=OnBeforePost;
    FReqResp.UseUTF8InHeader :=True;
end;

destructor Tbasews.Destroy;
begin
  FReqResp.Destroy;
  inherited Destroy;
end;

procedure Tbasews.DoCleCadastro;
var cabecMsg: TNativeXml;
begin
    //
    FLayOut :=LayCleCadastro;
    // cab
    cabecMsg:=TNativeXml.CreateName('cabecMsg');
    try
//        cabecMsg.Utf8Encoded     := True;
//        cabecMsg.EncodingString  := 'utf-8';
        cabecMsg.Root.AttributeAdd('xmlns', NFE_PORTALFISCAL_INF_BR);
        cabecMsg.Root.WriteString('versaoDados', CLE_VER_CLE);
        cabMsg	:=cabecMsg.WriteToString	;
    finally
      cabecMsg.Destroy;
    end;

    // dados
    dadosMsg  :=UTF8Encode(dadosMsg);

end;

procedure Tbasews.DoNFeCancelamento;
var xmlDoc:TNativeXml;
var p:TXmlNode;
var key:string;
begin
    FLayOut   :=LayNfeCancelamento;

    // dados
    xmlDoc :=TNativeXml.CreateName('cancNFe');
    try
        key :=TnfeCancelamento(Self).NFeKey;
//        xmlDoc.Utf8Encoded    :=True;
//        xmlDoc.Encodingstring :='UTF-8';
        p :=xmlDoc.Root;
        p.AttributeAdd('xmlns'  ,   URL_PORTALFISCAL_INF_BR_NFE );
        p.AttributeAdd('versao' ,   NFE_VER_CANC_NFE            );
        p :=p.NodeNew('infCanc'                                 );
        p.AttributeAdd('Id'     ,   Format('ID%s', [key])       );
        p.WriteInteger('tpAmb'  ,   Ord(FConfig.TypAmb)+1       );
        p.WriteString('xServ'   ,   'CANCELAR'                  );
        p.WriteString('chNFe'   ,   key                         );
        p.WriteString('nProt'   ,   TnfeCancelamento(Self).NProt);
        p.WriteString('xJust'   ,   TnfeCancelamento(Self).Just );
        //
        p          :=xmlDoc.Root;
        FDadosMsg  :=p.WriteToString;
        FDadosMsg  :=StringReplace(FDadosMsg, #10, '', [rfReplaceAll] ) ;
        FDadosMsg  :=StringReplace(FDadosMsg, #13, '', [rfReplaceAll] ) ;
    finally
        xmlDoc.Destroy;
    end;

    if not Tnfeutil.Assinar(FDadosMsg, FConfig.GetCertificado, retMsg, msg) then
    begin
        raise Exception.Create('Falha ao assinar cancelamento de NF-e!'+ LineBreak + msg);
    end;

//    if not Tnfeutil.Valida(retMsg, LayNfeCancelamento, msg) then
//    begin
//      	raise Exception.Create('Falha na validação dos dados do cancelamento!'+ LineBreak + msg);
//    end;

    FDadosMsg := StringReplace(retMsg, '<'+ENCODING_UTF8_STD+'>', '', [rfReplaceAll]);
    FDadosMsg := StringReplace(FDadosMsg, '<'+ENCODING_UTF8+'>', '', [rfReplaceAll] );
    FDadosMsg := StringReplace(FDadosMsg, '<?xml version="1.0"?>', '', [rfReplaceAll]);

end;

procedure Tbasews.DoNFeConsulta;
var xmlDoc:TNativeXml;
var p:TXmlNode;
begin
    //
    FLayOut :=LayNfeConsulta;
    FVersao :=NFE_VER_CONS_SIT_NFE;
    FTypAmb :=FConfig.typAmb ;
    //'http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta2'
    FWS_Local :=Format('%s/wsdl/NfeConsulta2',[NFE_PORTALFISCAL_INF_BR]);
    FWS_Result:='nfeConsultaNF2Result';

    // dados
    xmlDoc :=TNativeXml.CreateName('consSitNFe');
    try
        xmlDoc.XmlFormat :=xfCompact ;
        p:=xmlDoc.Root;
        p.AttributeAdd('xmlns' ,  URL_PORTALFISCAL_INF_BR_NFE);
        p.AttributeAdd('versao',  NFE_VER_CONS_SIT_NFE      );
        p.WriteInteger('tpAmb' ,  Ord(FTypAmb)+1            );
        p.WriteString('xServ'  , 'CONSULTAR'                );
        p.WriteString('chNFe'  ,  TnfeConsulta(Self).NFeKey );
        FDadosMsg  :=p.WriteToString;
    finally
        xmlDoc.Destroy;
    end;
end;

procedure Tbasews.DoNFeInutilizacao;
var xmlDoc:TNativeXml;
var p:TXmlNode;
begin
    FLayOut :=LayNfeInutilizacao;

    // dados
    xmlDoc :=TNativeXml.CreateName('inutNFe');
    try
//        xmlDoc.Utf8Encoded    :=True;
//        xmlDoc.Encodingstring :='utf-8';
        p :=xmlDoc.Root;
        p.AttributeAdd('xmlns'  ,   URL_PORTALFISCAL_INF_BR_NFE       );
        p.AttributeAdd('versao' ,   NFE_VER_INUT_NFE                  );
        p :=p.NodeNew('infInut');
        p.AttributeAdd('Id'     ,   TnfeInutilizacao(Self).Id      		);
        p.WriteInteger('tpAmb'  ,   Ord(FConfig.TypAmb)+1             );
        p.WriteString('xServ'   ,   'INUTILIZAR'                      );
        p.WriteInteger('cUF'    ,   FConfig.emit.ufCodigo             );
        p.WriteInteger('ano'    ,   TnfeInutilizacao(Self).Ano        );
        p.WriteString('CNPJ'    ,   TnfeInutilizacao(Self).CNPJ       );
        p.WriteInteger('mod'    ,   TnfeInutilizacao(Self).Modelo     );
        p.WriteInteger('serie'  ,   TnfeInutilizacao(Self).Serie      );
        p.WriteInteger('nNFIni' ,   TnfeInutilizacao(Self).NroIni     );
        p.WriteInteger('nNFFin' ,   TnfeInutilizacao(Self).NroFin     );
        p.WriteString('xJust'   ,   TnfeInutilizacao(Self).Just       );
        //
        p          :=xmlDoc.Root;
        FDadosMsg  :=p.WriteToString;
        FDadosMsg  :=StringReplace(FDadosMsg, #10, '', [rfReplaceAll] ) ;
        FDadosMsg  :=StringReplace(FDadosMsg, #13, '', [rfReplaceAll] ) ;
    finally
        xmlDoc.Destroy;
    end;


    if not Tnfeutil.Assinar(FDadosMsg, FConfig.GetCertificado, retMsg, msg) then
    begin
        raise Exception.Create('Falha ao inutilizar faixa de numeração de NF-e!'+ LineBreak + msg);
    end;

//    if not Tnfeutil.Valida(retMsg, LayNfeInutilizacao, msg) then
//    begin
//      	raise Exception.Create('Falha na validação dos dados da inutilização!'+ LineBreak + msg);
//    end;

    FDadosMsg := StringReplace(retMsg, '<'+ENCODING_UTF8_STD+'>', '', [rfReplaceAll] ) ;
    FDadosMsg := StringReplace(FDadosMsg, '<'+ENCODING_UTF8+'>', '', [rfReplaceAll] ) ;
    FDadosMsg := StringReplace(FDadosMsg, '<?xml version="1.0"?>', '', [rfReplaceAll] ) ;

end;

procedure Tbasews.DoNFeRecepcao;
var S:TnfeString;
begin
    FLayOut :=LayNfeRecepcao;
    FVersao :=NFE_VER_ENVI_NFE;
    FTypAmb :=FConfig.typAmb ;
    FWS_Local :=Format('%s/wsdl/NfeRecepcao2', [NFE_PORTALFISCAL_INF_BR]);
    FWS_Result:='nfeRecepcaoLote2Result';


   fFileXML :=Format('%d-env-lot.xml', [TnfeRecepcao(Self).Lote]);

    S :=TnfeString.Create('');
    try
      S.WriteStr('<enviNFe xmlns="%s" versao="%s">' , [URL_PORTALFISCAL_INF_BR_NFE, NFE_VER_ENVI_NFE]);
      S.WriteStr( '<idLote>%d</idLote>'             , [TnfeRecepcao(Self).Lote] );
      S.WriteStr(   fDadosMsg                                                   );
      S.WriteStr( '</enviNFe>'                                                  );
      fDadosMsg :=S.DataString;

      if SaveXML then
      begin
        S.SaveToFile(PathXML + fFileXML);
      end;
    finally
      S.Free ;
    end;

end;

procedure Tbasews.DoNFeRetRecepcao;
var xmlDoc:TNativeXml;
var p:TXmlNode;
begin
    FLayOut :=LayNfeRetRecepcao;
    FVersao :=NFE_VER_CONS_RECI_NFE;
    FTypAmb :=FConfig.typAmb ;
    FWS_Local :=Format('%s/wsdl/NfeRetRecepcao2', [NFE_PORTALFISCAL_INF_BR]);
    FWS_Result:='nfeRetRecepcao2Result';

    // dados
    xmlDoc :=TNativeXml.CreateName('consReciNFe');
    try
        xmlDoc.XmlFormat :=xfCompact;
        p :=xmlDoc.Root;
        p.AttributeAdd('xmlns'  ,   URL_PORTALFISCAL_INF_BR_NFE   );
        p.AttributeAdd('versao' ,   NFE_VER_CONS_RECI_NFE         );
        p.WriteInteger('tpAmb'  ,   Ord(FConfig.typAmb)+1         );
        p.WriteString('nRec'    ,   TnfeRetRecepcao(Self).Recibo  );
        //
        fDadosMsg  :=p.WriteToString;
//        FDadosMsg  :=StringReplace(FDadosMsg, #10, '', [rfReplaceAll] ) ;
//        FDadosMsg  :=StringReplace(FDadosMsg, #13, '', [rfReplaceAll] ) ;
    finally
        xmlDoc.Destroy;
    end;
   fFileXML :=Format('%s-ped-rec.xml',[TnfeRetRecepcao(Self).Recibo]) ;
end;

procedure Tbasews.DoNFeStatusServico;
var xmlDoc:TNativeXml;
var p:TXmlNode;
begin
    //
    FLayOut :=LayNfeStatusServico;
    FVersao :=NFE_VER_CONS_STT_SERV;
    FTypAmb :=FConfig.typAmb ;
    FWS_Local :=Format('%s/wsdl/NfeStatusServico2',[NFE_PORTALFISCAL_INF_BR]);
    FWS_Result:='nfeStatusServicoNF2Result';

    // dados
    xmlDoc :=TNativeXml.CreateName('consStatServ');
    try
        p:=xmlDoc.Root;
        p.AttributeAdd('xmlns' ,  URL_PORTALFISCAL_INF_BR_NFE);
        p.AttributeAdd('versao',  NFE_VER_CONS_STT_SERV);
        p.WriteInteger('tpAmb' ,  Ord(FConfig.TypAmb)+1);
        p.WriteInteger('cUF'   ,  FConfig.emit.ufCodigo);
        p.WriteString('xServ'  , 'STATUS'              );
        //
        FDadosMsg  :=p.WriteToString;
    finally
        xmlDoc.Destroy;
    end;

end;

procedure Tbasews.DoRecepEvento;
var L: string;
begin
    fLayOut :=LayRecepcaoEvento;
    fFileXML:=Format('%d-ped-cce.xml',[TRecepcaoEvento(Self).Lote]) ;

    L :=Format('<envEvento versao="%s" xmlns="%s">',[TEventoCCe.VERSAO, URL_PORTALFISCAL_INF_BR_NFE]) ;
    L :=L +Format('<idLote>%d</idLote>', [TRecepcaoEvento(Self).Lote]);
    L :=L +dadosMsg	;
    L :=L +'</envEvento>';
    DadosMsg :=L;
end;

function Tbasews.Exec(): Boolean;
var
  DataText: TnfeString ;
  MemStream: TMemoryStream;
  StrStream: TnfeString;
var
  p:TXmlNode ;
begin
    Result :=False;
    LoadMsgEntrada;
    LoadURL;

    if FUrl<>'' then
    begin
      FReqResp.URL :=FUrl;
      FReqResp.SoapAction :=FWS_Local;

      DataText :=TnfeString.Create('<?xml version="1.0" encoding="utf-8"?>' );
      DataText.WriteStr('<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ');
      DataText.WriteStr('xmlns:xsd="http://www.w3.org/2001/XMLSchema" '     );
      DataText.WriteStr('xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">');
      DataText.WriteStr(  '<soap12:Header>'                                 );
      DataText.WriteStr(    '<nfeCabecMsg xmlns="%s">'        , [FWS_Local] );
      DataText.WriteStr(      '<cUF>%d</cUF>'                 , [FConfig.emit.ufCodigo]);
      DataText.WriteStr(      '<versaoDados>%s</versaoDados>' , [FVersao]   );
      DataText.WriteStr(    '</nfeCabecMsg>'                                );
      DataText.WriteStr(  '</soap12:Header>'                                );
      DataText.WriteStr(  '<soap12:Body>'                                   );
      DataText.WriteStr(    '<nfeDadosMsg xmlns="%s">'        , [FWS_Local] );
      DataText.WriteStr(      FDadosMsg                                     );
      DataText.WriteStr(    '</nfeDadosMsg>'                                );
      DataText.WriteStr(  '</soap12:Body>'                                  );
      DataText.WriteStr('</soap12:Envelope>'                                );

      try
        MemStream :=TMemoryStream.Create;
        FReqResp.Execute(DataText, MemStream);
        StrStream :=TnfeString.Create('');
        try
            StrStream.CopyFrom(MemStream, 0);
            FRetWS :=Tnfeutil.ParseText(StrStream.DataString, True);
            FRetWS :=Tnfeutil.SeparaDados(FRetWS, FWS_Result);
            Result :=True;

            FRetXML :=TNativeXml.Create() ;
            FRetXML.ReadFromString(FRetWS);

            p :=FRetXML.Root;
            FVersao :=p.ReadAttributeString('versao');
            FTypAmb :=Tnfeutil.SeSenao(p.ReadInteger('tpAmb')=1, ambPro, ambHom);
            FVerApp :=p.ReadString('verAplic');
            FCodStt :=p.ReadInteger('cStat');
            FMotivo :=p.ReadString('xMotivo');
            FUF     :=p.ReadInteger('cUF');
            FdhRecbto:=p.ReadDateTime('dhRecbto');

        finally
          DataText.Free;
          MemStream.Free;
          StrStream.Free;
        end;

      except
        on e:Exception do
        begin
          Result:=False;
          msg   :=e.Message;
        end;
      end;

    end
    else begin
      msg :='Url não encontrada!';
    end;

end;

function Tbasews.Execute: Boolean;
//var
//	xmlDoc: TNativeXml;
begin
    Result :=False;
    LoadMsgEntrada;
    LoadURL;

    if FUrl<>'' then
    begin
      Result :=True ;
      //testar aconexão com a internet
      //InternetCheckConnection('http://www.nfe.fazenda.gov.br', )
    end
    else begin
      msg :='Url não encontrada em (Tbasews.Execute)!';
    end;

    // PRA FINS DE VERIFICAÇÕES !
    {if SaveXML then
    begin
        xmlDoc  :=TNativeXml.Create ;
        try
            xmlDoc.XmlFormat    :=xfCompact;
            xmlDoc.VersionString:='1.0';
            xmlDoc.UseLocalBias :=True ;
            xmlDoc.ReadFromString(fDadosMsg);
            xmlDoc.SaveToFile(fPathXML + fFileXML);
        finally
            xmlDoc.Free ;
        end;
    end;}
end;

function Tbasews.GetURLAM(const AAmb: TnfeAmb): WideString;
begin
  case FLayOut of
    LayNfeRecepcao      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.am.gov.br/ws/services/NfeRecepcao', 'https://homnfe.sefaz.am.gov.br/ws/services/NfeRecepcao');
    LayNfeRetRecepcao   : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.am.gov.br/ws/services/NfeRetRecepcao', 'https://homnfe.sefaz.am.gov.br/ws/services/NfeRetRecepcao');
    LayNfeCancelamento  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.am.gov.br/ws/services/NfeCancelamento', 'https://homnfe.sefaz.am.gov.br/ws/services/NfeCancelamento');
    LayNfeInutilizacao  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.am.gov.br/ws/services/NfeInutilizacao', 'https://homnfe.sefaz.am.gov.br/ws/services/NfeInutilizacao');
    LayNfeConsulta      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.am.gov.br/ws/services/NfeConsulta', 'https://homnfe.sefaz.am.gov.br/ws/services/NfeConsulta');
    LayNfeStatusServico : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.am.gov.br/ws/services/NfeStatusServico', 'https://homnfe.sefaz.am.gov.br/ws/services/NfeStatusServico');
    LayNfeCadastro      : Result := Tnfeutil.SeSenao(AAmb=ambPro, '', '');
  end;
end;

function Tbasews.GetURLBA(const AAmb: TnfeAmb): WideString;
begin
  case FLayOut of
    LayNfeRecepcao      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.ba.gov.br/webservices/nfe/NfeRecepcao.asmx', 'https://hnfe.sefaz.ba.gov.br/webservices/nfe/NfeRecepcao.asmx');
    LayNfeRetRecepcao   : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.ba.gov.br/webservices/nfe/NfeRetRecepcao.asmx', 'https://hnfe.sefaz.ba.gov.br/webservices/nfe/NfeRetRecepcao.asmx');
    LayNfeCancelamento  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.ba.gov.br/webservices/nfe/NfeCancelamento.asmx', 'https://hnfe.sefaz.ba.gov.br/webservices/nfe/NfeCancelamento.asmx');
    LayNfeInutilizacao  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.ba.gov.br/webservices/nfe/NfeInutilizacao.asmx', 'https://hnfe.sefaz.ba.gov.br/webservices/nfe/NfeInutilizacao.asmx');
    LayNfeConsulta      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.ba.gov.br/webservices/nfe/NfeConsulta.asmx', 'https://hnfe.sefaz.ba.gov.br/webservices/nfe/NfeConsulta.asmx');
    LayNfeStatusServico : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.ba.gov.br/webservices/nfe/NfeStatusServico.asmx', 'https://hnfe.sefaz.ba.gov.br/webservices/nfe/NfeStatusServico.asmx');
    LayNfeCadastro      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.ba.gov.br/webservices/nfe/NfeConsulta.asmx', '');
  end;
end;

function Tbasews.GetURLCE(const AAmb: TnfeAmb): WideString;
begin
  case FLayOut of
    LayNfeRecepcao      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.ce.gov.br/nfe/services/NfeRecepcao', 'https://nfeh.sefaz.ce.gov.br/nfe/services/NfeRecepcao ');
    LayNfeRetRecepcao   : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.ce.gov.br/nfe/services/NfeRetRecepcao', 'https://nfeh.sefaz.ce.gov.br/nfe/services/NfeRetRecepcao');
    LayNfeCancelamento  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.ce.gov.br/nfe/services/NfeCancelamento', 'https://nfeh.sefaz.ce.gov.br/nfe/services/NfeCancelamento');
    LayNfeInutilizacao  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.ce.gov.br/nfe/services/NfeInutilizacao', 'https://nfeh.sefaz.ce.gov.br/nfe/services/NfeInutilizacao');
    LayNfeConsulta      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.ce.gov.br/nfe/services/NfeConsulta', 'https://nfeh.sefaz.ce.gov.br/nfe/services/NfeConsulta');
    LayNfeStatusServico : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.ce.gov.br/nfe/services/NfeStatusServico', 'https://nfeh.sefaz.ce.gov.br/nfe/services/NfeStatusServico');
    LayNfeCadastro      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.ce.gov.br/nfe/services/CadConsultaCadastro', 'https://nfeh.sefaz.ce.gov.br/nfe/services/CadConsultaCadastro');
  end;
end;

function Tbasews.GetURLCLe(const AAmb: TnfeAmb): WideString;
begin
    if AAmb=ambPro then	Result := 'https://homnfe.sefaz.am.gov.br/WSCadastroCLe/CleCadastro'
    else								Result := 'https://homnfe.sefaz.am.gov.br/WSCadastroCLeHomologacao/CleCadastro';
end;

function Tbasews.GetURLDF(const AAmb: TnfeAmb): WideString;
begin
  case FLayOut of
    LayNfeRecepcao      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://dec.fazenda.df.gov.br/nfe/ServiceRecepcao.asmx', 'https://homolog.nfe.fazenda.df.gov.br/nfe/ServiceRecepcao.asmx');
    LayNfeRetRecepcao   : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://dec.fazenda.df.gov.br/nfe/ServiceRetRecepcao.asmx', 'https://homolog.nfe.fazenda.df.gov.br/nfe/ServiceRetRecepcao.asmx');
    LayNfeCancelamento  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://dec.fazenda.df.gov.br/nfe/ServiceCancelamento.asmx', 'https://homolog.nfe.fazenda.df.gov.br/nfe/ServiceCancelamento.asmx');
    LayNfeInutilizacao  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://dec.fazenda.df.gov.br/nfe/ServiceInutilizacao.asmx', 'https://homolog.nfe.fazenda.df.gov.br/nfe/ServiceInutilizacao.asmx');
    LayNfeConsulta      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://dec.fazenda.df.gov.br/nfe/ServiceConsulta.asmx', 'https://homolog.nfe.fazenda.df.gov.br/nfe/ServiceConsulta.asmx');
    LayNfeStatusServico : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://dec.fazenda.df.gov.br/nfe/ServiceStatus.asmx', 'https://homolog.nfe.fazenda.df.gov.br/nfe/ServiceStatus.asmx');
    LayNfeCadastro      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://dec.fazenda.df.gov.br/nfe/ServiceConsultaCadastro.asmx', 'https://homolog.nfe.fazenda.df.gov.br/nfe/ServiceConsultaCadastro.asmx');
  end;
end;

function Tbasews.GetURLES(const AAmb: TnfeAmb): WideString;
begin
  case FLayOut of
    LayNfeRecepcao      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.es.gov.br/Nfe/services/NfeRecepcao', 'https://hnfe.sefaz.es.gov.br/Nfe/services/NfeRecepcao');
    LayNfeRetRecepcao   : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.es.gov.br/Nfe/services/NfeRetRecepcao', 'https://hnfe.sefaz.es.gov.br/Nfe/services/NfeRetRecepcao');
    LayNfeCancelamento  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.es.gov.br/Nfe/services/NfeCancelamento', 'https://hnfe.sefaz.es.gov.br/Nfe/services/NfeCancelamento');
    LayNfeInutilizacao  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.es.gov.br/Nfe/services/NfeInutilizacao', 'https://hnfe.sefaz.es.gov.br/Nfe/services/NfeInutilizacao');
    LayNfeConsulta      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.es.gov.br/Nfe/services/NfeConsulta', 'https://hnfe.sefaz.es.gov.br/Nfe/services/NfeConsulta');
    LayNfeStatusServico : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.es.gov.br/Nfe/services/NfeStatusServico', 'https://hnfe.sefaz.es.gov.br/Nfe/services/NfeStatusServico');
    LayNfeCadastro      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.es.gov.br/Nfe/services/CadConsultaCadastro', '');
  end;
end;

function Tbasews.GetURLGO(const AAmb: TnfeAmb): WideString;
begin
  case FLayOut of
    LayNfeRecepcao      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.go.gov.br/nfe/services/NfeRecepcao', 'https://homolog.sefaz.go.gov.br/nfe/services/NfeRecepcao');
    LayNfeRetRecepcao   : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.go.gov.br/nfe/services/NfeRetRecepcao', 'https://homolog.sefaz.go.gov.br/nfe/services/NfeRetRecepcao');
    LayNfeCancelamento  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.go.gov.br/nfe/services/NfeCancelamento', 'https://homolog.sefaz.go.gov.br/nfe/services/NfeCancelamento');
    LayNfeInutilizacao  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.go.gov.br/nfe/services/NfeInutilizacao', 'https://homolog.sefaz.go.gov.br/nfe/services/NfeInutilizacao');
    LayNfeConsulta      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.go.gov.br/nfe/services/NfeConsulta', 'https://homolog.sefaz.go.gov.br/nfe/services/NfeConsulta');
    LayNfeStatusServico : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.go.gov.br/nfe/services/NfeStatusServico', 'https://homolog.sefaz.go.gov.br/nfe/services/NfeStatusServico');
    LayNfeCadastro      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'http://nfe.sefaz.go.gov.br/nfe/services/CadConsultaCadastro', 'http://homolog.sefaz.go.gov.br/nfe/services/CadConsultaCadastro');
  end;
end;

function Tbasews.GetURLMG(const AAmb: TnfeAmb): WideString;
begin
  case FLayOut of
    LayNfeRecepcao      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.fazenda.mg.gov.br/nfe/services/NfeRecepcao', 'https://hnfe.fazenda.mg.gov.br/nfe/services/NfeRecepcao');
    LayNfeRetRecepcao   : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.fazenda.mg.gov.br/nfe/services/NfeRetRecepcao', 'https://hnfe.fazenda.mg.gov.br/nfe/services/NfeRetRecepcao');
    LayNfeCancelamento  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.fazenda.mg.gov.br/nfe/services/NfeCancelamento', 'https://hnfe.fazenda.mg.gov.br/nfe/services/NfeCancelamento');
    LayNfeInutilizacao  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.fazenda.mg.gov.br/nfe/services/NfeInutilizacao', 'https://hnfe.fazenda.mg.gov.br/nfe/services/NfeInutilizacao');
    LayNfeConsulta      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.fazenda.mg.gov.br/nfe/services/NfeConsulta', 'https://hnfe.fazenda.mg.gov.br/nfe/services/NfeConsulta');
    LayNfeStatusServico : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.fazenda.mg.gov.br/nfe/services/NfeStatusServico', 'https://hnfe.fazenda.mg.gov.br/nfe/services/NfeStatusServico');
    LayNfeCadastro      : Result := Tnfeutil.SeSenao(AAmb=ambPro, '', 'https://hnfe.fazenda.mg.gov.br/nfe/services/CadConsultaCadastro');
  end;
end;

function Tbasews.GetURLMS(const AAmb: TnfeAmb): WideString;
begin
  case FLayOut of
    LayNfeRecepcao      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://producao.nfe.ms.gov.br/producao/services/NfeRecepcao', 'https://homologacao.nfe.ms.gov.br/homologacao/services/NfeRecepcao');
    LayNfeRetRecepcao   : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://producao.nfe.ms.gov.br/producao/services/NfeRetRecepcao', 'https://homologacao.nfe.ms.gov.br/homologacao/services/NfeRetRecepcao');
    LayNfeCancelamento  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://producao.nfe.ms.gov.br/producao/services/NfeCancelamento', 'https://homologacao.nfe.ms.gov.br/homologacao/services/NfeCancelamento');
    LayNfeInutilizacao  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://producao.nfe.ms.gov.br/producao/services/NfeInutilizacao', 'https://homologacao.nfe.ms.gov.br/homologacao/services/NfeInutilizacao');
    LayNfeConsulta      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://producao.nfe.ms.gov.br/producao/services/NfeConsulta', 'https://homologacao.nfe.ms.gov.br/homologacao/services/NfeConsulta');
    LayNfeStatusServico : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://producao.nfe.ms.gov.br/producao/services/NfeStatusServico', 'https://homologacao.nfe.ms.gov.br/homologacao/services/NfeStatusServico');
    LayNfeCadastro      : Result := Tnfeutil.SeSenao(AAmb=ambPro, '', '');
  end;
end;

function Tbasews.GetURLMT(const AAmb: TnfeAmb): WideString;
begin
  case FLayOut of
    LayNfeRecepcao      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.mt.gov.br/nfews/NfeRecepcao', 'https://homologacao.sefaz.mt.gov.br/nfews/NfeRecepcao');
    LayNfeRetRecepcao   : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.mt.gov.br/nfews/NfeRetRecepcao', 'https://homologacao.sefaz.mt.gov.br/nfews/NfeRetRecepcao');
    LayNfeCancelamento  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.mt.gov.br/nfews/NfeCancelamento', 'https://homologacao.sefaz.mt.gov.br/nfews/NfeCancelamento');
    LayNfeInutilizacao  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.mt.gov.br/nfews/NfeInutilizacao', 'https://homologacao.sefaz.mt.gov.br/nfews/NfeInutilizacao');
    LayNfeConsulta      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.mt.gov.br/nfews/NfeConsulta', 'https://homologacao.sefaz.mt.gov.br/nfews/NfeConsulta');
    LayNfeStatusServico : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.mt.gov.br/nfews/NfeStatusServico', 'https://homologacao.sefaz.mt.gov.br/nfews/NfeStatusServico');
    LayNfeCadastro      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.mt.gov.br/nfews/CadConsultaCadastro', 'https://homologacao.sefaz.mt.gov.br/nfews/CadConsultaCadastro');
  end;
end;

function Tbasews.GetURLPE(const AAmb: TnfeAmb): WideString;
begin
  case FLayOut of
    LayNfeRecepcao      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeRecepcao', 'https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeRecepcao');
    LayNfeRetRecepcao   : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeRetRecepcao', 'https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeRetRecepcao');
    LayNfeCancelamento  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeCancelamento', 'https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeCancelamento');
    LayNfeInutilizacao  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeInutilizacao', 'https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeInutilizacao');
    LayNfeConsulta      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeConsulta', 'https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeConsulta');
    LayNfeStatusServico : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeStatusServico', 'https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeStatusServico');
    LayNfeCadastro      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.pe.gov.br/nfe-service/services/CadConsultaCadastro', 'https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/CadConsultaCadastro');
  end;
end;

function Tbasews.GetURLPR(const AAmb: TnfeAmb): WideString;
begin
  case FLayOut of
    LayNfeRecepcao      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.fazenda.pr.gov.br/NFENWebServices/services/nfeRecepcao', 'https://homologacao.nfe.fazenda.pr.gov.br/NFENWebServices/services/nfeRecepcao');
    LayNfeRetRecepcao   : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.fazenda.pr.gov.br/NFENWebServices/services/nfeRetRecepcao', 'https://homologacao.nfe.fazenda.pr.gov.br/NFENWebServices/services/nfeRetRecepcao');
    LayNfeCancelamento  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.fazenda.pr.gov.br/NFENWebServices/services/nfeCancelamentoNF', 'https://homologacao.nfe.fazenda.pr.gov.br/NFENWebServices/services/nfeCancelamentoNF');
    LayNfeInutilizacao  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.fazenda.pr.gov.br/NFENWebServices/services/nfeInutilizacaoNF', 'https://homologacao.nfe.fazenda.pr.gov.br/NFENWebServices/services/nfeInutilizacaoNF');
    LayNfeConsulta      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.fazenda.pr.gov.br/NFENWebServices/services/nfeConsultaNF', 'https://homologacao.nfe.fazenda.pr.gov.br/NFENWebServices/services/nfeConsultaNF');
    LayNfeStatusServico : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.fazenda.pr.gov.br/NFENWebServices/services/nfeStatusServicoNF', 'https://homologacao.nfe.fazenda.pr.gov.br/NFENWebServices/services/nfeStatusServicoNF');
    LayNfeCadastro      : Result := Tnfeutil.SeSenao(AAmb=ambPro, '', '');
  end;
end;

function Tbasews.GetURLRO(const AAmb: TnfeAmb): WideString;
begin
  case FLayOut of
    LayNfeRecepcao      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://ws.nfe.sefin.ro.gov.br/wsprod/NfeRecepcao', 'https://ws.nfe.sefin.ro.gov.br/ws/NfeRecepcao');
    LayNfeRetRecepcao   : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://ws.nfe.sefin.ro.gov.br/wsprod/NfeRetRecepcao', 'https://ws.nfe.sefin.ro.gov.br/ws/NfeRetRecepcao');
    LayNfeCancelamento  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://ws.nfe.sefin.ro.gov.br/wsprod/NfeCancelamento', 'https://ws.nfe.sefin.ro.gov.br/ws/NfeCancelamento');
    LayNfeInutilizacao  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://ws.nfe.sefin.ro.gov.br/wsprod/NfeInutilizacao', 'https://ws.nfe.sefin.ro.gov.br/ws/NfeInutilizacao');
    LayNfeConsulta      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://ws.nfe.sefin.ro.gov.br/wsprod/NfeConsulta', 'https://ws.nfe.sefin.ro.gov.br/ws/NfeConsulta');
    LayNfeStatusServico : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://ws.nfe.sefin.ro.gov.br/wsprod/NfeStatusServico', 'https://ws.nfe.sefin.ro.gov.br/ws/NfeStatusServico');
    LayNfeCadastro      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://ws.nfe.sefin.ro.gov.br/wsprod/CadConsultaCadastro', 'https://ws.nfe.sefin.ro.gov.br/ws/CadConsultaCadastro');
  end;
end;

function Tbasews.GetURLRS(const AAmb: TnfeAmb): WideString;
begin
  case FLayOut of
    LayNfeRecepcao      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.rs.gov.br/ws/nferecepcao/NfeRecepcao.asmx', 'https://homologacao.nfe.sefaz.rs.gov.br/ws/nferecepcao/NfeRecepcao.asmx');
    LayNfeRetRecepcao   : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.rs.gov.br/ws/nferetrecepcao/NfeRetRecepcao.asmx', 'https://homologacao.nfe.sefaz.rs.gov.br/ws/nferetrecepcao/NfeRetRecepcao.asmx');
    LayNfeCancelamento  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.rs.gov.br/ws/nfecancelamento/NfeCancelamento.asmx', 'https://homologacao.nfe.sefaz.rs.gov.br/ws/nfecancelamento/NfeCancelamento.asmx');
    LayNfeInutilizacao  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.rs.gov.br/ws/nfeinutilizacao/NfeInutilizacao.asmx', 'https://homologacao.nfe.sefaz.rs.gov.br/ws/nfeinutilizacao/NfeInutilizacao.asmx');
    LayNfeConsulta      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.rs.gov.br/ws/nfeconsulta/NfeConsulta.asmx', 'https://homologacao.nfe.sefaz.rs.gov.br/ws/nfeconsulta/NfeConsulta.asmx');
    LayNfeStatusServico : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefaz.rs.gov.br/ws/nfestatusservico/NfeStatusServico.asmx', 'https://homologacao.nfe.sefaz.rs.gov.br/ws/nfestatusservico/NfeStatusServico.asmx');
    LayNfeCadastro      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://sef.sefaz.rs.gov.br/ws/CadConsultaCadastro/CadConsultaCadastro.asmx', '');
  end;
end;

function Tbasews.GetURLSCAN(const AAmb: TnfeAmb): WideString;
begin
  case FLayOut of
    LayNfeRecepcao      : Result :=Tnfeutil.SeSenao(AAmb=ambPro, 'https://www.scan.fazenda.gov.br/NfeRecepcao2/NfeRecepcao2.asmx'						,'https://hom.nfe.fazenda.gov.br/SCAN/NfeRecepcao2/NfeRecepcao2.asmx');
    LayNfeRetRecepcao   : Result :=Tnfeutil.SeSenao(AAmb=ambPro, 'https://www.scan.fazenda.gov.br/NfeRetRecepcao2/NfeRetRecepcao2.asmx'			,'https://hom.nfe.fazenda.gov.br/SCAN/NfeRetRecepcao2/NfeRetRecepcao2.asmx');
    LayNfeCancelamento  : Result :=Tnfeutil.SeSenao(AAmb=ambPro, 'https://www.scan.fazenda.gov.br/NfeCancelamento2/NfeCancelamento2.asmx'		,'https://hom.nfe.fazenda.gov.br/SCAN/NfeCancelamento2/NfeCancelamento2.asmx');
    LayNfeInutilizacao  : Result :=Tnfeutil.SeSenao(AAmb=ambPro, 'https://www.scan.fazenda.gov.br/NfeInutilizacao2/NfeInutilizacao2.asmx'		,'https://hom.nfe.fazenda.gov.br/SCAN/NfeInutilizacao2/NfeInutilizacao2.asmx');
    LayNfeConsulta      : Result :=Tnfeutil.SeSenao(AAmb=ambPro, 'https://www.scan.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx'						,'https://hom.nfe.fazenda.gov.br/SCAN/NfeConsulta2/NfeConsulta2.asmx');
    LayNfeStatusServico : Result :=Tnfeutil.SeSenao(AAmb=ambPro, 'https://www.scan.fazenda.gov.br/NFeStatusServico2/NFeStatusServico2.asmx'	,'https://hom.nfe.fazenda.gov.br/SCAN/NfeStatusServico2/NfeStatusServico2.asmx');
    LayNfeCadastro      : Result :=Tnfeutil.SeSenao(AAmb=ambPro, '', '');
  end;
end;

function Tbasews.GetURLSP(const AAmb: TnfeAmb): WideString;
begin
  case FLayOut of
    LayNfeRecepcao      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.fazenda.sp.gov.br/nfeweb/services/nferecepcao.asmx', 'https://homologacao.nfe.fazenda.sp.gov.br/nfeweb/services/nferecepcao.asmx');
    LayNfeRetRecepcao   : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.fazenda.sp.gov.br/nfeweb/services/nferetrecepcao.asmx', 'https://homologacao.nfe.fazenda.sp.gov.br/nfeweb/services/nferetrecepcao.asmx');
    LayNfeCancelamento  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.fazenda.sp.gov.br/nfeweb/services/nfecancelamento.asmx', 'https://homologacao.nfe.fazenda.sp.gov.br/nfeweb/services/nfecancelamento.asmx');
    LayNfeInutilizacao  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.fazenda.sp.gov.br/nfeweb/services/nfeinutilizacao.asmx', 'https://homologacao.nfe.fazenda.sp.gov.br/nfeweb/services/nfeinutilizacao.asmx');
    LayNfeConsulta      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.fazenda.sp.gov.br/nfeweb/services/nfeconsulta.asmx', 'https://homologacao.nfe.fazenda.sp.gov.br/nfeweb/services/nfeconsulta.asmx');
    LayNfeStatusServico : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.fazenda.sp.gov.br/nfeweb/services/nfestatusservico.asmx', 'https://homologacao.nfe.fazenda.sp.gov.br/nfeweb/services/nfestatusservico.asmx');
    LayNfeCadastro      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.fazenda.sp.gov.br/nfeweb/services/cadconsultacadastro.asmx', 'https://homologacao.nfe.fazenda.sp.gov.br/nfeWEB/services/cadconsultacadastro.asmx');
  end;
end;

function Tbasews.GetURLSVAN(const AAmb: TnfeAmb): WideString;
begin
  case FLayOut of
    LayNfeRecepcao      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://www.sefazvirtual.fazenda.gov.br/NfeRecepcao2/NfeRecepcao2.asmx'					,'https://hom.sefazvirtual.fazenda.gov.br/NfeRecepcao2/NfeRecepcao2.asmx');
    LayNfeRetRecepcao   : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://www.sefazvirtual.fazenda.gov.br/NFeRetRecepcao2/NFeRetRecepcao2.asmx'		,'https://hom.sefazvirtual.fazenda.gov.br/NfeRetRecepcao2/NfeRetRecepcao2.asmx');
    LayNfeCancelamento  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://www.sefazvirtual.fazenda.gov.br/NFeCancelamento2/NFeCancelamento2.asmx'	,'https://hom.sefazvirtual.fazenda.gov.br/NfeCancelamento2/NfeCancelamento2.asmx');
    LayNfeInutilizacao  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://www.sefazvirtual.fazenda.gov.br/NFeInutilizacao2/NFeInutilizacao2.asmx'	,'https://hom.sefazvirtual.fazenda.gov.br/NfeInutilizacao2/NfeInutilizacao2.asmx');
    LayNfeConsulta      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://www.sefazvirtual.fazenda.gov.br/nfeconsulta2/nfeconsulta2.asmx'					,'https://hom.sefazvirtual.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx');
    LayNfeStatusServico : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://www.sefazvirtual.fazenda.gov.br/NFeStatusServico2/NFeStatusServico2.asmx','https://hom.sefazvirtual.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx');
    LayNfeCadastro      : Result := Tnfeutil.SeSenao(AAmb=ambPro, '', '');
    LayRecepcaoEvento   : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://www.sefazvirtual.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx', 'https://hom.sefazvirtual.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx');
  end;
end;

function Tbasews.GetURLSVRS(const AAmb: TnfeAmb): WideString;
begin
  case FLayOut of
    LayNfeRecepcao      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefazvirtual.rs.gov.br/ws/Nferecepcao/NFeRecepcao2.asmx'						,'https://homologacao.nfe.sefazvirtual.rs.gov.br/ws/Nferecepcao/NFeRecepcao2.asmx');
    LayNfeRetRecepcao   : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefazvirtual.rs.gov.br/ws/NfeRetRecepcao/NfeRetRecepcao2.asmx'			,'https://homologacao.nfe.sefazvirtual.rs.gov.br/ws/NfeRetRecepcao/NfeRetRecepcao2.asmx');
    LayNfeCancelamento  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefazvirtual.rs.gov.br/ws/NfeCancelamento/NfeCancelamento2.asmx'		,'https://homologacao.nfe.sefazvirtual.rs.gov.br/ws/NfeCancelamento/NfeCancelamento2.asmx');
    LayNfeInutilizacao  : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefazvirtual.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx'		,'https://homologacao.nfe.sefazvirtual.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx');
    LayNfeConsulta      : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefazvirtual.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx'						,'https://homologacao.nfe.sefazvirtual.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx');
    LayNfeStatusServico : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefazvirtual.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx'	,'https://homologacao.nfe.sefazvirtual.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx');
    LayNfeCadastro      : Result := Tnfeutil.SeSenao(AAmb=ambPro, '', '');
    LayRecepcaoEvento   : Result := Tnfeutil.SeSenao(AAmb=ambPro, 'https://nfe.sefazvirtual.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx', 'https://homologacao.nfe.sefazvirtual.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx');
  end;
end;

procedure Tbasews.LoadMsgEntrada;
begin
  if      Self is TNFeStatusServico then  DoNFeStatusServico
  else if Self is TNFeRecepcao      then  DoNFeRecepcao
  else if Self is TNFeRetRecepcao   then  DoNFeRetRecepcao
  else if Self is TNFeConsulta      then  DoNFeConsulta
  else if Self is TNFeCancelamento  then  DoNFeCancelamento
  else if Self is TNFeInutilizacao  then  DoNFeInutilizacao
  else if Self is TRecepcaoEvento   then  DoRecepEvento	 ;
end;

procedure Tbasews.LoadURL;
begin
  if FConfig.typEmi = emisCon_SCAN then
  begin
      FUrl :=Self.GetURLSCAN(FConfig.typAmb);
  end
  else begin
    //  (AC,AL,AP,AM,BA,CE,DF,ES,GO,MA,MT,MS,MG,PA,PB,PR,PE,PI,RJ,RN,RS,RO,RR,SC,SP,SE,TO);
    //  (12,27,16,13,29,23,53,32,52,21,51,50,31,15,25,41,26,22,33,24,43,11,14,42,35,28,17);
    case FConfig.emit.ufCodigo of
      12: FUrl :=GetURLSVRS(FConfig.typAmb); //AC
      27: FUrl :=GetURLSVRS(FConfig.typAmb); //AL
      16: FUrl :=GetURLSVRS(FConfig.typAmb); //AP
      13: FUrl :=GetURLAM(FConfig.typAmb); //AM
      29: FUrl :=GetURLBA(FConfig.typAmb); //BA
      23: FUrl :=GetURLCE(FConfig.typAmb); //CE
      53: FUrl :=GetURLDF(FConfig.typAmb); //DF
      32: FUrl :=GetURLES(FConfig.typAmb); //ES
      52: FUrl :=GetURLGO(FConfig.typAmb); //GO
      21: FUrl :=GetURLSVAN(FConfig.typAmb); //MA
      51: FUrl :=GetURLMT(FConfig.typAmb); //MT
      50: FUrl :=GetURLMS(FConfig.typAmb); //MS
      31: FUrl :=GetURLMG(FConfig.typAmb); //MG
      15: FUrl :=GetURLSVAN(FConfig.typAmb); //PA
      25: FUrl :=GetURLSVRS(FConfig.typAmb); //PB
      41: FUrl :=GetURLPR(FConfig.typAmb); //PR
      26: FUrl :=GetURLPE(FConfig.typAmb); //PE
      22: FUrl :=GetURLSVAN(FConfig.typAmb); //PI
      33: FUrl :=GetURLSVRS(FConfig.typAmb); //RJ
      24: FUrl :=GetURLSVAN(FConfig.typAmb); //RN
      43: FUrl :=GetURLRS(FConfig.typAmb); //RS
      11: FUrl :=GetURLRO(FConfig.typAmb); //RO
      14: FUrl :=GetURLSVRS(FConfig.typAmb); //RR
      42: FUrl :=GetURLSVRS(FConfig.typAmb); //SC
      35: FUrl :=GetURLSP(FConfig.typAmb); //SP
      28: FUrl :=GetURLSVRS(FConfig.typAmb); //SE
      17: FUrl :=GetURLSVRS(FConfig.typAmb); //TO
    end;
  end;
end;

procedure Tbasews.OnBeforePost(const HTTPReqResp: THTTPReqResp; Data: Pointer);
var
  Cert         : ICertificate2;
  CertContext  : ICertContext;
  PCertContext : Pointer;
  ContentHeader: string;
begin
  Cert := FConfig.GetCertificado;
  CertContext :=  Cert as ICertContext;
  CertContext.Get_CertContext(Integer(PCertContext));

  { set the certificate to use for the SSL connection }
  if not InternetSetOption(Data
    ,INTERNET_OPTION_CLIENT_CERT_CONTEXT
    ,PCertContext
    ,Sizeof(CERT_CONTEXT)) then
  begin
      raise Exception.Create('Erro OnBeforePost: ' + IntToStr(GetLastError));
  end;

  ContentHeader := Format(ContentTypeTemplate, ['application/soap+xml; charset=utf-8']);
  HttpAddRequestHeaders(Data, PChar(ContentHeader), Length(ContentHeader), HTTP_ADDREQ_FLAG_REPLACE);

  HTTPReqResp.CheckContentType;

end;

function Tbasews.SetMsgDlg(const AMsg: string): string;
begin
    Result  :=Format('%d|%s', [CodStt, Motivo]) +LineBreak;
    Result  :=Result +'Ambiente: '+ NFE_TIPO_AMB[TypAmb] +LineBreak;
    Result  :=Result +Format('Versão do Aplicativo: %s', [VerApp]) +LineBreak;
    Result  :=Result +'UF: '+ Tnfeutil.GetUF(UF) +LineBreak;
    Result  :=Result +'Recebimento: '+ DateTimeToStr(dhRecbto);
    if AMsg<>'' then
    begin
      Result :=Result +LineBreak+ AMsg;
    end;
end;

{ TnfeStatusServico }

function TnfeStatusServico.Exec: Boolean;
var
	p: TXmlNode;
begin
    Result :=False;
    if inherited Exec() then
    begin

      Result  :=CodStt = TNFe.COD_SERV_OPER;
      if Result then
      try
        p :=RetXML.Root;
        FTMed     :=p.ReadInteger('TMed');
        FdhRetorno:=p.ReadDateTime('dhRetorno');
        FObs	    :=p.ReadString('xObs');
      finally
        RetXML.Free;
      end;

      if Result then
      begin
          msg :=Format('Tempo Médio: %ds', [TMed]);
        if YearOf(dhRetorno)>=2005 then
        begin
          msg :=msg +LineBreak+ 'Retorno: '+ DateTimeToStr(dhRetorno);
        end;
        if Obs<>'' then
        begin
          msg  :=msg +LineBreak+ 'Observação: '+Obs;
        end;
      end;

      msg :=SetMsgDlg(msg);

    end
    else
      msg :='Falha ao consultar status do serviço!'+ LineBreak +msg;
end;

function TnfeStatusServico.Execute: Boolean;
var
	xmlDoc:TNativeXml;
	p:TXmlNode;
var
  Texto : String;
  Acao  : TStringList ;
  Stream: TMemoryStream;
  StrStream: TStringStream;
var
	ReqResp: THTTPReqResp;

begin
    Result :=inherited Execute;

    if not Result then
    begin
      Exit;
    end;

    Acao := TStringList.Create;
    Stream := TMemoryStream.Create;

    Texto := '<?xml version="1.0" encoding="utf-8"?>';
    Texto := Texto + '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">';
    Texto := Texto +   '<soap12:Header>';
    Texto := Texto +     '<nfeCabecMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico2">';
    Texto := Texto +       '<cUF>'+IntToStr(FConfig.emit.ufCodigo)+'</cUF>';
    Texto := Texto +       '<versaoDados>'+ NFE_VER_CONS_STT_SERV +'</versaoDados>';
    Texto := Texto +     '</nfeCabecMsg>';
    Texto := Texto +   '</soap12:Header>';
    Texto := Texto +   '<soap12:Body>';
    Texto := Texto +     '<nfeDadosMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico2">';
    Texto := Texto + FDadosMsg;
    Texto := Texto +     '</nfeDadosMsg>';
    Texto := Texto +   '</soap12:Body>';
    Texto := Texto +'</soap12:Envelope>';

    Acao.Text := Texto;

    ReqResp := THTTPReqResp.Create(nil);
    ConfigReqResp(ReqResp);
    ReqResp.URL :=FUrl;
    ReqResp.UseUTF8InHeader :=True;

    ReqResp.SoapAction := 'http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico2';

    try
        try
            ReqResp.Execute(Acao.Text, Stream);
            StrStream := TStringStream.Create('');
            try
                StrStream.CopyFrom(Stream, 0);
                FRetWS := Tnfeutil.ParseText(StrStream.DataString, True);
                FRetWS := Tnfeutil.SeparaDados(FRetWS,'nfeStatusServicoNF2Result');
            finally
                StrStream.Free;
            end;

            xmlDoc :=TNativeXml.Create;
            try
                xmlDoc.ReadFromString(FRetWS);
                p :=xmlDoc.Root;

                FTypAmb   :=Tnfeutil.SeSenao(p.ReadInteger('tpAmb')=1,ambPro,ambHom);
                FVerApp		:=p.ReadString('verAplic');
                FCodStt   :=p.ReadInteger('cStat');
                FMotivo  	:=p.ReadString('xMotivo');
                FUF      	:=p.ReadInteger('cUF');
                FdhRecbto :=p.ReadDateTime('dhRecbto');
                FTMed     :=p.ReadInteger('TMed');
                if p.NodeByName('dhRetorno')<>nil then
                begin
                		FdhRetorno:=p.ReadDateTime('dhRetorno');
                end;
                if p.NodeByName('xObs')<>nil then
                begin
                		FObs	:=p.ReadString('xObs');
                end;
            finally
                xmlDoc.Free	;
            end;

            Result  :=FCodStt = 107;

            msg  :=Format('%d|%s'#13, [FCodStt,FMotivo]);
            msg  :=msg +Format('Versão do Aplicativo: %s'#13, [FVerApp]);
            msg  :=msg +'UF: '+ Tnfeutil.GetUF(fUF) ;
            msg  :=msg +'Ambiente: '+ NFE_TIPO_AMB[FTypAmb] +LineBreak;
            msg  :=msg +'Recebimento: '+ Tnfeutil.SeSenao(FdhRecbto=0,'',DateTimeToStr(FdhRecbto)) +LineBreak;
            msg  :=msg +Format('Tempo Médio: %ds'#13, [FTMed]) +LineBreak;
            msg  :=msg +'Retorno: '+ Tnfeutil.SeSenao(FdhRetorno=0,'',DateTimeToStr(FdhRetorno)) +LineBreak;
            msg  :=msg +'Observação: '+FObs;

        except
            on e:Exception do
            begin
                Result :=False;
                msg :='Consulta Status Serviço!'#13;
                //msg :=msg +'Inativo ou Inoperante tente novamente'#13;
                msg :=msg +e.Message	;
            end;
        end;
    finally
        Acao.Free	;
        Stream.Free	;
    end;
end;

{ TnfeRecepcao }

function TnfeRecepcao.Exec: Boolean;
var
	p:TXmlNode;

begin
    Result :=False;
    if inherited Exec() then
    begin

      Result  :=CodStt = TNFe.COD_LOT_REC_SUCESS;
      if Result then
      try

        p :=RetXML.Root ;
        p :=p.NodeByName('infRec');
        if p<>nil then
        begin
          FRecibo :=p.ReadString('nRec');
          FTMed   :=p.ReadInteger('tMed');
        end;

      finally
        RetXML.Free;
      end;

      if Result then
      begin
        msg	:=Format('Recibo: ', [FRecibo]) +LineBreak;
        msg :=msg +Format('Tempo Médio: %ds', [FTMed]);
      end;

      msg :=SetMsgDlg(msg);

    end
    else
      msg :='Falha ao enviar lote!'+ LineBreak +msg;
end;

function TnfeRecepcao.Execute: Boolean;
var
	xmlDoc:TNativeXml;
	p:TXmlNode;
var
  Texto : String;
  Acao  : TStringList ;
  Stream: TMemoryStream;
  StrStream: TStringStream;
var
	ReqResp: THTTPReqResp;

begin
    Result :=inherited Execute;
    //

    Acao := TStringList.Create;
    Stream := TMemoryStream.Create;

    {Texto :=FDadosMsg ;
    FDadosMsg :=Format('<enviNFe xmlns="%s" versao="%s">' , [NFE_PORTALFISCAL_INF_BR, NFE_VER_ENVI_NFE]);
    FDadosMsg :=FDadosMsg +Format('<idLote>%d</idLote>'   , [Self.Lote] );
    FDadosMsg :=Texto +'</enviNFe>';}

    //ShowMessage(FDadosMsg);

    Texto := '<?xml version="1.0" encoding="utf-8"?>';
    Texto := Texto + '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">';
    Texto := Texto +   '<soap12:Header>';
    Texto := Texto +     '<nfeCabecMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeRecepcao2">';
    Texto := Texto +       '<cUF>'+IntToStr(FConfig.emit.ufCodigo)+'</cUF>';
    Texto := Texto +       '<versaoDados>'+ NFE_VER_ENVI_NFE +'</versaoDados>';
    Texto := Texto +     '</nfeCabecMsg>';
    Texto := Texto +   '</soap12:Header>';
    Texto := Texto +   '<soap12:Body>';
    Texto := Texto +     '<nfeDadosMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeRecepcao2">';
    Texto := Texto + FDadosMsg;
    Texto := Texto +     '</nfeDadosMsg>';
    Texto := Texto +   '</soap12:Body>';
    Texto := Texto +'</soap12:Envelope>';

    Acao.Text := Texto;

    ReqResp := THTTPReqResp.Create(nil);
    ConfigReqResp(ReqResp);
    ReqResp.URL := FUrl;
    ReqResp.UseUTF8InHeader := True;

    ReqResp.SoapAction := 'http://www.portalfiscal.inf.br/nfe/wsdl/NfeRecepcao2';

    try
        try
            ReqResp.Execute(Acao.Text, Stream);
            StrStream := TStringStream.Create('');
            try
                StrStream.CopyFrom(Stream, 0);
                FRetWS := Tnfeutil.ParseText(StrStream.DataString, True);
                FRetWS := Tnfeutil.SeparaDados(FRetWS,'nfeRecepcaoLote2Result');
            finally
                StrStream.Free;
            end;

            xmlDoc :=TNativeXml.Create;
            try
                //
                xmlDoc.ReadFromString(FRetWS);
                p :=xmlDoc.Root;

                FTypAmb :=Tnfeutil.SeSenao(p.ReadInteger('tpAmb')=1, ambPro, ambHom);
                FVerApp :=p.ReadString('verAplic');
                FUF     :=p.ReadInteger('cUF');
                FCodStt :=p.ReadInteger('cStat');
                FMotivo :=p.ReadString('xMotivo');
                Result  :=FCodStt = 103;
                if Result then
                begin
                  	FdhRecbto :=p.ReadDateTime('dhRecbto');
                    p         :=p.NodeByName('infRec');
                    FRecibo   :=p.ReadString('nRec');
                    FTMed   :=p.ReadInteger('tMed');
                end;
                // Grava no disco p/ posterior analise
//                else begin
//                    xmlDoc.ReadFromString(FDadosMsg);
//                    xmlDoc.SaveToFile(PathXML + Format('%d-envi-lot.xml', [Lote]))	;
//                end;
            finally
                xmlDoc.Free;
            end;

            msg	:=Format('%d|%s', [FCodStt,FMotivo]) +LineBreak;
            msg	:=msg +Format('Versão do Aplicativo: %s', [FVerApp]) +LineBreak;
            msg :=msg +'UF: '+ Tnfeutil.GetUF(fUF) ;
            msg :=msg +'Ambiente: '+ NFE_TIPO_AMB[FTypAmb] +LineBreak;
            msg	:=msg +'Recibo: '+ FRecibo +LineBreak	;
            msg	:=msg +'Recebimento: '+ Tnfeutil.SeSenao(FdhRecbto=0,'',DateTimeToStr(FdhRecbto)) +LineBreak	;
            msg :=msg +Format('Tempo Médio: %ds', [FTMed]);

        except
            on e:Exception do
            begin
                Result :=False;
                msg :='Falha ao enviar lote!'+ LineBreak;
                msg :=msg +e.Message	;
            end;
        end;
    finally
        Acao.Free	;
        Stream.Free	;
    end;
end;

{ TnfeConsulta }

constructor TnfeConsulta.Create(AConfig: TconfigNFe);
begin
  inherited Create(AConfig);
  FinfProt :=TinfProt.Create;
  FRetConsSitNFe := TRetConsSitNFe.Create(NFE_VER_CONS_SIT_NFE) ;
end;

destructor TnfeConsulta.Destroy;
begin
  FinfProt.Destroy;
  FRetConsSitNFe.Destroy ;
  inherited Destroy;
end;

function TnfeConsulta.Exec: Boolean;
var
//	xmlDoc: TNativeXml;
	p: TXmlNode;

begin

    Result :=inherited Exec();

    if Result then
    begin

      Result  :=CodStt in[TNFe.COD_AUT_USO_NFE,
                          TNFe.COD_CAN_HOM_NFE,
                          TNFe.COD_DEN_USO_NFE];
      if Result then
      try
        p :=RetXML.Root;
        NFeKey :=p.ReadString('chNFe');

        case CodStt of
          TNFe.COD_AUT_USO_NFE, TNFe.COD_DEN_USO_NFE:
          begin
            p :=p.NodeByName('protNFe');
            RetConsSitNFe.ProtNFe.versao :=p.ReadAttributeString('versao');
            p :=p.NodeByName('infProt');

            FRetConsSitNFe.ProtNFe.infProt.tpAmp   :=Tnfeutil.SeSenao(p.ReadInteger('tpAmb')=1, ambPro, ambHom);
            FRetConsSitNFe.ProtNFe.infProt.verAplic:=p.ReadString('verAplic');
            FRetConsSitNFe.ProtNFe.infProt.chNFe   :=p.ReadString('chNFe');
            FRetConsSitNFe.ProtNFe.infProt.dhRecbto:=p.ReadDateTime('dhRecbto');
            FRetConsSitNFe.ProtNFe.infProt.nProt   :=p.ReadString('nProt');
            FRetConsSitNFe.ProtNFe.infProt.digVal  :=p.ReadString('digVal');
            FRetConsSitNFe.ProtNFe.infProt.cStat   :=p.ReadInteger('cStat');
            FRetConsSitNFe.ProtNFe.infProt.xMotivo :=p.ReadString('xMotivo');
            FdhRecbto :=FRetConsSitNFe.ProtNFe.infProt.dhRecbto;
            FNProt    :=FRetConsSitNFe.ProtNFe.infProt.nProt;
          end;

          TNFe.COD_CAN_HOM_NFE:
          begin

            p :=p.NodeByName('retCancNFe');
            RetConsSitNFe.RetCancNfe.versao :=p.ReadAttributeString('versao');
            p :=p.NodeByName('infCanc');

            FRetConsSitNFe.RetCancNfe.infCanc.Id     :=p.ReadAttributeString('Id');
            FRetConsSitNFe.RetCancNfe.infCanc.TpAmb  :=Tnfeutil.SeSenao(p.ReadInteger('tpAmb')=1, ambPro, ambHom);
            FRetConsSitNFe.RetCancNfe.infCanc.verApp :=p.ReadString('verAplic');
            FRetConsSitNFe.RetCancNfe.infCanc.cStat  :=p.ReadInteger('cStat');
            FRetConsSitNFe.RetCancNfe.infCanc.xMotivo:=p.ReadString('xMotivo');
            FRetConsSitNFe.RetCancNfe.infCanc.cUF    :=p.ReadInteger('cUF');
            FRetConsSitNFe.RetCancNfe.infCanc.chNFe  :=p.ReadString('chNFe');
            FRetConsSitNFe.RetCancNfe.infCanc.dhRecbto:=p.ReadDateTime('dhRecbto');
            FRetConsSitNFe.RetCancNfe.infCanc.nProt   :=p.ReadString('nProt');
            FdhRecbto :=FRetConsSitNFe.RetCancNfe.infCanc.dhRecbto;
            FNProt    :=FRetConsSitNFe.RetCancNfe.infCanc.nProt;
          end;

        end;

      finally
        RetXML.Free;
      end;

      msg :=SetMsgDlg('Chave da NF-e: '+ NFeKey);
      if FNProt<>'' then
      begin
        msg :=msg +LineBreak+ 'Recebimento: '+ DateTimeToStr(dhRecbto);
        msg :=msg +LineBreak+ 'Protocolo: '+ FNProt;
      end;

    end
    else
      msg :='Falha ao consultar NF-e!'+ LineBreak +SetMsgDlg(msg);
end;

function TnfeConsulta.Execute: Boolean;
var
	xmlDoc:TNativeXml;
	p:TXmlNode;
var
  Texto : String;
  Acao  : TStringList ;
  Stream: TMemoryStream;
  StrStream: TStringStream;
var
	ReqResp: THTTPReqResp;
begin
    Result :=inherited Execute;

    Acao 	:=TStringList.Create;
    Stream:=TMemoryStream.Create;

    Texto := '<?xml version="1.0" encoding="utf-8"?>';
    Texto := Texto + '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">';
    Texto := Texto +   '<soap12:Header>';
    Texto := Texto +     '<nfeCabecMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta2">';
    Texto := Texto +       '<cUF>'+IntToStr(FConfig.emit.ufCodigo)+'</cUF>';
    Texto := Texto +       '<versaoDados>'+ NFE_VER_CONS_SIT_NFE +'</versaoDados>';
    Texto := Texto +     '</nfeCabecMsg>';
    Texto := Texto +   '</soap12:Header>';
    Texto := Texto +   '<soap12:Body>';
    Texto := Texto +     '<nfeDadosMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta2">';
    Texto := Texto + FDadosMsg;
    Texto := Texto +     '</nfeDadosMsg>';
    Texto := Texto +   '</soap12:Body>';
    Texto := Texto +'</soap12:Envelope>';

    Acao.Text := Texto;

    ReqResp := THTTPReqResp.Create(nil);
    ConfigReqResp(ReqResp);
    ReqResp.URL := FUrl;
    ReqResp.UseUTF8InHeader := True;

    ReqResp.SoapAction := 'http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta2';

    try
        try
            ReqResp.Execute(Acao.Text, Stream);
            StrStream := TStringStream.Create('');
            try
                StrStream.CopyFrom(Stream, 0);
                FRetWS := Tnfeutil.ParseText(StrStream.DataString, True);
                FRetWS := Tnfeutil.SeparaDados(FRetWS,'nfeConsultaNF2Result');
            finally
                StrStream.Free;
            end;

            xmlDoc :=TNativeXml.Create;
            try
                //
                xmlDoc.ReadFromString(FRetWS);
                p :=xmlDoc.Root;

                FVersao :=p.ReadAttributeString('versao');
                FTypAmb :=Tnfeutil.SeSenao(p.ReadInteger('tpAmb')=1, ambPro, ambHom);
                FVerApp :=p.ReadString('verAplic');
                FCodStt :=p.ReadInteger('cStat');
                FMotivo :=p.ReadString('xMotivo');
                FUF     :=p.ReadInteger('cUF');
                FNFeKey :=p.ReadString('chNFe');
                Result  :=FCodStt in[TNFe.COD_AUT_USO_NFE,
                                     TNFe.COD_CAN_HOM_NFE,
                                     TNFe.COD_DEN_USO_NFE];
                if Result then
                begin

                  p :=p.NodeByName('protNFe') ;
                  p :=p.NodeByName('infProt') ;
                  FinfProt.tpAmp    :=Tnfeutil.SeSenao(p.ReadInteger('tpAmb')=1, ambPro, ambHom);
                  FinfProt.verAplic :=p.ReadString('verAplic');
                  FinfProt.chNFe    :=p.ReadString('chNFe');
                  FinfProt.dhRecbto :=p.ReadDateTime('dhRecbto');
                  FinfProt.nProt    :=p.ReadString('nProt');
                  FinfProt.digVal   :=p.ReadString('digVal');

//                  FTypAmb 					:=FinfProt.tpAmp	;
//                  FVerApp 					:=FinfProt.verAplic;
//                  FNFeKey           :=FinfProt.chNFe	;
                  FdhRecbto :=FinfProt.dhRecbto	;
                  FNProt    :=FinfProt.nProt	;
                end;

            finally
                xmlDoc.Free;
            end;

            msg	:=Format('%d|%s', [FCodStt,FMotivo]) +LineBreak;
            msg	:=msg +Format('Versão do Layout: %s', [FVersao]) +LineBreak;
            msg :=msg +'Ambiente: '+ NFE_TIPO_AMB[FTypAmb] +LineBreak;
            msg	:=msg +Format('Versão do Aplicativo: %s', [FVerApp]) +LineBreak;
            msg :=msg +'UF: '+ Tnfeutil.GetUF(FUF) +LineBreak;
            msg	:=msg +'Chave da NF-e: '+ FNFeKey +LineBreak ;
            if FNProt<>'' then
            begin
              msg	:=msg +'Recebimento: '+ DateTimeToStr(FdhRecbto) +LineBreak ;
              msg	:=msg +'Protocolo: '+ FNProt;
            end;

        except
            on e:Exception do
            begin
                Result :=False;
                msg :='Falha ao consultar nota!'+ LineBreak;
                msg :=msg +e.Message	;
            end;
        end;

    finally
        Acao.Free	;
        Stream.Free	;
    end;

end;

{ TnfeRetRecepcao }

constructor TnfeRetRecepcao.Create(AConfig: TconfigNFe);
begin
  inherited Create(AConfig);
  FretConsReciNFe :=TretConsReciNFe.Create;
end;

destructor TnfeRetRecepcao.Destroy;
begin
  FretConsReciNFe.Destroy;
  inherited Destroy;
end;

function TnfeRetRecepcao.Exec: Boolean;
var
	r,p:TXmlNode;

  count:Integer;
  i:Integer;
  np:TXmlNode;
  infProt:TinfProt;
  chnfe:string;

begin
    Result :=inherited Exec() ;
    if not Result then
    begin
      count :=1;
      while not Result do
      begin
        Sleep(4000);
        Result :=inherited Exec() ;
        if count > 3 then
        begin
          Break;
        end;
        count := count +1;
      end;
    end;

    if Result then
    begin

      Result  :=CodStt = TNFe.COD_LOT_PROCESS;
      if Result then
      try
        r :=RetXML.Root;

        for i :=0 to r.NodeCount -1 do
        begin
           // loop p/ cada NF-e
           p :=r.Nodes[i].NodeByName('infProt');
           if p<>nil then
           begin
             chnfe:=p.ReadString('chNFe');
             infProt  :=retConsReciNFe.IndexOfKey(chnfe);
             if infProt = nil then
             begin
                infProt         :=retConsReciNFe.CreateNew;
                infProt.tpAmp   :=Tnfeutil.SeSenao(p.ReadInteger('tpAmp')=1,ambPro,ambHom);
                infProt.verAplic:=p.ReadString('verAplic');
                infProt.chNFe   :=chnfe;
                infProt.dhRecbto:=p.ReadDateTime('dhRecbto');
                infProt.nProt   :=p.ReadString('nProt');
                infProt.digVal  :=p.ReadString('digVal');
                infProt.cStat   :=p.ReadInteger('cStat');
                infProt.xMotivo :=p.ReadString('xMotivo');
             end;
           end;
        end;

      finally
        RetXML.Free;
      end;

    end
    else
      msg :='Falha ao consultar o resultado do processamento do lote!'+ LineBreak +msg;

end;

function TnfeRetRecepcao.Execute(): Boolean;
var xmlDoc:TNativeXml;
var p:TXmlNode;
  //
  function Process: Boolean;
  var
  		Texto : String;
    	Acao  : TStringList ;
    	Stream: TMemoryStream;
    	StrStream: TStringStream;
  var
  		ReqResp: THTTPReqResp;
  var
      retXml :TNativeXml;
  begin

      Acao	:=TStringList.Create;
      Stream:=TMemoryStream.Create;

      Texto := '<?xml version="1.0" encoding="utf-8"?>';
      Texto := Texto + '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">';
      Texto := Texto +   '<soap12:Header>';
      Texto := Texto +     '<nfeCabecMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeRetRecepcao2">';
      Texto := Texto +       '<cUF>'+IntToStr(FConfig.emit.ufCodigo)+'</cUF>';
      Texto := Texto +       '<versaoDados>'+ NFE_VER_CONS_RECI_NFE +'</versaoDados>';
      Texto := Texto +     '</nfeCabecMsg>';
      Texto := Texto +   '</soap12:Header>';
      Texto := Texto +   '<soap12:Body>';
      Texto := Texto +     '<nfeDadosMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeRetRecepcao2">';
      Texto := Texto + FDadosMsg;
      Texto := Texto +     '</nfeDadosMsg>';
      Texto := Texto +   '</soap12:Body>';
      Texto := Texto +'</soap12:Envelope>';

      Acao.Text := Texto;

      ReqResp := THTTPReqResp.Create(nil);
      ConfigReqResp(ReqResp);
      ReqResp.URL := FUrl;
      ReqResp.UseUTF8InHeader := True;

      ReqResp.SoapAction := 'http://www.portalfiscal.inf.br/nfe/wsdl/NfeRetRecepcao2';

      try
          try
              ReqResp.Execute(Acao.Text, Stream);
              StrStream := TStringStream.Create('');
              try
                  StrStream.CopyFrom(Stream, 0);
                  FRetWS := Tnfeutil.ParseText(StrStream.DataString, True);
                  FRetWS := Tnfeutil.SeparaDados(FRetWS,'nfeRetRecepcao2Result');
              finally
                  StrStream.Free;
              end;

              retXml :=TNativeXml.Create;
              try
                  retXml.ReadFromString(FRetWS);
                  p :=retXml.Root;

                  FTypAmb :=Tnfeutil.SeSenao(p.ReadInteger('tpAmb')=1, ambPro, ambHom);
                  FVerApp :=p.ReadString('verAplic');
                  FUF     :=p.ReadInteger('cUF');
                  FCodStt :=p.ReadInteger('cStat');
                  FMotivo :=p.ReadString('xMotivo');
                  FRecibo	:=p.ReadString('nRec');
                  FcMsg		:=p.ReadInteger('cMsg');
                  FxMsg 	:=p.ReadString('xMsg');
                  Result  :=FCodStt = 105;
              finally
                  retXml.Free	;
              end;

              msg	:=Format('%d|%s', [FCodStt,FMotivo]) +LineBreak;
              msg	:=msg +Format('Versão do Aplicativo: %s', [FVerApp]) +LineBreak;
              msg :=msg +'UF: '+ Tnfeutil.GetUF(fUF) +LineBreak;
              msg :=msg +'Ambiente: '+ NFE_TIPO_AMB[FTypAmb] +LineBreak;
              msg	:=msg +'Recibo: '+ FRecibo +LineBreak	;
              msg	:=msg +'Mensagem:' +Format('%d|%s', [FcMsg,FxMsg]) ;

          except
              on e:Exception do
              begin
                  Result :=False;
                  msg :='Falha ao consultar o resultado do processamento do lote!'+ LineBreak;
                  msg :=msg +e.Message	;
              end;
          end;

      finally
          Acao.Free	;
          Stream.Free	;
      end;
  end;
  //
var count:Integer;
var i:Integer;
var np:TXmlNode;
var infProt:TinfProt;
var chnfe:string;
begin
    Result :=inherited Execute;
    count :=1000;
    while Process do
    begin
        Sleep(count);
        if count > 3000 then
        begin
            Break;
        end;
        count := count +1000;
    end;

    Result :=FCodStt=104	;
    if Result then
    begin

        xmlDoc :=TNativeXml.Create;
        try
            xmlDoc.ReadFromString(FRetWS);
            p :=xmlDoc.Root;

            for i :=0 to p.NodeCount -1 do
            begin

                 // loop p/ cada NF-e
//                 if p.Nodes[i].NodeCount > 0 then
//                 begin
//
//                     infProt  :=Self.FretConsReciNFe.IndexOfKey(p.Nodes[i].Nodes[0].ReadString('chNFe'));
//                     if infProt = nil then
//                     begin
//                        infProt         :=Self.FretConsReciNFe.CreateNew;
//                        infProt.tpAmp   :=Tnfeutil.SeSenao(p.Nodes[i].Nodes[0].ReadInteger('tpAmp')=1,ambPro,ambHom);
//                        infProt.verAplic:=p.Nodes[i].Nodes[0].ReadString('verAplic');
//                        infProt.chNFe   :=p.Nodes[i].Nodes[0].ReadString('chNFe');
//                        infProt.dhRecbto:=p.Nodes[i].Nodes[0].ReadDateTime('dhRecbto');
//                        infProt.nProt   :=p.Nodes[i].Nodes[0].ReadString('nProt');
//                        infProt.digVal  :=p.Nodes[i].Nodes[0].ReadString('digVal');
//                        infProt.cStat   :=p.Nodes[i].Nodes[0].ReadInteger('cStat');
//                        infProt.xMotivo :=p.Nodes[i].Nodes[0].ReadString('xMotivo');
//                     end;
//
//                 end;

                 np :=p.Nodes[i].NodeByName('infProt');
                 if np<>nil then
                 begin
                   chnfe:=np.ReadString('chNFe');
                   infProt  :=Self.FretConsReciNFe.IndexOfKey(chnfe);
                   if infProt = nil then
                   begin
                      infProt         :=Self.FretConsReciNFe.CreateNew;
                      infProt.tpAmp   :=Tnfeutil.SeSenao(np.ReadInteger('tpAmp')=1,ambPro,ambHom);
                      infProt.verAplic:=np.ReadString('verAplic');
                      infProt.chNFe   :=chnfe; // prot.ReadString('chNFe');
                      infProt.dhRecbto:=np.ReadDateTime('dhRecbto');
                      infProt.nProt   :=np.ReadString('nProt');
                      infProt.digVal  :=np.ReadString('digVal');
                      infProt.cStat   :=np.ReadInteger('cStat');
                      infProt.xMotivo :=np.ReadString('xMotivo');
                   end;
                 end;
            end;

            if Self.SaveXML then
            begin
                fFileXML :=Format('%s-ret-rec.xml',[Self.Recibo]) ;
                xmlDoc.SaveToFile(fFileXML);
            end;

        finally
            xmlDoc.Free	;
        end;
    end	;
end;

{ TnfeCancelamento }

function TnfeCancelamento.Execute: Boolean;
var
	xmlDoc:TNativeXml;
	p:TXmlNode;
var
  Texto : String;
  Acao  : TStringList ;
  Stream: TMemoryStream;
  StrStream: TStringStream;
var
	ReqResp: THTTPReqResp;
begin
    Result :=inherited Execute;

    Acao := TStringList.Create;
    Stream := TMemoryStream.Create;

    Texto := '<?xml version="1.0" encoding="utf-8"?>';
    Texto := Texto + '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">';
    Texto := Texto +   '<soap12:Header>';
    Texto := Texto +     '<nfeCabecMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeCancelamento2">';
    Texto := Texto +       '<cUF>'+IntToStr(FConfig.emit.ufCodigo)+'</cUF>';
    Texto := Texto +       '<versaoDados>'+ NFE_VER_CANC_NFE +'</versaoDados>';
    Texto := Texto +     '</nfeCabecMsg>';
    Texto := Texto +   '</soap12:Header>';
    Texto := Texto +   '<soap12:Body>';
    Texto := Texto +     '<nfeDadosMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeCancelamento2">';
    Texto := Texto + FDadosMsg;
    Texto := Texto +     '</nfeDadosMsg>';
    Texto := Texto +   '</soap12:Body>';
    Texto := Texto +'</soap12:Envelope>';

    Acao.Text := Texto;

    ReqResp := THTTPReqResp.Create(nil);
    ConfigReqResp( ReqResp );
    ReqResp.URL := FURL;
    ReqResp.UseUTF8InHeader := True;
    ReqResp.SoapAction := 'http://www.portalfiscal.inf.br/nfe/wsdl/NfeCancelamento2';

    try
        try
            ReqResp.Execute(Acao.Text, Stream);
            StrStream := TStringStream.Create('');
            try
                StrStream.CopyFrom(Stream, 0);
                FRetWS := Tnfeutil.ParseText(StrStream.DataString, True);
                FRetWS := Tnfeutil.SeparaDados(FRetWS,'nfeCancelamentoNF2Result');
            finally
                StrStream.Free;
            end;

            xmlDoc :=TNativeXml.Create;
            try
                //
                xmlDoc.ReadFromString(FRetWS);
                p :=xmlDoc.Root;

                FVersao :=p.AttributeByName['versao'].Value ;
                p :=p.NodeByName('infCanc');
                if p<>nil then
                begin
                    FTypAmb :=Tnfeutil.SeSenao(p.ReadInteger('tpAmb')=1, ambPro, ambHom);
                    FVerApp :=p.ReadString('verApp');
                    FCodStt :=p.ReadInteger('cStat');
                    FMotivo :=p.ReadString('xMotivo');
                    FUF     :=p.ReadInteger('cUF');
                    Result  :=FCodStt = 101;
                    if Result then
                    begin
                        FNFeKey 	:=p.ReadString('chNFe');
                        FdhRecbto	:=p.ReadDateTime('dhRecbto');
                        FNProt  	:=p.ReadString('nProt');
                    end;
                end;
            finally
                xmlDoc.Free	;
            end;

            msg	:=Format('%d|%s', [FCodStt,FMotivo]) +LineBreak;
            msg	:=msg +'Versão do Aplicativo: '+ FVerApp +LineBreak;
            msg :=msg +'UF: '+ Tnfeutil.GetUF(fUF) +LineBreak;
            msg :=msg +'Ambiente: '+ NFE_TIPO_AMB[FTypAmb] +LineBreak;
            msg	:=msg +'Chave Acesso: '+ FNFeKey +LineBreak	;
            msg	:=msg +'Recebimento: '+ Tnfeutil.SeSenao(FdhRecbto=0,'',DateTimeToStr(FdhRecbto)) +LineBreak	;
            msg	:=msg +'Protocolo: '+ FNProt ;

        except
            on e:Exception do
            begin
                Result :=False;
                msg :='Falha ao cancelar nota!'+ LineBreak;
                msg :=msg +e.Message	;
            end;
        end;
    finally
        Acao.Free	;
        Stream.Free	;
    end;

end;

procedure TnfeCancelamento.SetJust(AValue: AnsiString);
begin
    if Tnfeutil.IsEmpty(AValue) then
    begin
        raise Exception.Create('Informe a justificativa para o cancelamento!');
    end ;

    if Length(AValue) < 15 then
    begin
        raise Exception.Create('A Justificativa para cancelar a NF-e deve ter no minimo 15 caracteres!');
    end ;

    FJust	:= Tnfeutil.TrataString(AValue);

end;

{ TnfeInutilizacao }

function TnfeInutilizacao.Execute: Boolean;
var
	xmlDoc:TNativeXml;
	p:TXmlNode;
var
  Texto : String;
  Acao  : TStringList ;
  Stream: TMemoryStream;
  StrStream: TStringStream;
var
	ReqResp: THTTPReqResp;
begin
    Result :=inherited Execute;

    Acao := TStringList.Create;
    Stream := TMemoryStream.Create;

    Texto := '<?xml version="1.0" encoding="utf-8"?>';
    Texto := Texto + '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">';
    Texto := Texto +   '<soap12:Header>';
    Texto := Texto +     '<nfeCabecMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeInutilizacao2">';
    Texto := Texto +       '<cUF>'+IntToStr(FConfig.emit.ufCodigo)+'</cUF>';
    Texto := Texto +       '<versaoDados>'+ NFE_VER_INUT_NFE +'</versaoDados>';
    Texto := Texto +     '</nfeCabecMsg>';
    Texto := Texto +   '</soap12:Header>';
    Texto := Texto +   '<soap12:Body>';
    Texto := Texto +     '<nfeDadosMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeInutilizacao2">';
    Texto := Texto + FDadosMsg;
    Texto := Texto +     '</nfeDadosMsg>';
    Texto := Texto +   '</soap12:Body>';
    Texto := Texto +'</soap12:Envelope>';

    Acao.Text := Texto;

    ReqResp := THTTPReqResp.Create(nil);
    ConfigReqResp( ReqResp );
    ReqResp.URL := FURL;
    ReqResp.UseUTF8InHeader := True;
    ReqResp.SoapAction := 'http://www.portalfiscal.inf.br/nfe/wsdl/NfeInutilizacao2';

    try
        try
            ReqResp.Execute(Acao.Text, Stream);
            StrStream := TStringStream.Create('');
            try
                StrStream.CopyFrom(Stream, 0);
                FRetWS := Tnfeutil.ParseText(StrStream.DataString, True);
                FRetWS := Tnfeutil.SeparaDados(FRetWS,'nfeInutilizacaoNF2Result');
            finally
                StrStream.Free;
            end;

            xmlDoc :=TNativeXml.Create;
            try
                //
                xmlDoc.ReadFromString(FRetWS);
                p :=xmlDoc.Root;

                FVersao :=p.AttributeByName['versao'].Value ;
                p :=p.NodeByName('infInut');
                if p<>nil then
                begin
                    FTypAmb :=Tnfeutil.SeSenao(p.ReadInteger('tpAmb')=1, ambPro, ambHom);
                    FVerApp :=p.ReadString('verApp');
                    FCodStt :=p.ReadInteger('cStat');
                    FMotivo :=p.ReadString('xMotivo');
                    FUF     :=p.ReadInteger('cUF');
                    Result  :=FCodStt = 102;
                    if Result then
                    begin
                        FAno		:=p.ReadInteger('cUF');
                        FCNPJ		:=p.ReadString('CNPJ');
                        FModelo	:=p.ReadInteger('mod');
                        FSerie	:=p.ReadInteger('serie');
                        FNroIni	:=p.ReadInteger('nNFIni');
                        FNroFin	:=p.ReadInteger('nNFFin');
                        FdhReceb:=p.ReadDateTime('dhRecbto');
                        FNProt  :=p.ReadString('nProt');
                    end;
                end;
            finally
                xmlDoc.Free	;
            end;

            msg	:=Format('%d|%s', [FCodStt,FMotivo]) +LineBreak;
            msg	:=msg +'Versão do Aplicativo: '+ FVerApp +LineBreak;
            msg :=msg +'UF: '+ Tnfeutil.GetUF(fUF) +LineBreak;
            msg :=msg +'Ambiente: '+ NFE_TIPO_AMB[FTypAmb] +LineBreak;
            msg	:=msg +'Recebimento: '+ Tnfeutil.SeSenao(FdhRecbto=0,'',DateTimeToStr(FdhRecbto)) +LineBreak	;
            msg	:=msg +'Protocolo: '+ FNProt ;

        except
            on e:Exception do
            begin
                Result :=False;
                msg :='Falha ao inutilizar!'+ LineBreak;
                msg :=msg +e.Message	;
            end;
        end;
    finally
        Acao.Free	;
        Stream.Free	;
    end;

end;

function TnfeInutilizacao.GetId: AnsiString;
begin
    Result  :='ID';
    Result  :=Result  +IntToStr(FConfig.emit.UFcodigo);
    Result  :=Result  +Tnfeutil.FInt(FAno, 2 );
    Result  :=Result  +FCNPJ                         ;
    Result  :=Result  +Tnfeutil.FInt(FModelo	, 2 );
    Result  :=Result  +Tnfeutil.FInt(FSerie  , 3 );
    Result  :=Result  +Tnfeutil.FInt(FNroIni , 9 );
    Result  :=Result  +Tnfeutil.FInt(FNroFin , 9 );
end;

procedure TnfeInutilizacao.SetAno(AValue: Integer);
begin
    if AValue > 0 then
    begin
      FAno  :=StrToIntDef(Copy(IntToStr(AValue),3,2),0);
    end;
end;

procedure TnfeInutilizacao.SetJust(AValue: AnsiString);
begin
    AValue  :=Trim(AValue);
    if Tnfeutil.IsEmpty(AValue) then
    begin
        raise Exception.Create('Informe a justificativa para inutilização!');
    end;

    if Length(AValue) < 15 then
    begin
        raise Exception.Create('A Justificativa para inutilização da NF-e deve ter no minimo 15 caracteres!');
    end ;

    FJust	:= Tnfeutil.TrataString(AValue);
end;

{ TRecepcaoEvento }

constructor TRecepcaoEvento.Create(AConfig: TconfigNFe; AIndTypEvent: TIndTypEventNFe);
begin
    inherited Create(AConfig);
    fIndTypEvent :=AIndTypEvent ;
end;

function TRecepcaoEvento.Execute: Boolean;
var
	xmlDoc:TNativeXml;
	p:TXmlNode;
var
  Texto : String;
  Acao  : TStringList ;
  Stream: TMemoryStream;
  StrStream: TStringStream;
var
	ReqResp: THTTPReqResp;

begin
    Result :=inherited Execute;
    //

    Acao := TStringList.Create;
    Stream := TMemoryStream.Create;

    Texto := '<?xml version="1.0" encoding="utf-8"?>';
    Texto := Texto + '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">';
    Texto := Texto +   '<soap12:Header>';
    Texto := Texto +     '<nfeCabecMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/RecepcaoEvento">';
    Texto := Texto +       Format('<cUF>%d</cUF>',[FConfig.emit.ufCodigo]);
    Texto := Texto +       Format('<versaoDados>%s</versaoDados>', [TEventoCCe.VERSAO]);
    Texto := Texto +     '</nfeCabecMsg>';
    Texto := Texto +   '</soap12:Header>';
    Texto := Texto +   '<soap12:Body>';
    Texto := Texto +     '<nfeDadosMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/RecepcaoEvento">';
    Texto := Texto + FDadosMsg;
    Texto := Texto +     '</nfeDadosMsg>';
    Texto := Texto +   '</soap12:Body>';
    Texto := Texto +'</soap12:Envelope>';

    Acao.Text := Texto;

    ReqResp := THTTPReqResp.Create(nil);
    ConfigReqResp(ReqResp);
    ReqResp.URL := FUrl;
    ReqResp.UseUTF8InHeader := True;

    ReqResp.SoapAction := 'http://www.portalfiscal.inf.br/nfe/wsdl/RecepcaoEvento';

    try
        try
            ReqResp.Execute(Acao.Text, Stream);
            StrStream := TStringStream.Create('');
            try
                StrStream.CopyFrom(Stream, 0);
                FRetWS := Tnfeutil.ParseText(StrStream.DataString, True);
                FRetWS := Tnfeutil.SeparaDados(FRetWS,'nfeRecepcaoEventoResult');
            finally
                StrStream.Free;
            end;

            xmlDoc :=TNativeXml.Create;
            try
                //
                xmlDoc.ReadFromString(FRetWS);
                p :=xmlDoc.Root;
                FXML    :=p.WriteToString ;
                FTypAmb :=Tnfeutil.SeSenao(p.ReadInteger('tpAmb')=1, ambPro, ambHom);
                FVerApp :=p.ReadString('verAplic');
                FCodOrg :=p.ReadInteger('cOrgao');
                FCodStt :=p.ReadInteger('cStat');
                FMotivo :=p.ReadString('xMotivo');
                Result  :=FCodStt = TEventoNfe.COD_PROCESS_LOTE;
                if Result then
                begin
                    p :=p.FindNode('infEvento');
                    if p<>nil then
                    begin
                        FTypAmb :=Tnfeutil.SeSenao(p.ReadInteger('tpAmb')=1, ambPro, ambHom);
                        FVerApp :=p.ReadString('verAplic');
                        FCodStt :=p.ReadInteger('cStat');
                        FMotivo :=p.ReadString('xMotivo');
                        FDtHReg :=p.ReadDateTime('dhRegEvento');
                        Result := FCodStt = TEventoNfe.COD_EVENT_VINC_NFE ;
                        if Result then
                        begin
                            FNrProt :=p.ReadString('nProt');
                        end;
                    end;
                end
                else begin
                    if Self.SaveXML then
                    begin
                        fFileXML:=Format('%d-ret-cce.xml',[Self.Lote]) ;
                        xmlDoc.XmlFormat    :=xfCompact;
                        xmlDoc.VersionString:='1.0';
                        xmlDoc.UseLocalBias :=True ;
                        xmlDoc.SaveToFile(fPathXML + fFileXML);
                    end;
                end;
            finally
                xmlDoc.Free	;
            end;

            msg	:=Format('%d|%s', [FCodStt,FMotivo]) +LineBreak;
            msg	:=msg +Format('Versão do Aplicativo: %s', [FVerApp]) +LineBreak;
            msg :=msg +'Codido do Orgão: '+ IntToStr(FCodOrg) ;
            msg :=msg +'Ambiente: '+ NFE_TIPO_AMB[FTypAmb] +LineBreak;
            msg	:=msg +'Registro do evento: '+ DateTimeToStr(FdhRecbto);

        except
            on e:Exception do
            begin
                Result :=False;
                msg :='Falha ao enviar lote!'+ LineBreak;
                msg :=msg +e.Message	;
            end;
        end;
    finally
        Acao.Free	;
        Stream.Free	;
    end;
end;


{$REGION 'TnfeCustomLayout'}
  { TnfeCustomLayout }

constructor TnfeCustomLayout.Create(const ARetXML: UTF8String;
  const AUseLocalBias: Boolean);
begin
  docXML :=TNativeXml.Create;
  docXML.XmlFormat :=xfCompact ;
  docXML.UseLocalBias :=AUseLocalBias ;
  if ARetXML <> EmptyStr then
  begin
    DoLoad(ARetXML);
  end;
end;

constructor TnfeCustomLayout.CreateName(const ARootName, AVersao: UTF8String);
begin
  docXML :=TNativeXml.CreateName(ARootName);
  docXML.XmlFormat :=xfCompact ;
  docXML.UseLocalBias :=False ;
  docXML.Root.AttributeAdd('xmlns'  ,  URL_PORTALFISCAL_INF_BR_NFE   );
  docXML.Root.AttributeAdd('versao' ,  AVersao                       );
end;

destructor TnfeCustomLayout.Destroy;
begin
  docXML.Destroy ;
  inherited Destroy ;
end;

procedure TnfeCustomLayout.DoLoad(AReturn: UTF8String);
begin
  try
    docXML.ReadFromString(AReturn);
    fversao :=docXML.Root.ReadAttributeString('versao');
    case docXML.Root.ReadInteger('tpAmb') of
      1: ftpAmb :=ambPro;
      2: ftpAmb :=ambHom;
    end;
    fverAplic:=docXML.Root.ReadString('verAplic');
    fcStat   :=docXML.Root.ReadInteger('cStat');
    fxMotivo :=docXML.Root.ReadString('xMotivo');
    fcUF     :=docXML.Root.ReadInteger('cUF');
  except
  end;
end;

procedure TnfeCustomLayout.DoSave(const ALocal, AFileName: string);
var
  dir: string ;
  arq: string ;
begin
  if (ALocal<>'') and DirectoryExists(ALocal) then
  begin
    dir :=ExcludeTrailingPathDelimiter(ALocal);
    arq :=dir +'\'+ AFileName;
  end
  else
    arq :=AFileName ;
  docXML.SaveToFile(arq);
end;

function TnfeCustomLayout.getXML: UTF8String;
begin
  Result :=docXML.Root.WriteToString ;
end;

procedure TnfeCustomLayout.ImportFromStr(const AValue: Utf8String);
var
  S: TnfeString;
  R: TsdElement ;
  I: Integer ;
begin
  if Assigned(docXML.Root) then
  begin
    S :=TnfeString.Create(AValue) ;
    try
      docXML.Root.WriteStream(S) ;
    finally
      S.Free ;
    end;
  end;
end;

constructor TnfeCustomLayout.NewConsReciNFe(const ATpAmb: TnfeAmb;
  const ANroRec, AVersao: string);
begin
  docXML :=TNativeXml.CreateName('consReciNFe');
  docXML.XmlFormat :=xfCompact;
  docXML.Root.AttributeAdd('xmlns'  ,  URL_PORTALFISCAL_INF_BR_NFE   );
  docXML.Root.AttributeAdd('versao' ,  AVersao                       );
  docXML.Root.WriteInteger('tpAmb'  ,  Ord(ATpAmb)+1                 );
  docXML.Root.WriteString('nRec'    ,  ANroRec                       );
end;

constructor TnfeCustomLayout.NewConsSitNFe(const ATpAmb: TnfeAmb;
  const AchNFe, AVersao: string);
begin
  docXML :=TNativeXml.CreateName('consSitNFe');
  docXML.XmlFormat :=xfCompact ;
  docXML.Root.AttributeAdd('xmlns' , NFE_PORTALFISCAL_INF_BR );
  docXML.Root.AttributeAdd('versao', AVersao                 );
  docXML.Root.WriteInteger('tpAmb' , Ord(ATpAmb)+1           );
  docXML.Root.WriteString('xServ'  , 'CONSULTAR'             );
  docXML.Root.WriteString('chNFe'  , AchNFe                  );
end;

constructor TnfeCustomLayout.NewConsStatServNFe(const ATpAmb: TnfeAmb);
begin
  docXML :=TNativeXml.CreateName('consStatServ');
  docXML.XmlFormat :=xfCompact ;
  docXML.Root.AttributeAdd('xmlns' , URL_PORTALFISCAL_INF_BR_NFE);
  docXML.Root.AttributeAdd('versao', NFE_VER_CONS_STT_SERV   );
  docXML.Root.WriteInteger('tpAmb' , Ord(ATpAmb)+1           );
  docXML.Root.WriteString('xServ'  , 'STATUS'                );
end;

constructor TnfeCustomLayout.NewEnvEventoNFe(ALote: Integer);
begin
  docXML :=TNativeXml.CreateName('envEvento');
  docXML.XmlFormat :=xfCompact ;
  docXML.Root.AttributeAdd('xmlns' , NFE_PORTALFISCAL_INF_BR );
  docXML.Root.AttributeAdd('versao', NFE_VER_EVT_CAN         );
  docXML.Root.WriteInteger('idLote', ALote                   );
end;

function TnfeCustomLayout.NodeByNameOrTree(
  const ANameOrTree: Utf8String): TXmlNode;
begin
  Result :=nil ;
  if Assigned(docXML.Root) then
  begin
    Result :=docXML.Root.FindNode(ANameOrTree) ;
  end;
end;

function TnfeCustomLayout.NodeNew(const AName: Utf8String): TXmlNode;
begin
  Result :=nil ;
  if Assigned(docXML.Root) then
  begin
    Result :=docXML.Root.NodeNew(AName) ;
  end;
end;

function TnfeCustomLayout.ReadDateTime(const AName: Utf8String;
  const ARootName: Utf8String): TDateTime;
var
  N: TXmlNode ;
begin
  Result :=0;
  if Assigned(docXML.Root) then
  begin
    N :=docXML.Root.NodeByName(ARootName);
    if N = nil then
    begin
      N :=docXML.Root;
    end;
    Result :=N.ReadDateTime(AName);
  end;
end;

procedure TnfeCustomLayout.WriteInt(const AName: Utf8String;
  const AValue: Integer; const ARootName: Utf8String);
var
  N: TXmlNode ;
begin
  if Assigned(docXML.Root) then
  begin
    N :=docXML.Root.NodeByName(ARootName);
    if N = nil then
    begin
      N :=docXML.Root;
    end;
    N.WriteInteger(AName, AValue);
  end;
end;

procedure TnfeCustomLayout.WriteStr(const AName, AValue: Utf8String;
  const ARootName: Utf8String);
var
  N: TXmlNode ;
begin
  if Assigned(docXML.Root) then
  begin
    N :=docXML.Root.NodeByName(ARootName);
    if N = nil then
    begin
      N :=docXML.Root;
    end;
    N.WriteString(AName, AValue);
  end;
end;

{
  constructor TnfeCustomLayout.NewReturn(AReturn: AnsiString);
  begin
    docXML :=TNativeXml.Create;
    docXML.XmlFormat :=xfCompact ;
    DoLoad(AReturn);
  end;
}
{$ENDREGION}

{ TBaseNFeWS }

constructor TBaseNFeWS.Create;
begin
  fReqResp :=THTTPReqResp.Create(nil);
  fReqResp.OnBeforePost   :=OnBeforePost;
  fReqResp.UseUTF8InHeader:=True;
  CodVer :=cv200 ;
end;

destructor TBaseNFeWS.Destroy;
begin
  fReqResp.Destroy ;
  inherited;
end;

procedure TBaseNFeWS.DoNFeConsulta;
var
  consSitNFe: TnfeCustomLayout;
  arq: string;
begin

  consSitNFe :=TnfeCustomLayout.NewConsSitNFe(fTpAmb, TNFeConsulta2(Self).chNFe, fVersao);
  try
    fDadosMsg  :=consSitNFe.XML;
    if XMLSave then
    begin
      arq :=Format('%s-ped-sit.xml', [TNFeConsulta2(Self).chNFe]) ;
      consSitNFe.DoSave(XMLPath, arq);
    end;
  finally
    consSitNFe.Free ;
  end;

end;

procedure TBaseNFeWS.DoNFeInutilizacao();
var
  inutNFe: TnfeCustomLayout;
  n: TXmlNode ;
  arq: string;
var
  outXML: String ;
begin

  inutNFe :=TnfeCustomLayout.CreateName('inutNFe', NFE_VER_INUT_NFE);
  try
    n :=inutNFe.NodeNew('infInut')  ;
    n.AttributeAdd('Id'    ,  TnfeInutilizacao2(Self).Id      );
    n.WriteInteger('tpAmb' ,  Ord(fTpAmb)+1                   );
    n.WriteString('xServ'  ,  'INUTILIZAR'                    );
    n.WriteInteger('cUF'   ,  LocalConfigNFe.emit.ufCodigo    );
    n.WriteInteger('ano'   ,  TnfeInutilizacao2(Self).Ano     );
    n.WriteString('CNPJ'   ,  TnfeInutilizacao2(Self).CNPJ    );
    n.WriteInteger('mod'   ,  TnfeInutilizacao2(Self).Modelo  );
    n.WriteInteger('serie' ,  TnfeInutilizacao2(Self).Serie   );
    n.WriteInteger('nNFIni',  TnfeInutilizacao2(Self).NroIni  );
    n.WriteInteger('nNFFin',  TnfeInutilizacao2(Self).NroFin  );
    n.WriteString('xJust'  ,  TnfeInutilizacao2(Self).Justif  );

    fDadosMsg  :=inutNFe.XML;
    if XMLSave then
    begin
      arq :=Format('%s-ped-inut.xml', [TnfeInutilizacao2(Self).Id]) ;
      inutNFe.DoSave(XMLPath, arq);
    end;
  finally
    inutNFe.Free ;
  end;

  if not Tnfeutil.xml_Assinar(fDadosMsg, outXML, fMsg) then
  begin
    fCodStat  :=290 ;
    fMsg  :='Erro de assinatura da mensagem inutilização!'+ LineBreak + fMsg;
  end;

{//    if not Tnfeutil.Valida(retMsg, LayNfeInutilizacao, msg) then
//    begin
//      	raise Exception.Create('Falha na validação dos dados da inutilização!'+ LineBreak + msg);
//    end;
}
end;

procedure TBaseNFeWS.DoNFeRecepcao;
var
//  enviNFe: TnfeCustomLayout ;
  loteInt: Integer ;
  loteStr: TnfeString;
var
  arq: TFileName;
begin

  loteInt :=TNFeRecepcao2(Self).Lote;
  loteStr :=TnfeString.Create('');
//  enviNFe :=TnfeCustomLayout.CreateName('enviNFe', fVersao);
  try
    loteStr.WriteStr('<enviNFe xmlns="%s" versao="%s">',[NFE_PORTALFISCAL_INF_BR, fVersao]);
    loteStr.WriteStr( '<idLote>%d</idLote>',[loteInt]);

//    enviNFe.WriteInt('idLote', loteInt) ;
    //if fVersao >= '3.00' then
    if CodVer >= cv300 then
    begin
      loteStr.WriteStr( '<indSinc>%d</indSinc>',[Ord(TNFeRecepcao2(Self).IndSinc)]);
//      enviNFe.WriteInt('indSinc', Ord(TNFeRecepcao2(Self).IndSinc));
    end;
//    enviNFe.ImportFromStr(fDadosMsg);

    loteStr.WriteStr( fDadosMsg                      );
    loteStr.WriteStr('</enviNFe>'                    );
    fDadosMsg :=Utf8ToAnsi(loteStr.DataString);

//    fDadosMsg :=enviNFe.XML ;
    if XMLSave then
    begin
      arq :=Format('%d-env-lot.xml', [loteInt]);
      loteStr.SaveToFile(arq);
//      enviNFe.DoSave(XMLPath, arq);
    end;
  finally
    loteStr.Free ;
//    enviNFe.Free ;
  end;

end;

procedure TBaseNFeWS.DoNFeRecepcaoEvento;
var
  loteInt: Integer;
  loteStr: TnfeString;
  arq: string ;
begin
  loteInt :=TNFeRecepcaoEvento(Self).Lote;
  loteStr :=TnfeString.Create('');
  try
    loteStr.WriteStr('<envEvento xmlns="%s" versao="%s">',[NFE_PORTALFISCAL_INF_BR, NFE_VER_EVT_CAN]);
    loteStr.WriteStr( '<idLote>%d</idLote>',[loteInt]);
    loteStr.WriteStr( fDadosMsg                      );
    loteStr.WriteStr('</envEvento>'                  );

    if XMLSave then
    begin
      arq :=Format('%d-ped-evt.xml', [loteInt]);
      loteStr.SaveToFile(arq);
    end;
    fDadosMsg :=loteStr.DataString;
  finally
    loteStr.Free ;
  end;
end;

procedure TBaseNFeWS.DoNFeRetRecepcao;
var
  consReci: TnfeCustomLayout;
  arq: string;
begin

  consReci :=TnfeCustomLayout.NewConsReciNFe(fTpAmb, TNFeRetRecepcao2(Self).Recibo, fVersao);
  try
    fDadosMsg  :=consReci.XML;
    if XMLSave then
    begin
      arq :=Format('%s-ped-rec.xml', [TNFeRetRecepcao2(Self).Recibo]);
      consReci.DoSave(XMLPath, arq);
    end;
  finally
    consReci.Free ;
  end;

end;

procedure TBaseNFeWS.DoNFeStatusServico;
var
  consStatServ: TnfeCustomLayout;
  arq: string;
begin

//  consStatServ :=TnfeCustomLayout.NewConsStatServNFe(fTpAmb);
  consStatServ :=TnfeCustomLayout.CreateName('consStatServ', NFE_VER_CONS_STT_SERV);
  try

    consStatServ.WriteInt('tpAmb' , Ord(fTpAmb)+1           );
    consStatServ.WriteStr('xServ'  , 'STATUS'               );
    fDadosMsg  :=consStatServ.XML;

    if XMLSave then
    begin
      arq :=FormatDateTime('yyyymmdd"T"hhnnss', TNFeStatusServico2(Self).dhCons) +'-ped-sta.xml';
      consStatServ.DoSave(XMLPath, arq);
    end;
  finally
    consStatServ.Free ;
  end;

end;

function TBaseNFeWS.Execute: Boolean;
var
  Url   : string;
  ws_name: string;
  ws_method: string;
  ws_resultsep: string;
var
  Text: TnfeString;
  M: TMemoryStream;
  S: TnfeString;

begin
  fCodStat :=0;
  Result :=True;
  ws_method :='';

  fTpAmb :=TnfeAmb(LocalConfigNFe.tpAmb);
  fCodUF :=LocalConfigNFe.emit.ufCodigo;
  if not GetURL(Url) then
  begin
    fMsg :=Format('URL[%s] não disponível para a UF[%d] solicitada!',[Url,fCodUF]);
    Result :=False;
    Exit;
  end;

  if Self is TNFeStatusServico2 then
  begin
    DoNFeStatusServico;
    fVersao :=NFE_VER_CONS_STT_SERV;
    ws_name :=Format('%s/wsdl/NfeStatusServico2',[NFE_PORTALFISCAL_INF_BR]);
    ws_resultsep:='nfeStatusServicoNF2Result';
  end
  else if Self is TNFeRecepcao2 then
  begin
    DoNFeRecepcao ;
    if CodVer >= cv300 then
    begin
      ws_name :=Format('%s/wsdl/NfeAutorizacao', [NFE_PORTALFISCAL_INF_BR]) ;
      ws_method :='/nfeAutorizacaoLote';
      ws_resultsep:='nfeAutorizacaoLoteResult'
    end
    else begin
      ws_name :=Format('%s/wsdl/NfeRecepcao2', [NFE_PORTALFISCAL_INF_BR]);
      ws_resultsep:='nfeRecepcaoLote2Result';
    end;
  end
  else if Self is TNFeRetRecepcao2 then
  begin
    DoNFeRetRecepcao ;
    if CodVer >= cv300 then
    begin
      ws_name :=Format('%s/wsdl/NfeAutorizacao', [NFE_PORTALFISCAL_INF_BR]) ;
      ws_method :='/nfeAutorizacaoLote';
      ws_resultsep:='nfeAutorizacaoLoteResult'
    end
    else begin
      ws_name :=Format('%s/wsdl/NfeRetRecepcao2', [NFE_PORTALFISCAL_INF_BR]);
      ws_resultsep:='nfeRetRecepcao2Result';
    end;
  end
  else if Self is TnfeConsulta2 then
  begin
    fVersao:=NFE_VER_CONS_SIT_NFE;
    DoNFeConsulta;
    ws_name:=Format('%s/wsdl/NfeConsulta2', [NFE_PORTALFISCAL_INF_BR]);
    ws_resultsep:='nfeConsultaNF2Result';
  end
  else if Self is TNFeInutilizacao2 then
  begin
    DoNFeInutilizacao;
    Result :=fCodStat = 0;
    fVersao :=NFE_VER_INUT_NFE;
    ws_name :=Format('%s/wsdl/NfeInutilizacao2',[NFE_PORTALFISCAL_INF_BR]);
    ws_resultsep:='nfeInutilizacaoNF2Result';
  end
  else if Self is TNFeRecepcaoEvento then
  begin
    DoNFeRecepcaoEvento;
    fVersao :=NFE_VER_EVT_CAN;
    ws_name:=Format('%s/wsdl/RecepcaoEvento', [NFE_PORTALFISCAL_INF_BR]);
    ws_resultsep:='nfeRecepcaoEventoResult';
  end;

  if Result then
  begin
  fReqResp.URL :=Url;
  fReqResp.SoapAction :=ws_name + ws_method;

  Text :=TnfeString.Create('<?xml version="1.0" encoding="utf-8"?>' );
  Text.WriteStr('<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ');
  Text.WriteStr('xmlns:xsd="http://www.w3.org/2001/XMLSchema" '     );
  Text.WriteStr('xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">');
  Text.WriteStr(  '<soap12:Header>'                                 );
  Text.WriteStr(    '<nfeCabecMsg xmlns="%s">'        , [ws_name] );
  Text.WriteStr(      '<cUF>%d</cUF>'                 , [fCodUF]);
  Text.WriteStr(      '<versaoDados>%s</versaoDados>' , [fVersao]   );
  Text.WriteStr(    '</nfeCabecMsg>'                                );
  Text.WriteStr(  '</soap12:Header>'                                );
  Text.WriteStr(  '<soap12:Body>'                                   );
  Text.WriteStr(    '<nfeDadosMsg xmlns="%s">'        , [ws_name]);
  Text.WriteStr(      fDadosMsg                                     );
  Text.WriteStr(    '</nfeDadosMsg>'                                );
  Text.WriteStr(  '</soap12:Body>'                                  );
  Text.WriteStr('</soap12:Envelope>'                                );

  try
    M :=TMemoryStream.Create;
    fReqResp.Execute(Text, M);
    S :=TnfeString.Create('');
    try
      S.CopyFrom(M, 0);
      fWS_Result :=Tnfeutil.ParseText(S.DataString, True);
      if PosEx(ws_resultsep, fWS_Result)>0 then
      begin
        fWS_Result :=Tnfeutil.SeparaDados(fWS_Result, ws_resultsep);
        Result :=True;
      end
      else begin
        fMsg :='Separador de mensagem retorno não foi encontrado! Verifique o arquivo "WS_Result.xml".';
        S.SaveToFile('WS_Result.xml');
      end;

    finally
      Text.Free;
      M.Free;
      S.Free;
    end;

  except
    on e:Exception do
    begin
      Result:=False;
      fMsg  :=e.Message;
    end;
  end;
  end;

end;

function TBaseNFeWS.GetURL(out Url: String): Boolean;
begin
  //  (AC,AL,AP,AM,BA,CE,DF,ES,GO,MA,MT,MS,MG,PA,PB,PR,PE,PI,RJ,RN,RS,RO,RR,SC,SP,SE,TO);
  //  (12,27,16,13,29,23,53,32,52,21,51,50,31,15,25,41,26,22,33,24,43,11,14,42,35,28,17);

  //Desativação do ambiente SCAN: até 30/06/2014
  if TnfeEmis(LocalConfigNFe.tpEmi) = emisCon_SCAN then
  begin
    Url :=GetURLSCAN();
  end
  else if TnfeEmis(LocalConfigNFe.tpEmi) in[emisCon_SVCAN, emisCon_SVCRS] then
  begin
    case fCodUF of
      12,27,16,31,25,33,43,11,14,42,28,35,17,53:Url :=GetURL_SVCAN() ;
      13,29,23,32,52,21,51,50,15,26,22,41,24:   Url :=GetURL_SVCRS() ;
    end;
  end
  else begin
    case fCodUF of
      12: Url :=GetURLSVRS(); //AC
      27: Url :=GetURLSVRS(); //AL
      16: Url :=GetURLSVRS(); //AP
//      13: Url :=GetURLAM(); //AM
//      29: Url :=GetURLBA(); //BA
//      23: Url :=GetURLCE(); //CE
//      53: Url :=GetURLDF(); //DF
//      32: Url :=GetURLES(); //ES
//      52: Url :=GetURLGO(); //GO
      21: Url :=GetURLSVAN(); //MA
//      51: Url :=GetURLMT(); //MT
//      50: Url :=GetURLMS(); //MS
//      31: Url :=GetURLMG(); //MG
      15: Url :=GetURLSVAN(); //PA
      25: Url :=GetURLSVRS(); //PB
//      41: Url :=GetURLPR(); //PR
//      26: Url :=GetURLPE(); //PE
      22: Url :=GetURLSVAN(); //PI
      33: Url :=GetURLSVRS(); //RJ
      24: Url :=GetURLSVAN(); //RN
//      43: Url :=GetURLRS(); //RS
//      11: Url :=GetURLRO(); //RO
      14: Url :=GetURLSVRS(); //RR
      42: Url :=GetURLSVRS(); //SC
//      35: FUrl :=GetURLSP(); //SP
      28: Url :=GetURLSVRS(); //SE
      17: Url :=GetURLSVRS(); //TO
    end;
  end;
  Result :=Trim(Url)<>'';
end;

function TBaseNFeWS.GetURLSCAN: String;
begin
  Result :='';
end;

function TBaseNFeWS.GetURLSVAN: String;
begin
  if Self is TNFeStatusServico2 then
  begin
    case fTpAmb of
      ambPro: Result :='https://www.sefazvirtual.fazenda.gov.br/NFeStatusServico2/NFeStatusServico2.asmx';
      ambHom: Result :='https://hom.sefazvirtual.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx';
    end;
  end
  else if Self is TNFeRecepcao2 then
  begin
    case fTpAmb of
      ambPro: if CodVer >= cv300 then
              begin
                Result :='https://nfe.sefazvirtual.rs.gov.br/ws/NfeAutorizacao/NfeAutorizacao.asmx';
              end
              else begin
                Result :='https://www.sefazvirtual.fazenda.gov.br/NfeRecepcao2/NfeRecepcao2.asmx';
              end;
      ambHom: if fVersao >= '3.00' then
              begin
                Result :='https://homologacao.nfe.sefazvirtual.rs.gov.br/ws/NfeAutorizacao/NfeAutorizacao.asmx';
              end
              else begin
                Result :='https://hom.sefazvirtual.fazenda.gov.br/NfeRecepcao2/NfeRecepcao2.asmx';
              end;
    end;
  end
  else if Self is TNFeRetRecepcao2 then
  begin
    case fTpAmb of
      ambPro: if CodVer >= cv300 then
              begin
                Result :='https://nfe.sefazvirtual.rs.gov.br/ws/NfeRetAutorizacao/NfeRetAutorizacao.asmx';
              end
              else begin
                Result :='https://www.sefazvirtual.fazenda.gov.br/NFeRetRecepcao2/NFeRetRecepcao2.asmx';
              end;
      ambHom: if CodVer >= cv300 then
              begin
                Result :='https://homologacao.nfe.sefazvirtual.rs.gov.br/ws/NfeRetAutorizacao/NfeRetAutorizacao.asmx';
              end
              else begin
                Result :='https://hom.sefazvirtual.fazenda.gov.br/NfeRetRecepcao2/NfeRetRecepcao2.asmx';
              end;
    end;
  end
  else if Self is TNFeConsulta2 then
  begin
    case fTpAmb of
      ambPro: if fVersao >= '3.00' then
                Result :='https://nfe.sefazvirtual.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx'
              else
                Result :='https://www.sefazvirtual.fazenda.gov.br/nfeconsulta2/nfeconsulta2.asmx';
      ambHom: if fVersao >= '3.00' then
                Result :='https://homologacao.nfe.sefazvirtual.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx'
              else
                Result :='https://hom.sefazvirtual.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx';
    end;
  end
  else if Self is TNFeInutilizacao2 then
  begin
    case fTpAmb of
      ambPro: Result :='https://www.sefazvirtual.fazenda.gov.br/NFeInutilizacao2/NFeInutilizacao2.asmx';
      ambHom: Result :='https://hom.sefazvirtual.fazenda.gov.br/NfeInutilizacao2/NfeInutilizacao2.asmx';
    end;
  end
  else if Self is TNFeRecepcaoEvento then
  begin
    case fTpAmb of
      ambPro: Result :='https://www.sefazvirtual.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx';
      ambHom: Result :='https://hom.sefazvirtual.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx';
    end;
  end;
end;

function TBaseNFeWS.GetURL_SVCAN: String;
begin
  if Self is TNFeStatusServico2 then
  begin
    case fTpAmb of
      ambPro: Result :='https://www.svc.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx';
      ambHom: Result :='https://hom.svc.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx';
    end;
  end
  else if Self is TNFeRecepcao2 then
  begin
    case fTpAmb of
      ambPro: Result :='https://www.svc.fazenda.gov.br/NfeRecepcao2/NfeRecepcao2.asmx';
      ambHom: Result :='https://hom.svc.fazenda.gov.br/NfeRecepcao2/NfeRecepcao2.asmx';
    end;
  end
  else if Self is TNFeRetRecepcao2 then
  begin
    case fTpAmb of
      ambPro: Result :='https://www.svc.fazenda.gov.br/NfeRetRecepcao2/NfeRetRecepcao2.asmx';
      ambHom: Result :='https://hom.svc.fazenda.gov.br/NfeRetRecepcao2/NfeRetRecepcao2.asmx';
    end;
  end
  else if Self is TNFeConsulta2 then
  begin
    case fTpAmb of
      ambPro: Result :='https://www.svc.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx';
      ambHom: Result :='https://hom.svc.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx';
    end;
  end
  else if Self is TNFeInutilizacao2 then
  begin
    case fTpAmb of
      ambPro: Result :='https://www.svc.fazenda.gov.br/NfeInutilizacao2/NfeInutilizacao2.asmx';
      ambHom: Result :='https://hom.svc.fazenda.gov.br/NfeInutilizacao2/NfeInutilizacao2.asmx';
    end;
  end
  else if Self is TNFeRecepcaoEvento then
  begin
    case fTpAmb of
      ambPro: Result :='https://www.svc.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx';
      ambHom: Result :='https://hom.svc.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx';
    end;
  end;
end;

function TBaseNFeWS.GetURL_SVCRS: String;
begin
  Result :=GetURLSVRS;
end;

function TBaseNFeWS.GetURLSVRS: String;
begin
  if Self is TNFeStatusServico2 then
  begin
    case fTpAmb of
      ambPro: Result :='https://nfe.sefazvirtual.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx';
      ambHom: Result :='https://homologacao.nfe.sefazvirtual.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx';
    end;
  end
  else if Self is TNFeRecepcao2 then
  begin
    case fTpAmb of
      ambPro: Result :='https://nfe.sefazvirtual.rs.gov.br/ws/Nferecepcao/NFeRecepcao2.asmx';
      ambHom: Result :='https://homologacao.nfe.sefazvirtual.rs.gov.br/ws/Nferecepcao/NFeRecepcao2.asmx';
    end;
  end
  else if Self is TNFeRetRecepcao2 then
  begin
    case fTpAmb of
      ambPro: Result :='https://nfe.sefazvirtual.rs.gov.br/ws/NfeRetRecepcao/NfeRetRecepcao2.asmx';
      ambHom: Result :='https://homologacao.nfe.sefazvirtual.rs.gov.br/ws/NfeRetRecepcao/NfeRetRecepcao2.asmx';
    end;
  end
  else if Self is TNFeConsulta2 then
  begin
    case fTpAmb of
      ambPro: Result :='https://nfe.sefazvirtual.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx';
      ambHom: Result :='https://homologacao.nfe.sefazvirtual.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx';
    end;
  end
  else if Self is TNFeInutilizacao2 then
  begin
    case fTpAmb of
      ambPro: Result :='https://nfe.sefazvirtual.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx';
      ambHom: Result :='https://homologacao.nfe.sefazvirtual.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx';
    end;
  end
  else if Self is TNFeRecepcaoEvento then
  begin
    case fTpAmb of
      ambPro: Result :='https://nfe.sefazvirtual.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx';
      ambHom: Result :='https://homologacao.nfe.sefazvirtual.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx';
    end;
  end;
end;

procedure TBaseNFeWS.OnBeforePost(const HTTPReqResp: THTTPReqResp;
  Data: Pointer);
var
  Cert         : ICertificate2;
  CertContext  : ICertContext;
  PCertContext : Pointer;
  ContentHeader: string;
begin
  Cert :=TnfeConfig.GetCertificado; // TnfeConfig.GetCertificado;
  CertContext :=  Cert as ICertContext;
  CertContext.Get_CertContext(Integer(PCertContext));

  { set the certificate to use for the SSL connection }
  if not InternetSetOption(Data
    ,INTERNET_OPTION_CLIENT_CERT_CONTEXT
    ,PCertContext
    ,Sizeof(CERT_CONTEXT)) then
  begin
    raise Exception.CreateFmt('Erro[%d] em TBaseMDFeWS.OnBeforePost',[GetLastError]);
  end;

  ContentHeader :=Format(ContentTypeTemplate, ['application/soap+xml; charset=utf-8']);
  HttpAddRequestHeaders(Data, PChar(ContentHeader), Length(ContentHeader), HTTP_ADDREQ_FLAG_REPLACE);

end;

procedure TBaseNFeWS.SetCodVer(const Value: TnfeCodVer);
begin
  fCodVer :=Value ;
  case fCodVer of
    cv100: fVersao :='1.00' ;
    cv110: fVersao :='1.10' ;
    cv200: fVersao :='2.00' ;
    cv300: fVersao :='3.00' ;
    cv310: fVersao :='3.10' ;
  end;
end;

{ TNFeConsulta2 }

constructor TNFeConsulta2.Create;
begin
  inherited Create ;
  fRetConsSit :=TnfeRetConsSit.Create;
end;

destructor TNFeConsulta2.Destroy;
begin
  fRetConsSit.Destroy ;
  inherited;
end;

function TNFeConsulta2.Execute: Boolean;
var
  arq: string ;
  Last: Integer;
  procEvt: TnfeProcEvento;
begin
  Result :=inherited Execute;
  if not Result then
  begin
    fMsg :='Falha ao consultar pedido de situação da NF-e!'+ LineBreak +fMsg;
    Exit;
  end;

  fRetConsSit.DoLoad(fWS_Result);
  Result   :=fRetConsSit.cStat in[TNFe.COD_AUT_USO_NFE,
                                  TNFe.COD_CAN_HOM_NFE,
                                  TNFe.COD_DEN_USO_NFE];
  fTpAmb   :=fRetConsSit.tpAmb;
  fVerAplic:=fRetConsSit.verAplic;
  fCodStat :=fRetConsSit.cStat;
  fxMotivo :=fRetConsSit.xMotivo;
  fCodUF   :=fRetConsSit.cUF;

  if XMLSave then
  begin
    arq :=Format('%s-sit.xml', [fchNFe]);
    fRetConsSit.DoSave(XMLPath, arq);
  end;

  //
  fMsg :=Format('%d|%s', [fCodStat,fxMotivo])           +LineBreak;
  fMsg :=fMsg + 'Ambiente: '    +IntToStr(Ord(fTpAmb)+1)+LineBreak;
  fMsg :=fMsg + 'Versão Aplic: '+fverAplic              +LineBreak;
  fMsg :=fMsg + 'UF: '          +IntToStr(fCodUF)       +LineBreak;
  fMsg :=fMsg + 'Chave Acesso: '+fchNFe;
  if Result then
  begin
    if fRetConsSit.cStat = TNFe.COD_AUT_USO_NFE then
    begin
      fMsg :=fMsg + LineBreak +'Nr Protocolo  : '+fRetConsSit.protNFe.nProt;
      fMsg :=fMsg + LineBreak +'Dt Recebimento: '+DateTimeToStr(fRetConsSit.protNFe.dhRecbto);
    end
    else if fRetConsSit.cStat = TNFe.COD_CAN_HOM_NFE then
    begin
      if fRetConsSit.fProcEventoNFeList.Count -1 < 0 then
        Last :=0
      else
        Last :=fRetConsSit.fProcEventoNFeList.Count -1;
      procEvt :=fRetConsSit.procEventoNFeList.Items[Last];
      if procEvt <> nil then
      begin
        fMsg :=fMsg + LineBreak +'Dt Registro : ' +DateTimeToStr(procEvt.retEvento.dhRegEvento);
        fMsg :=fMsg + LineBreak +'Nr Protocolo: ' +procEvt.retEvento.nProt;
      end;
    end;
  end;

end;

{ TnfeRetConsSit }

constructor TnfeRetConsSit.Create;
begin
  inherited Create('', True);
  fProtNFe :=TnfeInfProt.Create;
  fProcEventoNFeList :=TnfeProcEventoList.Create;
end;

destructor TnfeRetConsSit.Destroy;
begin
  fProtNFe.Destroy ;
  fProcEventoNFeList.Destroy;
  inherited;
end;

procedure TnfeRetConsSit.DoLoad(ARetConsSit: UTF8String);
var
  R: TsdElement;
  N: TXmlNode ;
  I: Integer ;
  procEvento: TnfeProcEvento ;
begin
  inherited DoLoad(ARetConsSit);

  R     :=docXML.Root;
  fchNFe:=R.ReadString('chNFe');
  N     :=R.NodeByName('protNFe');
  if N <> nil then
  begin
    N     :=N.NodeByName('infProt');
    case N.ReadInteger('tpAmb') of
      1: fProtNFe.tpAmp :=ambPro;
      2: fProtNFe.tpAmp :=ambHom;
    end;
    fProtNFe.verAplic :=N.ReadString('verAplic');
    fProtNFe.chNFe    :=N.ReadString('chNFe');
    fProtNFe.dhRecbto :=N.ReadDateTime('dhRecbto');
    fProtNFe.nProt    :=N.ReadString('nProt');
    fProtNFe.digVal   :=N.ReadString('digVal');
    fProtNFe.cStat    :=N.ReadInteger('cStat');
    fProtNFe.xMotivo  :=N.ReadString('xMotivo');
  end;
  for I :=0 to docXML.Root.NodeCount -1 do
  begin
    if R.Nodes[I].NodeByName('evento')<>nil then
    begin
      procEvento :=fProcEventoNFeList.AddNew;
      procEvento.versao :=R.Nodes[I].ReadAttributeString('versao') ;

      //evento
      N :=R.Nodes[I].NodeByName('evento');
      N :=N.NodeByName('infEvento');
      procEvento.evento.infEvento.cOrgao:=N.ReadInteger('cOrgao');
      if N.ReadInteger('tpAmb')=1 then  procEvento.evento.infEvento.tpAmb :=ambPro
      else                              procEvento.evento.infEvento.tpAmb :=ambHom;
      procEvento.evento.infEvento.CNPJ  :=N.ReadString('CNPJ');
      procEvento.evento.infEvento.chNFe :=N.ReadString('chNFe');
      procEvento.evento.infEvento.dhEvento:=N.ReadDateTime('dhEvento');
      procEvento.evento.infEvento.tpEvento:=N.ReadInteger('tpEvento');
      procEvento.evento.infEvento.nSeqEvento:=N.ReadInteger('nSeqEvento');
      //detEvento
      N :=N.NodeByName('detEvento');
      procEvento.evento.infEvento.detEvento.versao :=N.ReadString('versao');
      procEvento.evento.infEvento.detEvento.descEvento :=N.ReadString('descEvento');
      procEvento.evento.infEvento.detEvento.nProt :=N.ReadString('nProt');
      procEvento.evento.infEvento.detEvento.xJust :=N.ReadString('xJust');
      procEvento.evento.xml :=N.Parent.WriteToString;

      //retEvento
      N :=R.Nodes[I].NodeByName('retEvento');
      N :=N.NodeByName('infEvento');
      if N.ReadInteger('tpAmb')=1 then  procEvento.retEvento.tpAmb :=ambPro
      else                              procEvento.retEvento.tpAmb :=ambHom;
      procEvento.retEvento.verAplic :=N.ReadString('verAplic');
      procEvento.retEvento.cOrgao   :=N.ReadInteger('cOrgao');
      procEvento.retEvento.cStat    :=N.ReadInteger('cStat');
      procEvento.retEvento.xMotivo  :=N.ReadString('xMotivo');
      procEvento.retEvento.chNFe    :=N.ReadString('chNFe');
      procEvento.retEvento.emailDest:=N.ReadString('emailDest');
      procEvento.retEvento.dhRegEvento:=N.ReadDateTime('dhRegEvento');
      procEvento.retEvento.nProt    :=N.ReadString('nProt');
      procEvento.retEvento.xml :=N.Parent.WriteToString;
    end;
  end;
end;

{ TnfeProcEvento }

constructor TnfeProcEvento.Create;
begin
  evento    :=TEvento.Create ;
  retEvento :=TRetEvento.Create;
end;

destructor TnfeProcEvento.Destroy;
begin
  evento.Destroy;
  retEvento.Destroy ;
  inherited;
end;

{ TnfeProcEventoList }

function TnfeProcEventoList.AddNew: TnfeProcEvento;
begin
  Result :=TnfeProcEvento.Create ;
  Result.owner :=Self;
  inherited Add(Result) ;
end;

function TnfeProcEventoList.Get(Index: Integer): TnfeProcEvento;
begin
  Result :=TnfeProcEvento(inherited Items[Index]) ;
end;

function TnfeProcEventoList.GetLast: TnfeProcEvento;
var
  C: Integer ;
begin
  Result :=nil ;
  if Self.Count > 0 then
  begin
    C :=0;
    if Self.Count > 1 then
    begin
      C :=Self.Count -1 ;
    end;
    Result :=Self.Items[C] ;
  end;
end;

{ TNFeRecepcaoEvento }

constructor TNFeRecepcaoEvento.Create(ATpEvento: Integer);
begin
  inherited Create;
  tpEvento  :=ATpEvento ;
  fRetEnvEvento :=TRetEnvEvento.Create ;
end;

destructor TNFeRecepcaoEvento.Destroy;
begin
  fRetEnvEvento.Destroy ;
  inherited;
end;

function TNFeRecepcaoEvento.Execute: Boolean;
var
  arq: string;
begin
  Result :=inherited Execute;
  if not Result then
  begin
    case tpEvento of
      TnfeEvento.EVT_TYP_CCE: fMsg :='Falha ao enviar pedido registro de evento CC-e!'+ LineBreak +fMsg;
      TnfeEvento.EVT_TYP_CAN: fMsg :='Falha ao enviar pedido registro de evento Cancelamento!'+ LineBreak +fMsg;
    end;
    Exit;
  end;

  fRetEnvEvento.DoLoad(fWS_Result);
  fTpAmb    :=fRetEnvEvento.tpAmb;
  fVerAplic :=fRetEnvEvento.verAplic;
  fcOrgao   :=fRetEnvEvento.cOrgao;
  fCodStat  :=fRetEnvEvento.cStat;
  fxMotivo  :=fRetEnvEvento.xMotivo;

  //
  Result    :=fCodStat = TnfeEvento.COD_PROCESS_LOTE;

  //
  fMsg :=Format('%d|%s', [fCodStat,fxMotivo])           +LineBreak;
  fMsg :=fMsg + 'Ambiente: '    +IntToStr(Ord(fTpAmb)+1)+LineBreak;
  fMsg :=fMsg + 'Versão Aplic: '+fverAplic              +LineBreak;
  fMsg :=fMsg + 'Código Orgão: '+IntToStr(fcOrgao)      +LineBreak;
  fMsg :=fMsg + 'Chave Acesso: '+fchNFe;
  if fRetEnvEvento.retEvento.cStat =TnfeEvento.COD_EVT_VINC_NFE  then
  begin
    fMsg :=fMsg + LineBreak +Format('%d|%s', [fRetEnvEvento.retEvento.cStat,fRetEnvEvento.retEvento.xMotivo]);
    fMsg :=fMsg + LineBreak +'Dt Registro : ' +DateTimeToStr(fRetEnvEvento.retEvento.dhRegEvento);
    fMsg :=fMsg + LineBreak +'Nr Protocolo: ' +fRetEnvEvento.retEvento.nProt;
  end;

  if XMLSave then
  begin
    arq :=Format('%d-evt.xml', [fLote]);
    fRetEnvEvento.DoSave(XMLPath, arq);
  end;

end;

{ TRetEnvEvento }

constructor TRetEnvEvento.Create;
begin
  inherited Create();
  fRetEvento :=TRetEvento.Create;
end;

destructor TRetEnvEvento.Destroy;
begin
  fRetEvento.Destroy ;
  inherited;
end;

procedure TRetEnvEvento.DoLoad(ARetEvento: UTF8String);
var
  N: TXmlNode ;
begin
  inherited DoLoad(ARetEvento);
  N   :=docXML.Root ;
  fcOrgao :=N.ReadInteger('cOrgao') ;
  N       :=N.NodeByName('retEvento');
  if N<>nil then
  begin
    N  :=N.NodeByName('infEvento');
    if N.ReadInteger('tpAmb')=1 then  retEvento.tpAmb :=ambPro
    else                              retEvento.tpAmb :=ambHom;
    retEvento.verAplic :=N.ReadString('verAplic');
    retEvento.cOrgao   :=N.ReadInteger('cOrgao');
    retEvento.cStat    :=N.ReadInteger('cStat');
    retEvento.xMotivo  :=N.ReadString('xMotivo');
    retEvento.chNFe    :=N.ReadString('chNFe');
    retEvento.emailDest:=N.ReadString('emailDest');
    retEvento.dhRegEvento:=N.ReadDateTime('dhRegEvento');
    retEvento.nProt    :=N.ReadString('nProt');
  end;
end;


{ TNFeStatusServico2 }

function TNFeStatusServico2.Execute: Boolean;
var
  retConsStatServ: TnfeCustomLayout;
  arq: string ;
begin
  dhCons :=Now;
  Result :=inherited Execute;
  if not Result then
  begin
    fMsg :='Falha ao consultar status do serviço!'+ LineBreak +fMsg;
    Exit;
  end;

  retConsStatServ :=TnfeCustomLayout.Create(fWS_Result);
  try
    Result :=retConsStatServ.cStat = TNFe.COD_SERV_OPER;
    fTpAmb    :=retConsStatServ.tpAmb;
    fVerAplic  :=retConsStatServ.verAplic;
    fCodStat   :=retConsStatServ.cStat;
    fxMotivo   :=retConsStatServ.xMotivo;
    fCodUF     :=retConsStatServ.cUF;
    fdhRecbto  :=retConsStatServ.docXML.Root.ReadDateTime('dhRecbto');
    fTMed      :=retConsStatServ.docXML.Root.ReadInteger('TMed');
    fdhRetorno :=retConsStatServ.docXML.Root.ReadDateTime('dhRetorno');
    fxObs      :=retConsStatServ.docXML.Root.ReadString('xObs');
    if XMLSave then
    begin
      arq :=FormatDateTime('yyyymmdd"T"hhnnss', dhCons) +'-sta.xml';
      retConsStatServ.DoSave(XMLPath, arq);
    end;
  finally
    retConsStatServ.Free ;
  end;
  //
  fMsg :=Format('%d|%s', [fCodStat,fxMotivo])          +LineBreak;
  fMsg :=fMsg + 'Ambiente: '    +StrUtils.IfThen(fTpAmb=ambPro,'Produção','Homologação')+LineBreak;
  fMsg :=fMsg + 'Versão Aplic: '+fverAplic             +LineBreak;
  fMsg :=fMsg + 'UF: '          +IntToStr(fCodUF)      +LineBreak;
  fMsg :=fMsg + 'Recebimento: ' +StrUtils.IfThen(fdhRecbto=0, '', DateTimeToStr(fdhRecbto));
  if Result then
  begin
    fMsg :=fMsg + LineBreak +'Tempo Médio: '+IntToStr(fTMed);
    if fdhRetorno > 0 then fMsg :=fMsg + LineBreak +'Retorno: '+DateTimeToStr(fdhRetorno);
    if fxObs<>''      then fMsg :=fMsg + LineBreak +'Observação: ' +fxObs;
  end;
end;

{ TNFeRecepcao2 }

constructor TNFeRecepcao2.Create;
begin
  inherited Create();
  fProtNFe :=TnfeInfProt.Create ;
end;

destructor TNFeRecepcao2.Destroy;
begin
  fProtNFe.Destroy;
  inherited;
end;

function TNFeRecepcao2.Execute: Boolean;
var
  retEnviNFe: TnfeCustomLayout;
  N:TXmlNode ;
  arq: string ;
begin
  Result :=inherited Execute ;
  if not Result then
  begin
    fMsg :='Falha ao enviar lote!'+ LineBreak +fMsg;
    Exit;
  end;

  retEnviNFe :=TnfeCustomLayout.Create(fWS_Result);
  try
    fTpAmb    :=retEnviNFe.tpAmb;
    fVerAplic  :=retEnviNFe.verAplic;
    fCodStat   :=retEnviNFe.cStat;
    fxMotivo   :=retEnviNFe.xMotivo;
    fCodUF     :=retEnviNFe.cUF;

    fMsg :=Format('%d|%s', [fCodStat, fxMotivo]) +LineBreak;

    //n :=retEnviNFe.docXML.Root.NodeByName('infRec');
    N :=retEnviNFe.NodeByNameOrTree('/retEnviNFe/infRec') ;
    if N <> nil then
    begin
      FRecibo   :=N.ReadString('nRec') ;
      fdhRecbto :=N.ReadDateTime('dhRecbto');
      FTMed     :=N.ReadInteger('tMed');
    end
    else begin
      //n :=retEnviNFe.docXML.Root.FindNode('infProt');
      n :=retEnviNFe.NodeByNameOrTree('/retEnviNFe/protNFe/infProt');
      if n <> nil then
      begin
        case n.ReadInteger('tpAmb') of
          1: fProtNFe.tpAmp :=ambPro;
          2: fProtNFe.tpAmp :=ambHom;
        end;
        fProtNFe.verAplic :=n.ReadString('verAplic');
        fProtNFe.chNFe    :=n.ReadString('chNFe');
        fProtNFe.dhRecbto :=n.ReadDateTime('dhRecbto');
        fProtNFe.nProt    :=n.ReadString('nProt');
        fProtNFe.digVal   :=n.ReadString('digVal');
        fProtNFe.cStat    :=n.ReadInteger('cStat');
        fProtNFe.xMotivo  :=n.ReadString('xMotivo');
        fMsg :=Format('%d|%s', [fProtNFe.cStat, fProtNFe.xMotivo]) +LineBreak;
      end;
    end;

    if Self.XMLSave then
    begin
      if Self.IndSinc then
      begin
        arq :=Format('%d-ret-lot.xml', [FLote]);
      end
      else begin
        if retEnviNFe.cStat = TNFe.COD_LOT_REC_SUCESS then
          arq :=Format('%s-rec.xml', [FRecibo])
        else
          arq :='000000000000000-rec.xml';
      end;
      retEnviNFe.DoSave(XMLPath, arq);
    end;
  finally
    retEnviNFe.Free ;
  end;
  //

  fMsg :=fMsg + 'Ambiente: '    +IntToStr(Ord(fTpAmb))+LineBreak;
  fMsg :=fMsg + 'Versão Aplic: '+fverAplic            +LineBreak;
  fMsg :=fMsg + 'UF: '          +IntToStr(fCodUF);
  if Self.IndSinc then
  begin
    if fCodStat = TNFe.COD_AUT_USO_NFE then
    begin
      fMsg :=fMsg + LineBreak +'Protocolo: ' +fProtNFe.nProt;
      fMsg :=fMsg + LineBreak +'Autorização: ' +DateTimeToStr(fProtNFe.dhRecbto);
      fMsg :=fMsg + LineBreak +'Status: '+Format('%d|%s', [fProtNFe.cStat,fProtNFe.xMotivo]);
    end;
  end
  else begin
    fMsg :=fMsg + LineBreak +'Número Recibo: ' +FRecibo;
    fMsg :=fMsg + LineBreak +'Recebimento: ' +DateTimeToStr(fdhRecbto);
    fMsg :=fMsg + LineBreak +'Tempo Médio: '+IntToStr(FTMed);
  end;

end;

{ TNFeRetRecepcao2 }

constructor TNFeRetRecepcao2.Create;
begin
  inherited Create ;
  fRetConsReciNFe :=TretConsReciNFe.Create ;
end;

destructor TNFeRetRecepcao2.Destroy;
begin
  fRetConsReciNFe.Destroy ;
  inherited;
end;

function TNFeRetRecepcao2.Execute: Boolean;
var
  retConsReci: TnfeCustomLayout ;
	r,p:TXmlNode;

  count:Integer;
  I:Integer;
  np:TXmlNode;
  infProt:TinfProt;
  chnfe:string;
var
  arq: string ;

begin

  Result :=inherited Execute;
  if not Result then
  begin
    count :=1;
    while not Result do
    begin
      Sleep(4000);
      Result :=inherited Execute;
      if count > 3 then
      begin
        Break;
      end;
      count := count +1;
    end;
  end;

  if not Result then
  begin
    fMsg :='Falha ao consultar o resultado do processamento do lote!'+ LineBreak +fMsg;
    Exit;
  end;

  retConsReci :=TnfeCustomLayout.Create(fWS_Result) ;
  try
//    retConsReci.DoLoad(fWS_Result);
//    fdhRecbto :=retConsReci.ReadDateTime('dhRecbto');

    fTpAmb   :=retConsReci.ftpAmb;
    fVerAplic :=retConsReci.verAplic;
    fCodStat :=retConsReci.cStat;
    fxMotivo :=retConsReci.xMotivo;
    fCodUF :=retConsReci.cUF;

    fMsg :=Format('%d|%s', [fCodStat, fxMotivo]) +LineBreak;

    Result  :=retConsReci.cStat = TNFe.COD_LOT_PROCESS;
    if Result then
    begin

      r :=retConsReci.docXML.Root;
      for I :=0 to r.NodeCount -1 do
      begin
         p :=r.Nodes[I].NodeByName('infProt');
         if p<>nil then
         begin
           chnfe:=p.ReadString('chNFe');
           infProt  :=retConsReciNFe.IndexOfKey(chnfe);
           if infProt = nil then
           begin
              infProt         :=retConsReciNFe.CreateNew;
              infProt.tpAmp   :=Tnfeutil.SeSenao(p.ReadInteger('tpAmp')=1,ambPro,ambHom);
              infProt.verAplic:=p.ReadString('verAplic');
              infProt.chNFe   :=chnfe;
              infProt.dhRecbto:=p.ReadDateTime('dhRecbto');
              infProt.nProt   :=p.ReadString('nProt');
              infProt.digVal  :=p.ReadString('digVal');
              infProt.cStat   :=p.ReadInteger('cStat');
              infProt.xMotivo :=p.ReadString('xMotivo');
           end;
         end;
      end;

    end;

    if Self.XMLSave then
    begin
      arq :=Format('%s-pro-rec.xml', [fRecibo]) ;
      retConsReci.DoSave(XMLPath, arq);
    end;

  finally
    retConsReci.Free ;
  end;

  //
  fMsg :=fMsg + 'Ambiente: '    +IntToStr(Ord(fTpAmb))+LineBreak;
  fMsg :=fMsg + 'Versão Aplic: '+fverAplic            +LineBreak;
  fMsg :=fMsg + 'UF: '          +IntToStr(fCodUF);

  if Result then
  begin
    fMsg :=fMsg + LineBreak +'Número Recibo: ' +FRecibo;
    fMsg :=fMsg + LineBreak +'Processamento: ' +DateTimeToStr(fdhRecbto);
  end;

end;


{ TNFeInutilizacao2 }

function TNFeInutilizacao2.Execute: Boolean;
var
  retInutNfe: TnfeCustomLayout;
  arq: string ;
begin

  Result :=inherited Execute;
  if not Result then
  begin
    fMsg :='Falha ao inutilizar faixa de numeração!'+ LineBreak +fMsg;
    Exit;
  end;

  retInutNfe :=TnfeCustomLayout.Create(fWS_Result);
  try
    Result    :=retInutNfe.cStat = TNFe.COD_INU_HOM_NFE;
    fTpAmb    :=retInutNfe.tpAmb;
    fVerAplic :=retInutNfe.verAplic;
    fCodStat  :=retInutNfe.cStat;
    fxMotivo  :=retInutNfe.xMotivo;
    fCodUF    :=retInutNfe.cUF;
    fdhRecbto :=retInutNfe.docXML.Root.ReadDateTime('dhRecbto');

    if Result then
    begin
      FNProt :=retInutNfe.docXML.Root.ReadString('nProt');
    end;

    if XMLSave then
    begin
      arq :=Format('%s-ret-inut.xml', [Self.Id]) ;
      retInutNfe.DoSave(XMLPath, arq);
    end;
  finally
    retInutNfe.Free ;
  end;
  //
  fMsg :=Format('%d|%s', [fCodStat,fxMotivo])          +LineBreak;
  fMsg :=fMsg + 'Ambiente: '    +StrUtils.IfThen(fTpAmb=ambPro,'Produção','Homologação')+LineBreak;
  fMsg :=fMsg + 'Versão Aplic: '+fverAplic             +LineBreak;
  fMsg :=fMsg + 'UF: '          +IntToStr(fCodUF)      +LineBreak;
  fMsg :=fMsg + 'Recebimento: ' +StrUtils.IfThen(fdhRecbto=0, '', DateTimeToStr(fdhRecbto));
  if Result then
  begin
    fMsg :=fMsg + LineBreak +'Protocolo: '+Self.NroProt;
  end;
end;

function TNFeInutilizacao2.GetId: string;
begin
    Result  :='ID';
    Result  :=Result  +IntToStr(LocalConfigNFe.emit.ufCodigo);
    Result  :=Result  +FormatDateTime('YY', FAno);
    Result  :=Result  +FCNPJ;
    Result  :=Result  +Tnfeutil.FInt(FModelo, 2 );
    Result  :=Result  +Tnfeutil.FInt(FSerie , 3 );
    Result  :=Result  +Tnfeutil.FInt(FNroIni, 9 );
    Result  :=Result  +Tnfeutil.FInt(FNroFin, 9 );
end;

procedure TNFeInutilizacao2.SetJust(const AValue: string);
begin
    if Tnfeutil.IsEmpty(AValue) then
    begin
        raise Exception.Create('Informe a justificativa para inutilização!');
    end;

    if Length(AValue) < 15 then
    begin
        raise Exception.Create('A Justificativa para inutilização da NF-e deve ter no minimo 15 caracteres!');
    end ;

    FJust	:= Tnfeutil.TrataString(AValue);
end;

end.
