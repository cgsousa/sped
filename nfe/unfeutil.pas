unit unfeutil;

interface

{$REGION 'uses'}
uses
  Classes   ,
  SysUtils  ,
  ComObj    ,
  WinInet		,
  ucapicom  ,
  umsxml    ,
  NativeXml, sdStreams,

  // sendmail
 	IdBaseComponent, IdComponent,
  IdMessage, IdMessageClient, IdText,
  IdAntiFreezeBase, IdAntiFreeze,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase,
  IdSMTPBase, IdSMTP,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack,
  IdSSL, IdSSLOpenSSL,
  IdPOP3,
  IdAttachmentFile,
  IdException, IdReplySMTP ;

{$ENDREGION}

{$i simdesign.inc}

{$REGION 'TnfeConfig'}
type
  TnfeConfigEmit = record
    codigo: Integer ;
    rzSoci: string	;
    CNPJ: string ;
    IE: string ;
    ufCodigo: Integer;
    ufSigla : string;
    logo		: string;
    IdToken: string ;
    consNFCe: string;
  end;
  TnfeConfigCert = record
  public
    SerialNumber: WideString;
    SubjectName: WideString;
    ValidFromDate: TDateTime;
    ValidToDate: TDateTime;
  end;
  TnfeConfigConting = record
    DataHora: TDateTime	;
    Justifica: string	;
  end;
  TnfeConfigDANFe = record
    saida: Byte;
    copias: Byte ;
    local: string;
    printer: string;
    msg_cf: Boolean;
    msg_clsfis: Boolean;
    sendmail: Boolean;
  end;

  TmdfeConfig = record
  public
    tpAmb : Byte ;
    tpEmit: Byte ;
    tpEmis: Byte ;
    sermdf: Word;
    localmdfe: string ;
    localschema: string;
    saveXML: Boolean;
    procedure Create();
  end;

  TnfeConfigNFCe = record
  public
    tpAmb      :Byte ;
    tpEmi      :Byte ;
    dhCont: TDateTime;
    xCont: string ;
    IdToken: string ;
    localschema: string;
    saveXML: Boolean;
    useNFCe: Boolean;
  end;

  TnfeConfig = class(TNativeXml)
  protected
    class var fInstance: TnfeConfig;
    class function getFileName: string;
    class procedure DoLoad();
  public
    tpAmb      :Byte ;
    tpEmi      :Byte ;
    incCadBai   :Boolean;
    lotePorCarga:Boolean;
    emit: TnfeConfigEmit;
    cert: TnfeConfigCert;
    danfe: TnfeConfigDANFe;
    conting:TnfeConfigConting;
    localnfe: string ;
    localschema: string;
    emisNFe: Boolean ;
    saveXML: Boolean ;
    ProcessSinc: Boolean;
    MDFe: TmdfeConfig ;
    NFCe: TnfeConfigNFCe ;
    class function getInstance(): TnfeConfig;
    class procedure freeInstance();
    class procedure DoSave();
    class function SelCertificado: Boolean;
    class function GetCertificado: ICertificate2;
  end;

{$ENDREGION}

{$REGION 'nfe-utils.types'}
type
  Tsmtp_mail_send_file=record
      filename:string;
    end;

  Tsmtp_mail_send_structure=record
        smtp_host:string;//servidor smtp
        smtp_port:Integer;// porta de saida
        smtp_mail:string;//conta que envia o e-mail
        smtp_user:string;//usuário autenticacao
        smtp_pass:string;//senha da conta
        smtp_helo:string;//Helo name

        mail_name:string;//em nome de

        mail_dest:string;//destino
        mail_subj:string;//assunto

        mail_file:array of Tsmtp_mail_send_file;//arquivos
        mail_text:string;//corpo da mensagem
     end;

type
  //TnfeString = class (TStringStream)
  TnfeString = class (TsdStringStream)
  public
    procedure WriteStr(const S: string); overload ;
    procedure WriteStr(const S: string; Args: array of const); overload ;
  end;

type
  TnfeSigner = (sgnNFe, sgnCanc, sgnInut);
  TLayOut = (	LayNfe,
  						LayNfeRecepcao,
              LayNfeRetRecepcao,
              LayNfeCancelamento,
              LayNfeInutilizacao,
              LayNfeConsulta,
              LayNfeStatusServico,
              LayNfeCadastro,
              LayNfeProc	,
              LayCleCadastro ,
              LayRecepcaoEvento
              );
type
  TmailTypMIME =(mttextplain  ,
                 mttexthtml   ,
                 mttextrtf    ,
                 mttextxaiff  ,
                 mtaudiobasic ,
                 mtaudiowav   ,
                 mtimagegif   ,
                 mtimagejpeg  ,
                 mtimagepjpeg ,
                 mtimagetiff  ,
                 mtimagexpng  ,
                 mtimagexxbmp ,
                 mtimagebmp   ,
                 mtimagexjg   ,
                 mtimagexemf  ,
                 mtimagexwmf  ,
                 mtvideoavi   ,
                 mtvideompeg  ,
                 mtapppostscript,
                 mtappbase64 ,
                 mtappmacbinhex40,
                 mtapppdf  ,
                 mtappxcompress,
                 mtappxzipcompress,
                 mtappxgzipcompress,
                 mtappjava  ,
                 mtappxmsdownload,
                 mtappoctetstream,
                 mtmultipartmixed,
                 mtmultipartrelative,
                 mtmultipartdigest,
                 mtmultipartalternative,
                 mtmultipartrelated,
                 mtmultipartreport,
                 mtmultipartsigned,
                 mtmultipartencrypted);

{$ENDREGION}

{$REGION 'Tsmtp_access'}
type
  Tsmtp_access = class
  private
    type	Tmail_send_file=record
          public
            filename: string;
            typmime: TmailTypMIME
          end;
    type	Tmail_files = array of Tmail_send_file	;
  private
    fIdAntiFreeze:TIdAntiFreeze;
    fIdSMTP:TIdSMTP;
    fIdSSLIOHandlerSocketOpenSSL:TIdSSLIOHandlerSocketOpenSSL;
  private
    fsmtp_host:string;	//servidor smtp
    fsmtp_port:Integer;	//porta de saida
    fsmtp_mail:string;	//conta que envia o e-mail
    fsmtp_user:string;	//usuário autenticacao
    fsmtp_pass:string;	//senha da conta
    fsmtp_helo:string;	//Helo name

    fmail_name:string;	//em nome de
    fmail_dest:string;	//destino
    fmail_subj:string;	//assunto
    //fmail_file:Tmail_files; arquivos
    fmail_text:string;	//corpo da mensagem

    fConnected: Boolean;
    fErrorMsg: string	;

  public
    mail_files:array of Tmail_send_file	;
    constructor Create	(	const hostname: string;
                          const hostport: Word;
                          const usermail: string	;
                          const username, userpass: string ;
                          const SupportsTLS: Boolean=True);
    destructor Destroy ; override ;
    function Send(const mail_typmime: TmailTypMIME): Boolean  ;

    property smtp_helo:string 			read fsmtp_helo write fsmtp_helo	;
    property mail_name:string 			read fmail_name write fmail_name	;
    property mail_dest:string				read fmail_dest write fmail_dest	;
    property mail_subj:string				read fmail_subj write fmail_subj	;
    property mail_text:string 			read fmail_text write fmail_text	;
    property Connected: Boolean 		read fConnected ;
    property ErrorMsg: string 			read fErrorMsg 	;
  end;

{$ENDREGION}

{$REGION 'Tftp_access'}
type
  Tftp_access = class
  const	BlockSize = 1024;
  type TprogressProc = procedure(Afile: string; Done, Total: Cardinal; var Abort: Boolean) of object;
  private
    fSession: HINTERNET;
    fConnect: HINTERNET;
    fHostName: string;
    fHostPort: Word;
    fUserName: string;
    fPassWord: string;
    fConnected: Boolean;
  public
    constructor Create	(	const AHostName: string;
                          const AHostPort: Word;
                          const AUserName, APassWord: string);
    destructor Destroy ; override ;
    function GetDir: string	;
    function SetDir(const WebDir: string): Boolean	;
    function GetFile(const WebName: string): string;
    function PutFile(const Source, RemoteName: string): Boolean;
    function FileSize(const WebName: string): Integer;
    function DeleteFile(const WebName: string): Boolean;
    property Connected: Boolean read fConnected write fConnected	;
  end;

{$ENDREGION}

{$REGION 'Tnfeutil'}
type
  TnfeLog = class
  private
    fBuffer:TextFile;
    function file_name_log: string;
  public
    procedure WText(const AText: string); overload;
    procedure WText(const AText: string; const Args: array of const); overload;
    constructor Create;
    destructor Destroy; override;
  end;

  TDatePart = (dpDateTime, dpDate, dpTime);
  Tnfeutil = class
  private
    { certificado }
    class var CertStore   : IStore3;
    class var CertStoreMem: IStore3;
    class var PrivateKey  : IPrivateKey;
    class var Certs       : ICertificates2;
    class var Cert        : ICertificate2;
    class var CertSerialMm: WideString;
    class function SelCertificado: Boolean;
    class function GetCertificado: ICertificate2;
  public
    class function PosEx(const SubStr, S: AnsiString; Offset: Cardinal = 1): Integer;
    class function PosLast(const SubStr, S: AnsiString ): Integer;

    class function PadE(const AStr: string; const ALen : Integer; const AChar : Char = ' '): String;
    class function PadC(const AStr: string; const ALen : Integer; const AChar : Char = ' '): String;
    class function PadD(const AStr: string; const ALen : Integer; const AChar : Char = ' '): String;

    class function SeSenao(const ACondicao: Boolean; ATrue, AFalse: Variant): Variant;
    class function Se(const ACondicao: Boolean; const ATrue, AFalse: Integer): Integer;

    class function Mod11(Valor: string): Byte;

    class function LasString(AString: String): String;

    class function IsEmpty(const AValue: String		): Boolean; overload;
    class function IsEmpty(const AValue: Integer	): Boolean; overload;
    class function IsEmpty(const AValue: Integer; const AMsg: string): Boolean; overload;
    class function IsEmpty(const AValue: Extended	): Boolean; overload;
    class function IsEmpty(const AValue: TDateTime): Boolean; overload;

    class function LimpaNumero(const AValue: String; const AIsZero: Boolean=True): String;
    class function TrataString(const AValue: String): String;overload;
    class function TrataString(const AValue: String; const ATamanho: Integer): String;overload;

    class function CortaD(const AString: string; const ATamanho: Integer): String;
    class function CortaE(const AString: string; const ATamanho: Integer): String;

    class function TamanhoIgual(const AValue: String; const ATamanho: Integer): Boolean; overload;
    class procedure TamanhoIgual(const AValue: String; const ATamanho: Integer; AMensagem: String);overload;
    class function TamanhoIgual(const AValue: Integer; const ATamanho: Integer): Boolean;overload;
    class procedure TamanhoIgual(const AValue: Integer; const ATamanho: Integer; AMensagem: String);overload;
    class function TamanhoMenor(const AValue: String; const ATamanho: Integer): Boolean;

    class function Assinar(AXML: String; ACert: ICertificate2; out AOutXML, AOutMsg: String): Boolean;

    class function ValidaCodMun(const CodMun: Integer): Boolean; overload;
    class function ValidaCodMun(const UF: string; const CodMun: Integer): Boolean; overload;
    class function ValidaCEP(const UF, CEP: string): Boolean;
    class function ValidaPlaca(const InPlaca: string; out OuPlaca: string): Boolean;

//    class function xml_Assinar(const Axml: String; ACert: ICertificate2; out AOutXML, AOutMsg: String): Boolean;
    class function xml_Assinar(const AXml: string; out AOutXML, ARetMsg: string): Boolean;
    class function xml_Validar(const Axml, ANameSpace, ASchema: string; out ARetMsg: string): Boolean;

    class function StringToFloat(AValue : String ) : Double ;
    class function StringToFloatDef(const AValue: String; const DefaultValue: Double): Double;
    class procedure ConfAmbiente;
    class function PathApp: String;
    class function ParseText(Texto : AnsiString; Decode : Boolean ) : AnsiString;
    class function SeparaDados(Texto : AnsiString; Chave : String; MantemChave : Boolean = False ) : AnsiString;

    class function SendMail(AStru: Tsmtp_mail_send_structure; out AOut: string): Boolean;

    class function GetUF(const Sigla: string): Byte; overload;
    class function GetUF(const Codigo: Byte): string; overload;

    class function GetNumbers(const Value: string; const Count: Integer=0): string;

    class function RemoveCtrlChar(const AValue: string): string;

    class function AlignStr(const AString: string; ALen: Integer; AChar: Char=#32; Align: TAlignment=taLeftJustify): string;

  public
    class function FInt(const Value: Integer; const Len: Byte = 2;
      const Fixed: Boolean = False): string; overload;
    class function FInt(const Value: string; const Len: Byte = 2): string; overload;
    class function FFlt(const Value: Extended;
                        const Format: string='0,00';
                        const Default: Extended = 0): string;
    class function FCur(const Value: Currency; const IncCurrency: Boolean = False): string;
    class function FDat(const Value: TDateTime; DatePart: TDatePart = dpDate;
      UseLocalBias: Boolean = False): String;

  public
    class function FormatDocFiscal(const AValue : String ): String; overload;
    class function FormatDocFiscal(const AValue : Integer): String; overload;
    class function FormatCPF(const AValue : String ): String;
    class function FormatCNPJ(const AValue : String ): String;
    class function FormatCEP(const AValue : String ): String; overload;
    class function FormatCEP(const AValue : Integer ): String; overload;
    class function FormatFone(const AValue : String): String; overload;
    class function FormatFone(const AValue : Integer): String; overload;
    class function FormatIE(const AValue, AUF: String ): String;
    class function FormatPlaca(const AValue: String): String;
  public
    class function Ch_Valida(const chNFe: string): Boolean;
    class function Ch_Format(const chNFe: string; const Bytes: Integer =44): string ;

  public
    class function EAN13Valido(const CodEAN13: String): Boolean ;
    class function EAN13_DV(const CodEAN13 : String): String ;

  end;

{$ENDREGION}

{$REGION 'nfe-utils.consts'}
//const
//  NFE_VER_APP             = 'SW NF-e v3.0';
//  NFE_VER_CAB_MSG         = '2.00';
//  NFE_VER_CONS_STT_SERV   = '2.00';
//  NFE_VER_ENVI_NFE        = '2.00';
//  NFE_VER_NFE             = '2.00';
//  NFE_VER_CONS_RECI_NFE   = '2.00';
//  NFE_VER_CONS_SIT_NFE    = '2.00';
//  NFE_VER_CANC_NFE        = '2.00';
//  NFE_VER_INUT_NFE        = '2.00';
//  NFE_VER_NFE_PROC        = '2.00';
//  NFE_VER_PROC_CANC_NFE		= '2.00';
//
//const // 30.10.2010
//  CLE_VER_CAB_MSG         = '1.00';
//  CLE_VER_CLE 						= '1.00' ;

const
  NFE_XSD_PATH = '\Schemas\nfe_v1.10.xsd';

  DSIGNS = 'xmlns:ds="http://www.w3.org/2000/09/xmldsig#"';

//const
//  NFE_PORTALFISCAL_INF_BR = 'http://www.portalfiscal.inf.br/nfe';
//  NFE_NAMESPACE           = 'http://www.portalfiscal.inf.br/nfe';
//  ENCODING_UTF8 = '?xml version="1.0" encoding="UTF-8"?';
//  ENCODING_UTF8_STD = '?xml version="1.0" encoding="UTF-8" standalone="no"?';

const
	LineBreak = #13#10;

{$ENDREGION}

{$REGION 'nfe-utils.vars'}
var
  LocalConfigNFe: TnfeConfig = nil;

{$ENDREGION}

{$REGION 'TNativeXmlHlp'}
type
  TNativeXmlHlp = class helper for TNativeXml
  public
    constructor Create; virtual;
    procedure SaveToFile(const ALocal, AFileName: string); overload;
    class function SaveXmlToFile(const xml_format: string; const file_name: string): Boolean;
  end;

  TXmlNodeHlp = class helper for TXmlNode
  public
    procedure AttributeAdd(const AName: UTF8String; AValue: Integer); overload;
    function ReadTime(const AName: string): TDateTime;
    procedure WriteFloat(const AName: string; const AValue: Double; const ADig: Byte = 2); overload ;
    procedure WriteDate(const AName: string;
                        const AValue: TDateTime;
                        const UseTime: Boolean=False;
                        const UseLocalBias: Boolean=False);
    procedure WriteTime(const AName: string; const AValue: TDateTime);
  end;
{$ENDREGION}

type
  Pbyte= ^byte;
  Pword= ^word;
  Pdword= ^dword;
  Pint64= ^int64;
  dword= longword;
  Pwordarray= ^Twordarray;
  Twordarray= array[0..19383] of word;
  Pdwordarray= ^Tdwordarray;
  Tdwordarray= array[0..8191] of dword;

  EDCP_hash= class(Exception);
  TDCP_hash= class(TPersistent)
  protected
    fInitialized: boolean;  { Whether or not the algorithm has been initialized }

    procedure DeadInt(Value: integer);   { Knudge to display vars in the object inspector   }
    procedure DeadStr(Value: string);    { Knudge to display vars in the object inspector   }

  private
    function _GetId: integer;
    function _GetAlgorithm: string;
    function _GetHashSize: integer;

  public
    property Initialized: boolean
      read fInitialized;

    class function GetId: integer; virtual;
      { Get the algorithm id }
    class function GetAlgorithm: string; virtual;
      { Get the algorithm name }
    class function GetHashSize: integer; virtual;
      { Get the size of the digest produced - in bits }
    class function SelfTest: boolean; virtual;
      { Tests the implementation with several test vectors }

    procedure Init; virtual;
      { Initialize the hash algorithm }
    procedure Final(var Digest); virtual;
      { Create the final digest and clear the stored information.
        The size of the Digest var must be at least equal to the hash size }
    procedure Burn; virtual;
      { Clear any stored information with out creating the final digest }

    procedure Update(const Buffer; Size: longword); virtual;
      { Update the hash buffer with Size bytes of data from Buffer }
    procedure UpdateStream(Stream: TStream; Size: longword);
      { Update the hash buffer with Size bytes of data from the stream }
    procedure UpdateStr(const Str: AnsiString); {$IFDEF UNICODE}overload; {$ENDIF}
      { Update the hash buffer with the string }
{$IFDEF UNICODE}
    procedure UpdateStr(const Str: UnicodeString); overload;
      { Update the hash buffer with the string }
{$ENDIF}

    destructor Destroy; override;

  published
    property Id: integer
      read _GetId write DeadInt;
    property Algorithm: string
      read _GetAlgorithm write DeadStr;
    property HashSize: integer
      read _GetHashSize write DeadInt;
  end;
  TDCP_hashclass= class of TDCP_hash;

  TDCP_sha1= class(TDCP_hash)
  protected
    LenHi, LenLo: longword;
    Index: DWord;
    CurrentHash: array[0..4] of DWord;
    HashBuffer: array[0..63] of byte;
    procedure Compress;
  public
    const DCP_sha1 = 2;
  public
    class function GetId: integer; override;
    class function GetAlgorithm: string; override;
    class function GetHashSize: integer; override;
    class function SelfTest: boolean; override;
    class function Execute(const Buffer: string): string;
    procedure Init; override;
    procedure Final(var Digest); override;
    procedure Burn; override;
    procedure Update(const Buffer; Size: longword); override;
  end;


{$REGION 'nfe-utils.functions'}
function StrIsAlpha(const S: AnsiString): Boolean;
function StrIsAlphaNum(const S: AnsiString): Boolean;
function StrIsNumber(const S: AnsiString): Boolean;
function CharIsAlpha(const C: AnsiChar): Boolean;
function CharIsAlphaNum(const C: AnsiChar): Boolean;
function CharIsNum(const C: AnsiChar): Boolean;
//function OnlyNumber(const AValue: AnsiString): String;
//function OnlyAlpha(const AValue: AnsiString): String;
//function OnlyAlphaNum(const AValue: AnsiString): String;
//function StrIsIP(const AValue: string): Boolean;
function StrToHex(const S: AnsiString): string;
function FltToHex(const V: Extended): string;

{$ENDREGION}


implementation

uses
  Windows, DateUtils,  StrUtils , MaskUtils,  Math ;
{$Q-}{$R-}

type  Tcoduf_ibge = record
      public
        uf_codigo: Byte;
        uf_sigla : string;
      end;

const
  UF_IBGE = 27;
  COD_IBGE_UF: array [0..UF_IBGE -1] of Tcoduf_ibge = (
    // reg. 10
    (uf_codigo: 11  ; uf_sigla: 'RO') ,
    (uf_codigo: 12  ; uf_sigla: 'AC') ,
    (uf_codigo: 14  ; uf_sigla: 'RR') ,
    (uf_codigo: 13  ; uf_sigla: 'AM') ,
    (uf_codigo: 15  ; uf_sigla: 'PA') ,
    (uf_codigo: 16  ; uf_sigla: 'AP') ,
    (uf_codigo: 17  ; uf_sigla: 'TO') ,
    // reg. 20
    (uf_codigo: 21  ; uf_sigla: 'MA') ,
    (uf_codigo: 22  ; uf_sigla: 'PI') ,
    (uf_codigo: 23  ; uf_sigla: 'CE') ,
    (uf_codigo: 24  ; uf_sigla: 'RN') ,
    (uf_codigo: 25  ; uf_sigla: 'PB') ,
    (uf_codigo: 26  ; uf_sigla: 'PE') ,
    (uf_codigo: 27  ; uf_sigla: 'AL') ,
    (uf_codigo: 28  ; uf_sigla: 'SE') ,
    (uf_codigo: 29  ; uf_sigla: 'BA') ,
    // reg. 30
    (uf_codigo: 31  ; uf_sigla: 'MG') ,
    (uf_codigo: 32  ; uf_sigla: 'ES') ,
    (uf_codigo: 33  ; uf_sigla: 'RJ') ,
    (uf_codigo: 35  ; uf_sigla: 'SP') ,
    // reg. 40
    (uf_codigo: 41  ; uf_sigla: 'PR') ,
    (uf_codigo: 42  ; uf_sigla: 'SC') ,
    (uf_codigo: 43  ; uf_sigla: 'RS') ,
    // reg. 50
    (uf_codigo: 50  ; uf_sigla: 'MS') ,
    (uf_codigo: 51  ; uf_sigla: 'MT') ,
    (uf_codigo: 52  ; uf_sigla: 'GO') ,
    (uf_codigo: 53  ; uf_sigla: 'DF')
    );

var
  CertStore     : IStore3;
  CertStoreMem  : IStore3;
  PrivateKey    : IPrivateKey;
  Certs         : ICertificates2;
  Cert          : ICertificate2;
  NumCertCarregado: String;


function SwapDWord(a: dword): dword;
begin
  Result:= ((a and $FF) shl 24) or ((a and $FF00) shl 8) or ((a and $FF0000) shr 8) or ((a and $FF000000) shr 24);
end;

{$REGION 'functions'}
function AssinarMSXML(AXML: String; ACert: ICertificate2; out AOutXML, retMsg: String): Boolean;
var
    foundCert     : Boolean;

    I, J, PosIni, PosFim : Integer;
    URI           : String ;
    Tipo : Integer;

    xmlHeaderAntes, xmlHeaderDepois : AnsiString ;
    retStr: AnsiString;

    xmldoc    :IXMLDOMDocument3;
    xmldsig   :IXMLDigitalSignature;
    dsigKey   :IXMLDSigKey;
    signedKey :IXMLDSigKey;

    doc	:TNativeXml;

begin
    Result  :=False;

    if Pos('<Signature', AXML) <= 0 then
    begin

      I := pos('<infNFe', AXML) ;
      Tipo := 1;

      if I = 0  then
      begin
      	I := pos('<infCanc', AXML) ;
      	if I > 0 then
        	Tipo := 2
        else begin
          I := pos('<infInut', AXML) ;
          if I > 0 then
             Tipo := 3
          else begin
            I := Pos('<infEvento', AXML);
            if I > 0 then
              Tipo := 5
            else
              Tipo := 4;
          end;

       	end;
      end;

      I := PosEx('Id=', AXML, I+6) ;
      if I = 0 then
      begin
         retMsg :='Não encontrei inicio do URI: Id=';
         Exit;
      end;

      I := PosEx('"', AXML, I+2) ;
      if I = 0 then
      begin
         retMsg :='Não encontrei inicio do URI: aspas inicial';
         Exit;
      end;

      J := PosEx('"', AXML, I+1) ;
      if J = 0 then
      begin
         retMsg :='Não encontrei inicio do URI: aspas final';
         Exit;
      end;

      URI := copy(AXML, I+1, J-I-1);

      if 			Tipo = 1 then	AXML :=Copy(AXML, 1, Pos('</NFe>', AXML)-1)
      else if Tipo = 2 then	AXML :=Copy(AXML, 1, Pos('</cancNFe>', AXML)-1)
      else if Tipo = 3 then AXML :=Copy(AXML, 1, Pos('</inutNFe>', AXML)-1)
      else if Tipo = 4 then AXML :=Copy(AXML, 1, Pos('</envDPEC>', AXML)-1)
      else if Tipo = 5 then AXML :=Copy(AXML, 1, Pos('</evento>', AXML)-1);

      AXML :=AXML + '<Signature xmlns="http://www.w3.org/2000/09/xmldsig#"><SignedInfo><CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/><SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" />';
      AXML :=AXML + '<Reference URI="#'+URI+'">';
      AXML :=AXML + '<Transforms><Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature" /><Transform Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" /></Transforms><DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" />';
      AXML :=AXML + '<DigestValue></DigestValue></Reference></SignedInfo><SignatureValue></SignatureValue><KeyInfo></KeyInfo></Signature>';

      if 			Tipo = 1 then	AXML :=AXML + '</NFe>'
      else if Tipo = 2 then	AXML :=AXML + '</cancNFe>'
      else if Tipo = 3 then AXML :=AXML + '</inutNFe>'
      else if Tipo = 4 then AXML :=AXML + '</envDPEC>'
      else if Tipo = 5 then AXML :=AXML + '</evento>';

    end;

   // Lendo Header antes de assinar //
   xmlHeaderAntes := '' ;
   I := pos('?>', AXML) ;
   if I > 0 then
      xmlHeaderAntes := Copy(AXML, 1, I+1) ;

    xmldoc := CoDOMDocument50.Create;
    try
        xmldoc.async              := False;
        xmldoc.validateOnParse    := False;
        xmldoc.preserveWhiteSpace := True;

        xmldsig := CoMXDigitalSignature50.Create;

        if (not xmldoc.loadXML(AXML) ) then
        begin
//            doc :=TNativeXml.Create;
//            try
//              doc.ReadFromString(AXML);
//              doc.SaveToFile('nfe.xml');
//            finally
//              doc.Free;
//            end;
            retMsg  :='Não foi possível carregar o arquivo XML!';
            Exit;
        end;

        xmldoc.setProperty('SelectionNamespaces', DSIGNS);

        xmldsig.signature := xmldoc.selectSingleNode('.//ds:Signature');

        if (xmldsig.signature = nil) then
        begin
            retMsg  :='Falha ao setar assinatura!';
            Exit;
        end;

        if (xmldsig.signature = nil) then
        begin
            retMsg  :='É preciso carregar o template antes de assinar!';
            Exit;
        end;

        if NumCertCarregado <> ACert.SerialNumber then
        begin
        	CertStoreMem := nil;
        end;

        if CertStoreMem = nil then
        begin
          CertStore :=CoStore.Create;
          CertStore.Open(CAPICOM_CURRENT_USER_STORE, 'My', CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED);

          CertStoreMem := CoStore.Create;
          CertStoreMem.Open(CAPICOM_MEMORY_STORE, 'Memoria', CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED);

          Certs := CertStore.Certificates as ICertificates2;
          for i:= 1 to Certs.Count do
          begin
            Cert := IInterface(Certs.Item[i]) as ICertificate2;
            if Cert.SerialNumber = ACert.SerialNumber then
             begin
               CertStoreMem.Add(Cert);
               NumCertCarregado := ACert.SerialNumber;
               foundCert :=True;
             end;
          end;
        end;

        OleCheck(IDispatch(ACert.PrivateKey).QueryInterface(IPrivateKey,PrivateKey));
        xmldsig.store := CertStoreMem;

        dsigKey := xmldsig.createKeyFromCSP(PrivateKey.ProviderType, PrivateKey.ProviderName, PrivateKey.ContainerName, 0);
        if dsigKey = nil then
        begin
            retMsg  :='Erro ao criar a chave do CSP!';
            Exit;
        end;

        signedKey := xmldsig.sign(dsigKey, $00000002);
        if (signedKey <> nil) then
        begin
          	retStr	:=xmldoc.xml;
            retStr	:=StringReplace(retStr, #10, '', [rfReplaceAll]	);
            retStr 	:=StringReplace(retStr, #13, '', [rfReplaceAll]	);
            PosIni  :=Pos('<SignatureValue>', retStr) +Length('<SignatureValue>');
            retStr 	:=Copy(retStr, 1, PosIni-1) +StringReplace(Copy(retStr, PosIni, Length(retStr)), ' ', '', [rfReplaceAll]);
            PosIni  :=Pos('<X509Certificate>', retStr)-1;
            PosFim  :=Tnfeutil.PosLast('<X509Certificate>', retStr);
            retStr	:=Copy(retStr, 1, PosIni) + Copy(retStr, PosFim, Length(retStr));

            retMsg  :='Assinatura sucesso.';
            Result  :=True;
        end
        else begin
            retMsg  :='Assinatura Falhou!';
        end;

        if xmlHeaderAntes <> '' then
        begin
          I := pos('?>', retStr) ;
          if I > 0 then
           begin
             xmlHeaderDepois := Copy(retStr, 1, I+1) ;
             if xmlHeaderAntes <> xmlHeaderDepois then
             begin
                retStr :=StuffString(retStr, 1, Length(xmlHeaderDepois), xmlHeaderAntes) ;
             end;
           end
          else
             retStr :=xmlHeaderAntes + retStr ;
        end ;

        if Result then
        begin
          AOutXML	:=retStr;
        end;

    finally
        dsigKey   := nil;
        signedKey := nil;
        xmldoc    := nil;
        xmldsig   := nil;
    end;

end;


{$REGION 'nfe-utils.functions'}
function CharIsAlpha(const C: AnsiChar): Boolean;
begin
  Result := ( C in ['A'..'Z','a'..'z'] ) ;
end ;

function CharIsAlphaNum(const C: AnsiChar): Boolean;
begin
  Result := ( CharIsAlpha( C ) or CharIsNum( C ) );
end ;

function CharIsNum(const C: AnsiChar): Boolean;
begin
  Result := ( C in ['0'..'9'] ) ;
end ;

function StrIsAlpha(const S: AnsiString): Boolean;
Var A : Integer ;
begin
  Result := True ;
  A      := 1 ;
  while Result and ( A <= Length( S ) )  do
  begin
     Result := CharIsAlpha( S[A] ) ;
     Inc(A) ;
  end;
end ;

function StrIsNumber(const S: AnsiString): Boolean;
Var
  A, LenStr : Integer ;
begin
  LenStr := Length( S ) ;
  Result := (LenStr > 0) ;
  A      := 1 ;
  while Result and ( A <= LenStr )  do
  begin
     Result := CharIsNum( S[A] ) ;
     Inc(A) ;
  end;
end ;

function StrIsAlphaNum(const S: AnsiString): Boolean;
Var
  A : Integer ;
begin
  Result := true ;
  A      := 1 ;
  while Result and ( A <= Length( S ) )  do
  begin
     Result := CharIsAlphaNum( S[A] ) ;
     Inc(A) ;
  end;
end ;

function StrToHex(const S: AnsiString): string;
var
  C: Integer ;
begin
  Result :='';
  for C :=1 to Length(S) do
  begin
    Result :=Result +SysUtils.IntToHex(Byte(S[C]), 2) ;
  end;
end;

function FltToHex(const V: Extended): string;
begin
  Result :=StrToHex(Tnfeutil.FFlt(V, '0,00')) ;
end;

{$ENDREGION}

{ Tnfeutil }

class function Tnfeutil.PosEx(const SubStr, S: AnsiString; Offset: Cardinal = 1): Integer;
var
  I,X: Integer;
  Len, LenSubStr: Integer;
begin
  if Offset = 1 then
    Result := Pos(SubStr, S)
  else
  begin
    I := Offset;
    LenSubStr := Length(SubStr);
    Len := Length(S) - LenSubStr + 1;
    while I <= Len do
    begin
      if S[I] = SubStr[1] then
      begin
        X := 1;
        while (X < LenSubStr) and (S[I + X] = SubStr[X + 1]) do
          Inc(X);
        if (X = LenSubStr) then
        begin
          Result := I;
          exit;
        end;
      end;
      Inc(I);
    end;
    Result := 0;
  end;
end;

class function Tnfeutil.PosLast(const SubStr, S: AnsiString ): Integer;
Var P : Integer ;
begin
  Result := 0 ;
  P := Pos( SubStr, S) ;
  while P <> 0 do
  begin
     Result := P ;
     P := PosEx( SubStr, S, P+1) ;
  end ;
end ;

class function Tnfeutil.RemoveCtrlChar(const AValue: string): string;
var
  i, j: integer;
begin
  Setlength(Result, Length(AValue));
  i := 1;
  j := 1;
  while i <= Length(AValue) do
    if AValue[i] in [#9, #10, #13] then
      inc(i)
    else
    begin
      Result[j] := AValue[i];
      inc(i);
      inc(j);
    end;
  // Adjust length
  if i <> j then
    SetLength(Result, j - 1);
end;

class function Tnfeutil.CortaD(const AString: string; const ATamanho: Integer): String;
begin
    Result := Copy(AString, 1, ATamanho);
end;

class function Tnfeutil.CortaE(const AString: string;
  const ATamanho: Integer): String;
begin
  Result := AString;
  if Length(AString) > ATamanho then
    Result := copy(AString, Length(AString)-ATamanho+1, length(AString));
end;

class function Tnfeutil.EAN13Valido(const CodEAN13: String): Boolean;
begin
  if Length(CodEAN13) = 13 then
    Result := ( CodEAN13[13] =  EAN13_DV(CodEAN13) )
  else
    Result := False;
end;

class function Tnfeutil.EAN13_DV(const CodEAN13: String): String;
var
  A,DV : Integer ;
begin
  Result :=Trim(CodEAN13) ;
  Result := PadD(Result, 12 ,'0') ;
  if StrIsNumber( AnsiString( Result ) ) then
  begin
    DV := 0;
    for A := 12 downto 1 do
      DV := DV + (StrToInt( Result[A] ) * IfThen(Odd(A),1,3));

    DV := (Ceil( DV / 10 ) * 10) - DV ;

    Result := IntToStr( DV );
  end
  else
    Result :='';
end;

class function Tnfeutil.LasString(AString: String): String;
begin
  Result := Copy(AString, Length(AString), Length(AString));
end;

class function Tnfeutil.LimpaNumero(const AValue: String; const AIsZero: Boolean): String;
var
  A : Integer ;
begin
  Result := '' ;
  for A := 1 to Length(AValue) do
  begin
     if AIsZero then
     begin
         if (AValue[A] in ['0'..'9']) then
            Result := Result + AValue[A];
     end
     else begin
         if (AValue[A] in ['1'..'9']) then
            Result := Result + AValue[A];
     end;
  end ;
end;

class function Tnfeutil.Mod11(Valor: string): Byte;
var
  Soma: integer;
  Contador, Peso, Digito: integer;
begin
  Result :=0;
  Soma := 0;
  Peso := 2;
  for Contador := Length(Valor) downto 1 do
  begin
    Soma := Soma + (StrToInt(Valor[Contador]) * Peso);
    if Peso < 9 then
      Peso := Peso + 1
    else
      Peso := 2;
  end;

  Digito := 11 - (Soma mod 11);
  if (Digito > 9) then
    Digito := 0;

  Result := Digito;
end;

class function Tnfeutil.SeSenao(const ACondicao: Boolean; ATrue, AFalse: Variant): Variant;
begin
  if ACondicao then	Result :=ATrue
  else              Result :=AFalse;
end;

class function Tnfeutil.Se(const ACondicao: Boolean; const ATrue, AFalse: Integer): Integer;
begin
  if ACondicao then	Result :=ATrue
  else              Result :=AFalse;
end;

class function Tnfeutil.SelCertificado: Boolean;
var
  Certs2: ICertificates2;

begin
  Result :=False;
  CertStore :=CoStore.Create;
  CertStore.Open(CAPICOM_CURRENT_USER_STORE, 'My', CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED);

  Certs   :=CertStore.Certificates as ICertificates2;
  Certs2  :=Certs.Select('Certificado(s) digital(is) disponível(is)', 'Selecione o certificado digital para uso no aplicativo', False);
  if not(Certs2.Count = 0) then
  begin
    Cert :=IInterface(Certs2.Item[1]) as ICertificate2;
    LocalConfigNFe.cert.SerialNumber  :=Cert.SerialNumber;
    LocalConfigNFe.cert.SubjectName   :=Cert.SubjectName;
    LocalConfigNFe.cert.ValidFromDate :=Cert.ValidFromDate;
    LocalConfigNFe.cert.ValidToDate   :=Cert.ValidToDate;
    Result :=True;
  end;
  CertStore :=nil;
  Certs     :=nil;
  Certs2    :=nil;
end;

class function Tnfeutil.SendMail(AStru: Tsmtp_mail_send_structure; out AOut: string): Boolean;
var mess:TIdMessage;
var attc:TIdAttachmentFile;
var text:TIdText;
var free:TIdAntiFreeze;
var smtp:TIdSMTP;
var sock:TIdSSLIOHandlerSocketOpenSSL;
var pop3:TIdPOP3;
var i:Integer;
var f:string;
		//
    function MailTypMIME(TypMIME: Integer): string;
    begin
        case TypMIME of
            00 :Result :='text/plain';
            01 :Result :='text/html';
            02 :Result :='text/richtext';
            03 :Result :='text/x-aiff';
            04 :Result :='audio/basic';
            05 :Result :='audio/wav';
            06 :Result :='image/gif';
            07 :Result :='image/jpeg';
            08 :Result :='image/pjpeg';
            09 :Result :='image/tiff';
            10 :Result :='image/x-png';
            11 :Result :='image/x-xbitmap';
            12 :Result :='image/bmp';
            13 :Result :='image/x-jg';
            14 :Result :='image/x-emf';
            15 :Result :='image/x-wmf';
            16 :Result :='video/avi';
            17 :Result :='video/mpeg';
            18 :Result :='application/postscript';
            19 :Result :='application/base64';
            20 :Result :='application/macbinhex40';
            21 :Result :='application/pdf'; // arquivos PDF !!!
            22 :Result :='application/x-compressed';
            23 :Result :='application/x-zip-compressed';
            24 :Result :='application/x-gzip-compressed';
            25 :Result :='application/java';
            26 :Result :='application/x-msdownload';
            27 :Result :='application/octet-stream'; // arquivos .dat !!!!
            28 :Result :='multipart/mixed';
            29 :Result :='multipart/relative';
            30 :Result :='multipart/digest';
            31 :Result :='multipart/alternative';
            32 :Result :='multipart/related';
            33 :Result :='multipart/report';
            34 :Result :='multipart/signed';
            35 :Result :='multipart/encrypted';
        end;
    end;
    //
begin
    // libeay32.dll
    // ssleay32.dll
    free:=TIdAntiFreeze.Create(nil);
    mess:=TIdMessage.Create(nil);
    try
      	mess.Clear;
        mess.IsEncoded					:=True;
        mess.AttachmentEncoding :='MIME';
        mess.Encoding 					:=meMIME; // meDefault;
        mess.ConvertPreamble 		:=True;
        mess.Priority 					:=mpNormal;
        mess.ContentType 				:='multipart/mixed'; // obrigatoriamente!
        mess.CharSet 						:='ISO-8859-1';
        mess.Date 							:=Now;

        mess.Organization                :=AStru.mail_name;

        mess.From.Address                :=AStru.smtp_mail;
        mess.From.Text                   :=AStru.mail_name;
        mess.ReplyTo.EMailAddresses			 :=AStru.smtp_mail;

        mess.Recipients.EMailAddresses   :=AStru.mail_dest;

//        mess.Body.Text                   :=structure.mail_text;
        mess.Subject                     :=AStru.mail_subj;

        text	:=TIdText.Create(mess.MessageParts, nil);
        text.ContentType 				:=MailTypMIME(1);
        text.ContentDescription :='multipart-1';
        text.CharSet 						:='ISO-8859-1'; // NOSSA LINGUAGEM PT-BR (Latin-1)!!!!
        text.ContentTransfer 		:='16bit';			// ACENTUADO !!! Pois, 8bit SAI SEM ACENTO !!!
        text.Body.Clear;
        text.Body.Add(AStru.mail_text);

        for i :=0 to High(AStru.mail_file) do
        begin
            f:=AStru.mail_file[i].filename;
            if FileExists(f) then
            begin
                attc							:=TIdAttachmentFile.Create(mess.MessageParts, f);
                attc.ContentType	:=MailTypMIME(1) +';';
            end;
        end;

        sock							:=TIdSSLIOHandlerSocketOpenSSL.Create(nil);
        sock.Destination	:=Format('%s:%d',[AStru.smtp_host,AStru.smtp_port]);
        sock.Host         :=AStru.smtp_host;
        sock.Port					:=AStru.smtp_port;

        sock.SSLOptions.Method	:=sslvTLSv1; // sslvSSLv2;
        sock.SSLOptions.Mode		:=sslmUnassigned;
        sock.SSLOptions.VerifyMode	:=[];
        sock.SSLOptions.VerifyDepth	:=0;

        smtp						:=TIdSMTP.Create(nil);
        smtp.IOHandler	:=sock;
        smtp.UseTLS			:=utUseExplicitTLS;

//        smtp.AuthType   :=atDefault;
        smtp.ConnectTimeout	:=10000;
        smtp.ReadTimeout		:=10000;
        smtp.Host       :=AStru.smtp_host;
        smtp.Port       :=AStru.smtp_port;
        smtp.Username   :=AStru.smtp_user;
        smtp.Password   :=AStru.smtp_pass;

        smtp.HeloName   :=AStru.smtp_helo;

        try
            smtp.Connect();
            smtp.Authenticate();
            if smtp.Connected then
            begin
                smtp.Send(mess);
                Result:=True;
                smtp.Disconnect();
                AOut	:=Format('NF-e enviada com sucesso p/ %s',[AStru.mail_dest]);
            end;
        except
            on e:Exception do
          	begin
           		Result:=False;
              AOut	:=Format('Falha no envio de NF-e! %s',[e.Message]);
            end;
        end;

    finally
      	FreeAndNil(sock);
        FreeAndNil(smtp);
        FreeAndNil(mess);
        FreeAndNil(free);
    end;

end;

class function Tnfeutil.SeparaDados(Texto: AnsiString; Chave: String;
  MantemChave: Boolean): AnsiString;
var
  PosIni, PosFim : Integer;
begin
  if MantemChave then
   begin
     PosIni := Pos(Chave,Texto)-1;
     PosFim := Pos('/'+Chave,Texto)+length(Chave)+3;

     if (PosIni = 0) or (PosFim = 0) then
      begin
        PosIni := Pos('ns2:'+Chave,Texto)-1;
        PosFim := Pos('/ns2:'+Chave,Texto)+length(Chave)+3;
      end;
   end
  else
   begin
     PosIni := Pos(Chave,Texto)+Pos('>',copy(Texto,Pos(Chave,Texto),length(Texto)));
     PosFim := Pos('/'+Chave,Texto);

     if (PosIni = 0) or (PosFim = 0) then
      begin
        PosIni := Pos('ns2:'+Chave,Texto)+Pos('>',copy(Texto,Pos('ns2:'+Chave,Texto),length(Texto)));
        PosFim := Pos('/ns2:'+Chave,Texto);
      end;
   end;
  Result := copy(Texto,PosIni,PosFim-(PosIni+1));
end;

class function Tnfeutil.TrataString(const AValue: String): String;
var
  a : Integer ;
begin
  Result := '' ;
  for a := 1 to Length(AValue) do
  begin
    case Ord(AValue[a]) of
      60  : Result := Result + '&lt;';  //<
      62  : Result := Result + '&gt;';  //>
      38  : Result := Result + '&amp;'; //&
      34  : Result := Result + '&quot;';//"
      39  : Result := Result + '&#39;'; //'
      32  : begin          // Retira espaços duplos
              if ( Ord(AValue[Pred(a)]) <> 32 ) then
                 Result := Result + ' ';
            end;
      193 : Result := Result + 'A';//Á
      224 : Result := Result + 'a';//à
      226 : Result := Result + 'a';//â
      234 : Result := Result + 'e';//ê
      244 : Result := Result + 'o';//ô
      251 : Result := Result + 'u';//û
      227 : Result := Result + 'a';//ã
      245 : Result := Result + 'o';//õ
      225 : Result := Result + 'a';//á
      233 : Result := Result + 'e';//é
      237 : Result := Result + 'i';//í
      243 : Result := Result + 'o';//ó
      250 : Result := Result + 'u';//ú
      231 : Result := Result + 'c';//ç
      252 : Result := Result + 'u';//ü
      192 : Result := Result + 'A';//À
      194 : Result := Result + 'A';//Â
      202 : Result := Result + 'E';//Ê
      212 : Result := Result + 'O';//Ô
      219 : Result := Result + 'U';//Û
      195 : Result := Result + 'A';//Ã
      213 : Result := Result + 'O';//Õ
      201 : Result := Result + 'E';//É
      205 : Result := Result + 'I';//Í
      211 : Result := Result + 'O';//Ó
      218 : Result := Result + 'U';//Ú
      199 : Result := Result + 'C';//Ç
      220 : Result := Result + 'U';//Ü
    else
        if Ord(AValue[a]) <= 126 then
        begin
          Result := Result + AValue[a];
        end;
    end;
  end;
  Result := Trim(Result);
end;

class function Tnfeutil.TrataString(const AValue: String; const ATamanho: Integer): String;
begin
  Result := TrataString(Tnfeutil.CortaD(AValue, ATamanho));
end;

class function Tnfeutil.TamanhoIgual(const AValue: String;
  const ATamanho: Integer): Boolean;
begin
  Result := (Length(AValue)= ATamanho);
end;

class procedure Tnfeutil.TamanhoIgual(const AValue: String;
  const ATamanho: Integer; AMensagem: String);
begin
  if not(Tnfeutil.TamanhoIgual(AValue, ATamanho)) then
    raise Exception.Create(AMensagem);
end;

class function Tnfeutil.TamanhoIgual(const AValue,
  ATamanho: Integer): Boolean;
begin
  Result := (Length(IntToStr(AValue))= ATamanho);
end;

class procedure Tnfeutil.TamanhoIgual(const AValue,
  ATamanho: Integer; AMensagem: String);
begin
  if not(Tnfeutil.TamanhoIgual(AValue, ATamanho)) then
    raise Exception.Create(AMensagem);
end;

{class function Tnfeutil.xml_Assinar(const Axml: String; ACert: ICertificate2;
  out AOutXML, AOutMsg: String): Boolean;
begin
  Result := AssinarMSXML(Axml, ACert, AOutXML, AOutMsg);
end;}

class function Tnfeutil.xml_Assinar(const AXml: String; out AOutXML,
  ARetMsg: String): Boolean;
var
  doc: TNativeXml;
  R: TsdElement;
var
  URI: string;
  Pi, Pf: Integer;
var
  xmldoc            : IXMLDOMDocument3;
  xmldsig           : IXMLDigitalSignature;
  dsigKey           : IXMLDSigKey;
  signedKey         : IXMLDSigKey;
begin
  Result :=False;

  // valida xml de entrada
  doc :=TNativeXml.Create;
  try
    doc.XmlFormat :=xfCompact;
    try
      doc.ReadFromString(AXml);
    except
      ARetMsg :='XML inválido!';
      Exit;
    end;

    R :=doc.Root;
    if R.NodeByName('Signature')=nil then
    begin
      if R.NodeByName('infNFe')<>nil then
      begin
        URI :='#'+R.NodeByName('infNFe').ReadAttributeString('Id') ;
      end
      else if R.NodeByName('infEvento')<>nil then
      begin
        URI :='#'+R.NodeByName('infEvento').ReadAttributeString('Id');
      end;

      with R.NodeNew('Signature') do
      begin
        AttributeAdd('xmlns', 'http://www.w3.org/2000/09/xmldsig#');
        with NodeNew('SignedInfo') do
        begin
          NodeNew('CanonicalizationMethod').AttributeAdd('Algorithm', 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315');
          NodeNew('SignatureMethod').AttributeAdd('Algorithm', 'http://www.w3.org/2000/09/xmldsig#rsa-sha1');
          with NodeNew('Reference') do
          begin
            AttributeAdd('URI', URI);
            with NodeNew('Transforms') do
            begin
              NodeNew('Transform').AttributeAdd('Algorithm', 'http://www.w3.org/2000/09/xmldsig#enveloped-signature');
              NodeNew('Transform').AttributeAdd('Algorithm', 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315');
            end;
            NodeNew('DigestMethod').AttributeAdd('Algorithm', 'http://www.w3.org/2000/09/xmldsig#sha1');
            WriteString('DigestValue', '') ;
          end;
        end;
        WriteString('SignatureValue', '');
        WriteString('KeyInfo', '');
      end;

    end;
    //XML :=doc.WriteToString ;

    xmldoc :=CoDOMDocument50.Create;
    xmldoc.async              :=False;
    xmldoc.validateOnParse    :=False;
    xmldoc.preserveWhiteSpace :=True;
    if xmldoc.loadXML(doc.WriteToLocalUnicodeString) then
    begin
      xmldoc.setProperty('SelectionNamespaces', DSIGNS);
    end
    else begin
      ARetMsg :='Não foi possível carregar XML!';
//      xmldoc :=nil;
      Exit;
    end;

    xmldsig :=CoMXDigitalSignature50.Create;
    xmldsig.signature :=xmldoc.selectSingleNode('.//ds:Signature');

    if (xmldsig.signature = nil) then
    begin
      ARetMsg :='Falha ao setar assinatura!';
//      xmldsig :=nil;
      Exit;
    end;

//    if (xmldsig.signature = nil) then
//      raise Exception.Create('É preciso carregar o template antes de assinar.');

    if GetCertificado = nil then
    begin
      if not SelCertificado then
      begin
        ARetMsg :='Nenhum certificado selecionado!';
//        xmldoc  :=nil;
//        xmldsig :=nil;
        Exit;
      end;
    end;

    if CertSerialMm <> GetCertificado.SerialNumber then
    begin
      CertStoreMem :=nil;
    end;

    if CertStoreMem = nil then
    begin
      CertStoreMem :=CoStore.Create;
      CertStoreMem.Open(CAPICOM_MEMORY_STORE, 'Memoria', CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED);
      CertStoreMem.Add(Cert);
      CertSerialMm :=Cert.SerialNumber;
    end;

    OleCheck(IDispatch(Cert.PrivateKey).QueryInterface(IPrivateKey, PrivateKey));
    xmldsig.store :=CertStoreMem;

    dsigKey := xmldsig.createKeyFromCSP(PrivateKey.ProviderType, PrivateKey.ProviderName, PrivateKey.ContainerName, 0);
    if (dsigKey = nil) then
    begin
      ARetMsg :='Erro ao criar a chave do CSP!';
//      xmldoc :=nil;
//      xmldsig:=nil;
//      dsigKey:=nil;
      Exit;
    end;

    signedKey := xmldsig.sign(dsigKey, $00000002);
    if (signedKey <> nil) then
    begin
      AOutXML :=xmldoc.xml;
      Pi  :=Pos('<SignatureValue>', AOutXML) + Length('<SignatureValue>');
      AOutXML :=Copy(AOutXML, 1, Pi -1) + StringReplace(Copy(AOutXML, Pi, Length(AOutXML)), ' ', '', [rfReplaceAll]);
      Pi :=Pos('<X509Certificate>', AOutXML) -1;
      Pf :=Tnfeutil.PosLast('<X509Certificate>', AOutXML);
      AOutXML :=Copy(AOutXML, 1, Pi) + Copy(AOutXML, Pf, Length(AOutXML));
      AOutXML :=StringReplace(AOutXML, #13#10, '', [rfReplaceAll]) ;

      Result :=True;
      ARetMsg :='Assinatura com sucesso.';
    end
    else begin
      ARetMsg :='Assinatura falhou!';
    end;

//    if Result then
//    begin
//      doc.ReadFromString(AOutXML);
//      AOutXML :=AnsiString(doc.Root.WriteToString);
//    end;

  finally
    doc.Free ;
    dsigKey :=nil;
    signedKey :=nil;
    xmldoc :=nil;
    xmldsig :=nil;
  end;

end;


class function Tnfeutil.xml_Validar(const Axml, ANameSpace, ASchema: string;
  out ARetMsg: string): Boolean;
var
  DOMDocument: IXMLDOMDocument2;
  ParseError: IXMLDOMParseError;
  Schema: XMLSchemaCache;
  Tipo, I : Integer;
  f:string;
begin

  DOMDocument :=CoDOMDocument50.Create;
  try
      DOMDocument.async             :=False;
      DOMDocument.resolveExternals  :=False;
      DOMDocument.validateOnParse   :=True;
      try
          DOMDocument.loadXML(Axml);
          Schema := CoXMLSchemaCache50.Create;
          Schema.add(ANameSpace, ASchema);

          DOMDocument.schemas := Schema;
          ParseError:=DOMDocument.validate;
          Result    :=(ParseError.errorCode = 0);
          ARetMsg   :=ParseError.reason;
      except
          Result  :=False ;
      end;

  finally
      DOMDocument := nil;
      ParseError := nil;
      Schema := nil;
  end;
end;

class function Tnfeutil.TamanhoMenor(const AValue: String;
  const ATamanho: Integer): Boolean;
begin
  Result := (Length(AValue) < ATamanho);
end;

class function Tnfeutil.GetCertificado: ICertificate2;
var
   I: Integer;
begin
  if Cert = nil then
  begin
    CertStore :=CoStore.Create;
    CertStore.Open(CAPICOM_CURRENT_USER_STORE, 'My', CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED);

    Certs :=CertStore.Certificates as ICertificates2;
    for I:= 1 to Certs.Count do
    begin
      OleCheck(IDispatch(Certs.Item[I]).QueryInterface(ICertificate2, Cert));
      if Cert.SerialNumber = LocalConfigNFe.cert.SerialNumber then
      begin
        Break;
      end;
    end;
    CertStore :=nil;
    Certs     :=nil;
  end;
  Result :=Cert;
end;

class function Tnfeutil.GetNumbers(const Value: string;
  const Count: Integer): string;
var I:Integer;
var C:Char;
begin
     Result := '';
     for I := 1 to Length(Value) do
     begin
          C :=UpCase(Value[I])	;
          if C in ['0'..'9'] then
          begin
               Result := Result + C;
          end;
     end;
     if Count > 0 then
     begin
        Result :=CortaE(Result, Count) ;
     end;
end;

class function Tnfeutil.GetUF(const Sigla: string): Byte;
var i:Integer;
var c:Integer;
begin
  Result	:=00;
  for i :=0 to UF_IBGE -1 do
  begin
      if COD_IBGE_UF[i].uf_sigla = Sigla then
      begin
          Result :=COD_IBGE_UF[i].uf_codigo;
          Break;
      end;
  end;
end;

class function Tnfeutil.GetUF(const Codigo: Byte): string;
var i:Integer;
var c:Integer;
begin
  Result	:='';
  for i :=0 to UF_IBGE -1 do
  begin
      if COD_IBGE_UF[i].uf_codigo = Codigo then
      begin
          Result :=COD_IBGE_UF[i].uf_sigla;
          Break;
      end;
  end;
end;

class function Tnfeutil.IsEmpty(const AValue: String): Boolean;
begin
  Result := (Trim(AValue)='');
end;

class function Tnfeutil.IsEmpty(const AValue: Extended): Boolean;
begin
  	Result := (AValue = 0);
end;

class function Tnfeutil.IsEmpty(const AValue: TDateTime): Boolean;
begin
  Result :=YearOf(AValue) <= 1900;
end;

class function Tnfeutil.IsEmpty(const AValue: Integer; const AMsg: string): Boolean;
begin
  if Tnfeutil.IsEmpty(AValue) then
    raise Exception.Create(AMsg);
end;

class function Tnfeutil.IsEmpty(const AValue: Integer): Boolean;
begin
		Result := (AValue = 0);
end;

class function Tnfeutil.FInt(const Value: Integer; const Len: Byte;
  const Fixed: Boolean): string;
begin
  if Fixed then
    Result :=FFlt(Value, '0.000')
  else begin
    Result :=IntToStr(Value) ;
    Result :=FInt(Result, Len) ;
  end;
end;

class function Tnfeutil.FCur(const Value: Currency; const IncCurrency: Boolean): string;
begin
  if IncCurrency then
    Result :=Tnfeutil.FFlt(Value, '$0,00')
  else
    Result :=Tnfeutil.FFlt(Value) ;
end;

class function Tnfeutil.FDat(const Value: TDateTime;
  DatePart: TDatePart; UseLocalBias: Boolean): String;
var
  vTemp: TDateTime;
  F : TFormatSettings;
begin
  if UseLocalBias then
    Result :=sdDateTimeToString(Value, True, True, 0, True)
  else begin
    GetLocaleFormatSettings(0, F);
    F.DateSeparator   := '/';
    F.TimeSeparator   := ':';
    F.ShortDateFormat := 'dd/MM/yyyy';
    F.LongTimeFormat := 'hh:mm:ss';
    case DatePart of
      dpDateTime: Result :=F.ShortDateFormat +' '+F.LongTimeFormat;
      dpDate: Result :=F.ShortDateFormat;
      dpTime: Result :=F.LongTimeFormat;
    end;
    Result :=FormatDateTime(Result, Value, F) ;
  end;
end;

class function Tnfeutil.FFlt(const Value: Extended; const Format: string;
  const Default: Extended): string;
const
  NUMBER_PRECISION = 18;
var
  F: TFormatSettings;
  P, Dig: Integer;
  Decsep: Char ;
  FltFormat: TFloatFormat ;
begin

  P   :=0;
  Dig :=2;

  GetLocaleFormatSettings(0, F);
  if Format<>'' then Result :=Format
  else               Result :='0,00';

  if Format<>'0' then
  begin
    //[.] como separador decimal
    if Pos('.', Result) > Pos(',', Result) then
    begin
      Decsep:='.';
      FltFormat :=ffFixed ;
    end
    //[,] como separador decimal
    else begin
      Decsep:=',';
      FltFormat :=ffNumber ;
      if Pos('$', Result) > 0 then
      begin
        FltFormat :=ffCurrency ;
      end;
    end;

    P :=Pos(Decsep, Result) ;
    if P > 0 then
    begin
      Dig :=Length(Copy(Result, P+1, NUMBER_PRECISION));
    end;

    if Dig <= 0 then
    begin
      Dig :=2;
    end
    end
  else begin
    FltFormat :=ffFixed ;
    Dig :=0;
  end;

  F.DecimalSeparator :=Decsep ;
  F.CurrencyDecimals :=Dig ;
  if Value > 0 then
  begin
    Result :=SysUtils.FloatToStrF(Value, FltFormat, NUMBER_PRECISION, Dig, F) ;
  end
  else
  begin
    Result :=SysUtils.FloatToStrF(Default, FltFormat, NUMBER_PRECISION, Dig, F) ;
  end;
end;

class function Tnfeutil.FInt(const Value: string; const Len: Byte): string;
begin
  Result := PadD(Trim(Value), Len, '0') ;
end;

class function Tnfeutil.FormatDocFiscal(const AValue: String): String;
begin
  if AValue <> '' then
    Result :=FormatMaskText('!000\.000\.000;0; ', AValue)
  else
    Result :='';
end;

class function Tnfeutil.FormatCEP(const AValue: String): String;
begin
  if AValue <> '' then
    Result  :=FormatMaskText('00\.000\-999;0; ', AValue)
  else
    Result  :='';
end;

class function Tnfeutil.FormatCEP(const AValue: Integer): String;
begin
  Result :=FInt(AValue, 8);
  Result :=FormatCEP(Result) ;
end;

class function Tnfeutil.FormatCNPJ(const AValue: String): String;
begin
  if AValue <> '' then
    Result  :=FormatMaskText('!00\.000\.000\/0000\-00;0; ', AValue)
  else
    Result  :='';
end;

class function Tnfeutil.FormatCPF(const AValue: String): String;
begin
  if AValue <> '' then
    Result  :=FormatMaskText('!000\.000\.000\-00;0; ', AValue)
  else
    Result :='';
end;

class function Tnfeutil.FormatDocFiscal(const AValue: Integer): String;
begin
  Result :=Tnfeutil.FInt(AValue, 9);
  Result :=FormatDocFiscal(Result);
end;

class function Tnfeutil.FormatFone(const AValue: String): String;
begin
  case Length(AValue) of
    00: Result  :='';
    10: Result  :=FormatMaskText('!\(99\)0000-0000;0; ', AValue);
    11: Result  :=FormatMaskText('!\(99\)00000-0000;0; ', AValue);
  else
    Result  :=FormatMaskText('!0000-0000;0; ', AValue);
  end;
end;

class function Tnfeutil.FormatFone(const AValue: Integer): String;
begin
  Result :=IntToStr(AValue);
  Result :=FormatFone(Result);
end;

class function Tnfeutil.FormatIE(const AValue, AUF: String): String;
begin
  Result :='';
  if AValue = '' then
  begin
    Exit ;
  end;
  if      AUF='AC' then{AC: 99.99.9999-9    }Result :=FormatMaskText('!00\.00\.0000\-0;0; ', AValue)
  else if AUF='AL' then{AL: 24XNNNNND       }Result :=FormatMaskText('!000000000;0; ', AValue)
  else if AUF='AP' then{AP: 03NNNNNND       }Result :=FormatMaskText('!000000000;0; ', AValue)
  else if AUF='AM' then{AM: 99.999.999-9    }Result :=FormatMaskText('!00\.000\.0000\-0;0; ', AValue)
  else if AUF='BA' then{BA: 999999-99       }Result :=FormatMaskText('!000000\-00;0; ', AValue)
  else if AUF='CE' then{CE: 99999999-9      }Result :=FormatMaskText('!00000000\-0;0; ', AValue)
  else if AUF='DF' then{DF: 999.99999.999-99}Result :=FormatMaskText('!000\.00000\.000\-00;0; ', AValue)
  else if AUF='ES' then{ES: 99999999-9      }Result :=FormatMaskText('!00000000\-0;0; ', AValue)
  else if AUF='GO' then{GO: 99.999.999-9    }Result :=FormatMaskText('!00\.000\.000\-0;0; ', AValue)
  else if AUF='MA' then{MA: 12999999X       }Result :=FormatMaskText('!000000000;0; ', AValue)
  else if AUF='MT' then{MT: 0013000001-9    }Result :=FormatMaskText('!0000000000\-0;0; ', AValue)
  else if AUF='MS' then{MS: 2899999999-9    }Result :=FormatMaskText('!0000000000\-0;0; ', AValue)
  else if AUF='MG' then{MG: 062.307.904/0081}Result :=FormatMaskText('!000\.000\.000\.000\/0000;0; ', AValue)
  else if AUF='PA' then{PA: 15999999-9      }Result :=FormatMaskText('!00000000\-0;0; ', AValue)
  else if AUF='PB' then{PB: 99.999.999-9    }Result :=FormatMaskText('!00\.000\.000\-0;0; ', AValue)
  else if AUF='PE' then{PE: 18.1.001.0000004-9}Result :=FormatMaskText('!00\.0\.000\.0000000\-0;0; ', AValue)
  else if AUF='PI' then{PI: 999999999       }Result :=FormatMaskText('!000000000;0; ', AValue)
  else if AUF='RJ' then{RJ: 99.999.99-9     }Result :=FormatMaskText('!00\.000\.00\-0;0; ', AValue)
  else if AUF='RN' then{RN: 99.999.999-9    }Result :=FormatMaskText('!00\.000\.000\-0;0; ', AValue)
  else if AUF='RS' then{RS: 224/3658792     }Result :=FormatMaskText('!000\/0000000;0; ', AValue)
  else if AUF='RO' then{RO: 999999999       }Result :=FormatMaskText('!000000000;0; ', AValue)
  else if AUF='RR' then{RR: 99999999-9      }Result :=FormatMaskText('!00000000\-0;0; ', AValue)
  else if AUF='SC' then{SC: 999.999.999     }Result :=FormatMaskText('!000\.000\.000;0; ', AValue)
  else if AUF='SP' then
  begin
    if Pos('P', AValue)<>1 then{I : 999.999.999.999 }Result :=FormatMaskText('!000\.000\.000\.000;0; ', AValue)
    else                       {II: P-99999999.9/999}Result :=FormatMaskText('!0\-00000000\.0\/000;0; ', AValue);
  end
  else if AUF='SE' then{SE: 99999999-9      }Result :=FormatMaskText('!00000000\-0;0; ', AValue)
  else if AUF='TO' then{TO: 29 01 022783 6  }Result :=FormatMaskText('!00\ 00\ 000000\ 0;0; ', AValue)
end;

class function Tnfeutil.FormatPlaca(const AValue: String): String;
begin
  if AValue <> '' then
    Result :=FormatMaskText('!LLL\-0000;0; ', AValue)
  else
    Result :='';
end;

class function Tnfeutil.ValidaCEP(const UF, CEP: string): Boolean;
var cd:Integer	;
var s1,s2:string	;
begin
  	s1 :=Trim(CEP)	;
		s1 :=Copy(s1,1,5) + Copy(s1,7,3);
 		cd :=StrToIntDef(Copy(s1,1,3),0);

    s2 :=Trim(CEP)	;
    case Length(s2) of
        0: Result :=True;
        8:
        begin

            if StrToIntDef(s2,0) <= 1000000.0 then
            begin
                Result := False;
            end

            else
            begin
                if Length(Copy(s2,6,3)) < 3 then Result := False
                else if  (UF='SP')and (cd >= 10 ) and (cd <= 199) then Result := True
                else if  (UF='RJ')and (cd >= 200) and (cd <= 289) then Result := True
                else if  (UF='ES')and (cd >= 290) and (cd <= 299) then Result := True
                else if  (UF='MG')and (cd >= 300) and (cd <= 399) then Result := True
                else if  (UF='BA')and (cd >= 400) and (cd <= 489) then Result := True
                else if  (UF='SE')and (cd >= 490) and (cd <= 499) then Result := True
                else if  (UF='PE')and (cd >= 500) and (cd <= 569) then Result := True
                else if  (UF='AL')and (cd >= 570) and (cd <= 579) then Result := True
                else if  (UF='PB')and (cd >= 580) and (cd <= 589) then Result := True
                else if  (UF='RN')and (cd >= 590) and (cd <= 599) then Result := True
                else if  (UF='CE')and (cd >= 600) and (cd <= 639) then Result := True
                else if  (UF='PI')and (cd >= 640) and (cd <= 649) then Result := True
                else if  (UF='MA')and (cd >= 650) and (cd <= 659) then Result := True
                else if  (UF='PA')and (cd >= 660) and (cd <= 688) then Result := True
                else if  (UF='AM')and((cd >= 690) and (cd <= 692) or
                                      (cd >= 694) and (cd <= 698)) then Result := True
                else if  (UF='AP')and (cd = 689) then Result := True
                else if  (UF='RR')and (cd = 693) then Result := True
                else if  (UF='AC')and (cd = 699) then Result := True
                else if ((UF='DF')or(UF='GO')) and (cd >= 000)and(cd <= 999)then Result := True
                else if  (UF='TO')and (cd >= 770) and (cd <= 779) then Result := True
                else if  (UF='MT')and (cd >= 780) and (cd <= 788) then Result := True
                else if  (UF='MS')and (cd >= 790) and (cd <= 799) then Result := True
                else if  (UF='RO')and (cd = 789) then Result := True
                else if  (UF='PR')and (cd >= 800) and (cd <= 879) then Result := True
                else if  (UF='SC')and (cd >= 880) and (cd <= 899) then Result := True
                else if  (UF='RS')and (cd >= 900) and (cd <= 999) then Result := True
                else Result := False	;
            end;
        end;
    else
        Result :=False;
    end;
end;

class function Tnfeutil.ValidaCodMun(const UF: string;
  const CodMun: Integer): Boolean;
var i:Integer;
var c:Integer;
begin
  for i :=0 to UF_IBGE -1 do
  begin
      if COD_IBGE_UF[i].uf_sigla = UF then
      begin
          c :=COD_IBGE_UF[i].uf_codigo;
          Break;
      end;
  end;
  Result := LeftStr(IntToStr(CodMun), 2) = IntToStr(c);
end;

class function Tnfeutil.ValidaCodMun(const CodMun: Integer): Boolean;
const COD_INVALIDO = '4305871;2201919;2202251;2201988;2611533;3117836;3152131;5203939;5203962';
var pro, sum: integer;
var pso, dig: integer;
var s: string;
var i:integer;
begin
    s :=IntToStr(CodMun);
    if Length(s) = 7 then
    begin
        if Pos(s, COD_INVALIDO) = 0 then
        begin
            sum :=0;
            pso :=1;
            for i :=1 to 6 do
            begin
                pro :=StrToInt(s[i]) * pso;
                if pro > 9 then
                    sum :=sum +StrToInt(IntToStr(pro)[1]) + StrToInt(IntToStr(pro)[2])
                else
                    sum :=sum +pro;

                if pso = 1 then
                  pso :=2
                else
                  pso :=1;

            end;
            if (sum mod 10) = 0 then
              dig :=0
            else
              dig :=10 - (sum mod 10);
            Result  :=s[7] = IntToStr(dig)[1];
        end
        else begin
            Result  :=True;
        end;
    end
    else
        Result  :=False;
end;

class function Tnfeutil.ValidaPlaca(const InPlaca: string;
  out OuPlaca: string): Boolean;
var s:string;
var c:Integer;
begin
  s :=Trim(InPlaca);
  for c :=1 to Length(s) do
  begin
      if s[c] in ['A'..'Z', '0'..'9'] then
      begin
          OuPlaca  :=OuPlaca +s[c];
      end;
  end;
  Result  :=(Length(OuPlaca)=7) or (Length(OuPlaca)=0);
end;

class function Tnfeutil.AlignStr(const AString: string; ALen: Integer;
  AChar: Char; Align: TAlignment): string;
var m:integer;
begin
    Result	:= Copy(AString, 1, ALen);
    ALen  	:= ALen - Length(Result);
    if ALen > 0 then
  	begin
        case Align of
            taLeftJustify  :Result :=Result + DupeString(AChar, ALen)	;
            taRightJustify :Result :=DupeString(AChar, ALen) + Result;
            taCenter       :begin
                              m :=Trunc(Alen / 2)	;
                              Result	:=DupeString(AChar, Length(AString))	;
//                              Result  :=StuffString(Result, )
                            end;
        end;
    end;
end;

class function Tnfeutil.Assinar(AXML: String; ACert: ICertificate2; out AOutXML, AOutMsg: String): Boolean;
begin
    Result := AssinarMSXML(AXML, ACert, AOutXML, AOutMsg);
end;

class function Tnfeutil.StringToFloat(AValue: String): Double;
begin
  AValue := Trim( AValue ) ;

  if FormatSettings.DecimalSeparator <> '.' then
     AValue := StringReplace(AValue,'.',FormatSettings.DecimalSeparator,[rfReplaceAll]) ;

  if FormatSettings.DecimalSeparator <> ',' then
     AValue := StringReplace(AValue,',',FormatSettings.DecimalSeparator,[rfReplaceAll]) ;

  Result := StrToFloat(AValue)
end ;

class function Tnfeutil.StringToFloatDef(const AValue: String;
  const DefaultValue: Double): Double;
begin
  try
     Result := StringToFloat( AValue ) ;
  except
     Result := DefaultValue ;
  end ;
end ;

class function Tnfeutil.Ch_Format(const chNFe: string; const Bytes: Integer): string;
begin
  if Bytes = 44 then
    Result :=FormatMaskText('!0000\ 0000\ 0000\ 0000\ 0000\ 0000\ 0000\ 0000\ 0000\ 0000\ 0000;0; ', chNFe)
  else
    Result :=FormatMaskText('!0000\ 0000\ 0000\ 0000\ 0000\ 0000\ 0000\ 0000\ 0000;0; ', chNFe);
end;

class function Tnfeutil.Ch_Valida(const chNFe: string): Boolean;
var
  chv: string;
begin
  Result :=Length(chNFe)=44;
  if Result then
  begin
    chv :=Copy(chNFe, 1, 43);
    Result :=IntToStr(Tnfeutil.Mod11(chv))=chNFe[44];
  end;
end;

class procedure Tnfeutil.ConfAmbiente;
begin
  FormatSettings.DecimalSeparator := ',';
end;

class function Tnfeutil.PathApp: String;
begin
    Result := IncludeTrailingPathDelimiter(
                ExtractFilePath(
                  ParamStr(0)
                  )
                );
end;

class function Tnfeutil.PadC(const AStr: string; const ALen: Integer;
  const AChar: Char): String;
Var nCharLeft : Integer ;
    D : Double;
begin
  Result    := Copy(AStr, 1, ALen) ;
  D         := (ALen - Length(Result)) / 2 ;
  nCharLeft := Trunc(D) ;
  Result    := PadE(StringOfChar(AChar, nCharLeft)+Result, ALen, AChar) ;
end ;

class function Tnfeutil.PadD(const AStr: string; const ALen: Integer;
  const AChar: Char): String;
begin
  Result := Copy(AStr, 1, ALen) ;
  Result := StringOfChar(AChar, (ALen - Length(Result))) + Result ;
end;

class function Tnfeutil.PadE(const AStr: string; const ALen: Integer;
  const AChar: Char): String;
begin
  Result := Copy(AStr, 1, ALen) ;
  Result := Result + StringOfChar(AChar, (ALen - Length(Result))) ;
end;

class function Tnfeutil.ParseText(Texto : AnsiString; Decode : Boolean ) : AnsiString;
begin
  if Decode then
   begin
    Texto := StringReplace(Texto, '&amp;', '&', [rfReplaceAll]);
    Texto := StringReplace(Texto, '&lt;', '<', [rfReplaceAll]);
    Texto := StringReplace(Texto, '&gt;', '>', [rfReplaceAll]);
    Texto := StringReplace(Texto, '&quot;', '"', [rfReplaceAll]);
    Texto := StringReplace(Texto, '&#39;', #39, [rfReplaceAll]);
    Texto := StringReplace(Texto, '&aacute;', 'á', [rfReplaceAll]);
    Texto := StringReplace(Texto, '&Aacute;', 'Á', [rfReplaceAll]);
    Texto := StringReplace(Texto, '&acirc;' , 'â', [rfReplaceAll]);
    Texto := StringReplace(Texto, '&Acirc;' , 'Â', [rfReplaceAll]);
    Texto := StringReplace(Texto, '&atilde;', 'ã', [rfReplaceAll]);
    Texto := StringReplace(Texto, '&Atilde;', 'Ã', [rfReplaceAll]);
    Texto := StringReplace(Texto, '&agrave;', 'à', [rfReplaceAll]);
    Texto := StringReplace(Texto, '&Agrave;', 'À', [rfReplaceAll]);
    Texto := StringReplace(Texto, '&eacute;', 'é', [rfReplaceAll]);
    Texto := StringReplace(Texto, '&Eacute;', 'É', [rfReplaceAll]);
    Texto := StringReplace(Texto, '&ecirc;' , 'ê', [rfReplaceAll]);
    Texto := StringReplace(Texto, '&Ecirc;' , 'Ê', [rfReplaceAll]);
    Texto := StringReplace(Texto, '&iacute;', 'í', [rfReplaceAll]);
    Texto := StringReplace(Texto, '&Iacute;', 'Í', [rfReplaceAll]);
    Texto := StringReplace(Texto, '&oacute;', 'ó', [rfReplaceAll]);
    Texto := StringReplace(Texto, '&Oacute;', 'Ó', [rfReplaceAll]);
    Texto := StringReplace(Texto, '&otilde;', 'õ', [rfReplaceAll]);
    Texto := StringReplace(Texto, '&Otilde;', 'Õ', [rfReplaceAll]);
    Texto := StringReplace(Texto, '&ocirc;' , 'ô', [rfReplaceAll]);
    Texto := StringReplace(Texto, '&Ocirc;' , 'Ô', [rfReplaceAll]);
    Texto := StringReplace(Texto, '&uacute;', 'ú', [rfReplaceAll]);
    Texto := StringReplace(Texto, '&Uacute;', 'Ú', [rfReplaceAll]);
    Texto := StringReplace(Texto, '&uuml;'  , 'ü', [rfReplaceAll]);
    Texto := StringReplace(Texto, '&Uuml;'  , 'Ü', [rfReplaceAll]);
    Texto := StringReplace(Texto, '&ccedil;', 'ç', [rfReplaceAll]);
    Texto := StringReplace(Texto, '&Ccedil;', 'Ç', [rfReplaceAll]);
    Texto := UTF8Decode(Texto);
   end
  else
   begin
    Texto := StringReplace(Texto, '&', '&amp;', [rfReplaceAll]);
    Texto := StringReplace(Texto, '<', '&lt;', [rfReplaceAll]);
    Texto := StringReplace(Texto, '>', '&gt;', [rfReplaceAll]);
    Texto := StringReplace(Texto, '"', '&quot;', [rfReplaceAll]);
    Texto := StringReplace(Texto, #39, '&#39;', [rfReplaceAll]);
    Texto := UTF8Encode(Texto);
   end;

  Result := Texto;
end;


{ TnfeLog }

constructor TnfeLog.Create;
begin
  inherited Create;
  Assign(fBuffer, file_name_log);
  Rewrite(fBuffer);
  WText('Arquivo de log criado.');
end;

destructor TnfeLog.Destroy;
begin
  WText('Arquivo de log fechado.');
  CloseFile(fBuffer);
  inherited Destroy;
end;

function TnfeLog.file_name_log: string;
var yy,mm,dd: Word;
var hh,nn,ss,ms: Word;
begin
    DecodeDateTime(Now, yy, mm, dd, hh, nn, ss, ms);
    Result	:=ExtractFilePath(ParamStr(0))	;
    Result  :=Result + 'nfe.log\'+ Format('%d-%.2d-%.2d',[yy,mm,dd]);
    if not DirectoryExists(Result) then
    begin
      ForceDirectories(Result);
    end;
    Result  :=Result +Format('\%.2d%.2d%.2d%.3d.txt',[hh,nn,ss,ms]);
end;

procedure TnfeLog.WText(const AText: string);
begin
    Writeln(fBuffer, FormatDateTime('hh:nn:ss',Now) +'|'+ AText);
end;

procedure TnfeLog.WText(const AText: string; const Args: array of const);
begin
    Writeln(fBuffer, FormatDateTime('hh:nn:ss',Now) +'|'+Format(AText, Args));
end;

{ Tftp_access }

constructor Tftp_access.Create(	const AHostName: string;
																const AHostPort: Word;
    														const AUserName, APassWord: string);
var
		AppName: string;
begin
  	fConnected :=False	;
    fHostName :=AHostName;
    fHostPort	:=AHostPort;
    fUsername :=AUserName;
    fPassword :=APassword;
		AppName		:=ExtractFileName(ParamStr(0));
		fSession :=InternetOpen(	PChar(AppName),
															INTERNET_OPEN_TYPE_PRECONFIG,
															nil, nil, 0);
		if Assigned(fSession) then
    begin
        fConnect := InternetConnect(fSession,
                                    PChar(fHostName),
                                    fHostPort,
                                    PChar(fUserName),
                                    PChar(fPassWord),
                                    INTERNET_SERVICE_FTP,
                                    INTERNET_FLAG_PASSIVE,
        														0	);
        fConnected := Assigned(fConnect);
    end;
end ;

function Tftp_access.DeleteFile(const WebName: string): Boolean;
begin

end;

destructor Tftp_access.Destroy;
begin
    if fConnected then
    begin
    		InternetCloseHandle(fConnect);
        fConnected :=False	;
    end;
    if Assigned(fSession) then
    begin
    		InternetCloseHandle(fSession);
    end;
  	inherited Destroy;
end;

function Tftp_access.FileSize(const WebName: string): Integer;
var
		f: HINTERNET;
begin
    Result := -1;
    if fConnected then
    begin
        f := FtpOpenFile(	fConnect,
        									Pchar(WebName),
        									GENERIC_READ,
        									FTP_TRANSFER_TYPE_BINARY,
        									0);
        if Assigned(f) then
        try
        		Result := FtpGetFileSize(f, nil);
        finally
        		InternetClosehandle(f);
        end;
    end;
end;

function Tftp_access.GetDir: string;
var
		buffer: array[0..MAX_PATH] of char;
		bfsize: cardinal;
begin
    Result	:='';
    if fConnected then
    begin
    		FillChar(buffer, MAX_PATH, 0);
    		bfSize := MAX_PATH;
    		if FtpGetCurrentDirectory(fConnect, buffer, bfSize) then
        begin
    				Result := buffer;
        end;
    end;
end;

function Tftp_access.GetFile(const WebName: string): string;
begin

end;

function Tftp_access.PutFile(const Source, RemoteName: string): Boolean;
begin

end;

function Tftp_access.SetDir(const WebDir: string): Boolean;
begin
    Result := fConnected and
							FtpSetCurrentDirectory(fConnect, PChar(WebDir));
end;

{ Tsmtp_access }

constructor Tsmtp_access.Create(const hostname: string;
                                const hostport: Word;
                                const usermail, username, userpass: string;
                                const SupportsTLS: Boolean);
begin

    fsmtp_host	:=hostname	;
    fsmtp_port	:=hostport	;
    fsmtp_mail	:=usermail	;
    fsmtp_user	:=username	;
    fsmtp_pass	:=userpass	;

    if SupportsTLS then
    begin
        fIdAntiFreeze :=TIdAntiFreeze.Create(nil);

        fIdSSLIOHandlerSocketOpenSSL	:=TIdSSLIOHandlerSocketOpenSSL.Create(nil);
        fIdSSLIOHandlerSocketOpenSSL.Destination	:=Format('%s:%d',[fsmtp_host,fsmtp_port]);
        fIdSSLIOHandlerSocketOpenSSL.Host         :=fsmtp_host;
        fIdSSLIOHandlerSocketOpenSSL.Port					:=fsmtp_port;

        fIdSSLIOHandlerSocketOpenSSL.SSLOptions.Method	:=sslvTLSv1; // sslvSSLv2;
        fIdSSLIOHandlerSocketOpenSSL.SSLOptions.Mode		:=sslmUnassigned;
        fIdSSLIOHandlerSocketOpenSSL.SSLOptions.VerifyMode	:=[];
        fIdSSLIOHandlerSocketOpenSSL.SSLOptions.VerifyDepth	:=0;

        fIdSMTP           :=TIdSMTP.Create(nil);
        fIdSMTP.IOHandler :=fIdSSLIOHandlerSocketOpenSSL;
        fIdSMTP.UseTLS    :=utUseExplicitTLS;
    end
    else
    begin
        fIdSMTP   :=TIdSMTP.Create(nil);
    end;

    {$IFDEF D15UP}
    fIdSMTP.AuthType  :=satDefault;
    {$ELSE}
		fIdSMTP.AuthType  :=satDefault; //atDefault;
    {$ENDIF}

//    fIdSMTP.ConnectTimeout:=10000;
    fIdSMTP.ReadTimeout		:=10000;
    fIdSMTP.Host       :=fsmtp_host;
    fIdSMTP.Port       :=fsmtp_port;
    fIdSMTP.Username   :=fsmtp_user;
    fIdSMTP.Password   :=fsmtp_pass;

    try
        fIdSMTP.Connect();
        fConnected		:=fIdSMTP.Connected()	;
    except
        on E:EIdException do
        begin
        		fConnected	:=False;
          	fErrorMsg		:=Format('Não foi possível conectar no servidor SMTP(%s:%d)!'#13#10'%s',
                          [fsmtp_host,fsmtp_port,E.Message]);
        end;

        on E:Exception do
        begin
        		fConnected	:=False;
          	fErrorMsg		:=Format('Não foi possível conectar no servidor SMTP(%s:%d)!'#13#10'%s',
                          [fsmtp_host,fsmtp_port,E.Message]);
        end;
    end;
end;

destructor Tsmtp_access.Destroy;
begin
    if fConnected then
    begin
        fIdSMTP.Disconnect(True);
    end;
    fIdSMTP.Destroy ;
    if Assigned(fIdAntiFreeze) then
    begin
        fIdAntiFreeze.Destroy	;
        fIdSSLIOHandlerSocketOpenSSL.Destroy	;
    end;
  	inherited Destroy;
end;


function Tsmtp_access.Send(const mail_typmime: TmailTypMIME): Boolean;
var msg:TIdMessage;
var attc:TIdAttachmentFile;
var text:TIdText;
var i:Integer;
var f:string;
		//
    function GetTypMIME(TypMIME: TmailTypMIME): string;
    begin
        case TypMIME of
            mttextplain:Result :='text/plain';
            mttexthtml :Result :='text/html';
            mttextrtf :Result :='text/richtext';
            mttextxaiff :Result :='text/x-aiff';
            mtaudiobasic :Result :='audio/basic';
            mtaudiowav :Result :='audio/wav';
            mtimagegif :Result :='image/gif';
            mtimagejpeg :Result :='image/jpeg';
            mtimagepjpeg :Result :='image/pjpeg';
            mtimagetiff :Result :='image/tiff';
            mtimagexpng :Result :='image/x-png';
            mtimagexxbmp :Result :='image/x-xbitmap';
            mtimagebmp :Result :='image/bmp';
            mtimagexjg :Result :='image/x-jg';
            mtimagexemf :Result :='image/x-emf';
            mtimagexwmf :Result :='image/x-wmf';
            mtvideoavi :Result :='video/avi';
            mtvideompeg :Result :='video/mpeg';
            mtapppostscript :Result :='application/postscript';
            mtappbase64 :Result :='application/base64';
            mtappmacbinhex40 :Result :='application/macbinhex40';
            mtapppdf :Result :='application/pdf';
            mtappxcompress :Result :='application/x-compressed';
            mtappxzipcompress :Result :='application/x-zip-compressed';
            mtappxgzipcompress :Result :='application/x-gzip-compressed';
            mtappjava :Result :='application/java';
            mtappxmsdownload :Result :='application/x-msdownload';
            mtappoctetstream :Result :='application/octet-stream';
            mtmultipartmixed :Result :='multipart/mixed';
            mtmultipartrelative :Result :='multipart/relative';
            mtmultipartdigest :Result :='multipart/digest';
            mtmultipartalternative :Result :='multipart/alternative';
            mtmultipartrelated :Result :='multipart/related';
            mtmultipartreport :Result :='multipart/report';
            mtmultipartsigned :Result :='multipart/signed';
            mtmultipartencrypted :Result :='multipart/encrypted';
        end;
    end;
    //
begin

    Result :=False ;
    msg	:=TIdMessage.Create(nil);
    try
      	//msg.Clear;
        msg.IsEncoded					:=True;
        msg.AttachmentEncoding:='MIME';
        msg.Encoding 					:=meMIME; // meDefault;
        msg.ConvertPreamble 	:=True;
        msg.Priority 					:=mpNormal;
        msg.ContentType 			:='multipart/mixed'; // obrigatoriamente!
        msg.CharSet 					:='ISO-8859-1';

        msg.Date 				:=Now;

        msg.Organization:=fmail_name;

        msg.From.Address            :=fsmtp_mail;
        msg.From.Text               :=fmail_name;
        msg.ReplyTo.EMailAddresses  :=fsmtp_mail;

        msg.Recipients.EMailAddresses:=fmail_dest;

        msg.Subject                  :=fmail_subj;

        text	:=TIdText.Create(msg.MessageParts, nil);
        text.ContentType 				:=GetTypMIME(mail_typmime);
        text.ContentDescription :='multipart-1';
        text.CharSet 						:='ISO-8859-1'; // NOSSA LINGUAGEM PT-BR (Latin-1)!!!!
        text.ContentTransfer 		:='16bit';			// ACENTUADO !!! Pois, 8bit SAI SEM ACENTO !!!
        text.Body.Clear;
        text.Body.Add(fmail_text);

        for i :=0 to High(mail_files) do
        begin
            f :=mail_files[i].filename ;
            if FileExists(f) then
            begin
                attc							:=TIdAttachmentFile.Create(msg.MessageParts, f);
                attc.ContentType	:=GetTypMIME(mail_files[i].typmime) +';';
            end;
        end;

        if fConnected then
        begin
        		fIdSMTP.HeloName	:=fsmtp_helo;
            try
                fIdSMTP.Authenticate() ;
                fIdSMTP.Send(msg) ;
                Result :=True ;
            except
                on E:EidSMTPReplyError do
                begin
                    Result :=False ;
                    fErrorMsg :=Format('%d-%s',[E.ErrorCode, E.Message]);
                end;
                on E:EIdException do
                begin
                    Result:=False;
                    fErrorMsg :=e.Message;
                end;
            end;
        end;

    finally
        FreeAndNil(msg);
    end;
end;


{ TnfeString }

procedure TnfeString.WriteStr(const S: string);
var
  L: Integer;
begin
  L :=Length(S);
  if L > 0 then WriteBuffer(S[1], L);
end;

procedure TnfeString.WriteStr(const S: string; Args: array of const);
begin
  WriteStr(Format(S, Args));
end;


{$REGION 'TnfeConfig'}

class procedure TnfeConfig.DoLoad;
var
  R: TsdElement;
  N: TXmlNode;
begin
  try
    fInstance.LoadFromFile(getFileName);

    R :=fInstance.Root;
    fInstance.tpAmb       :=R.ReadInteger('typAmb', 1);
    fInstance.tpEmi       :=R.ReadInteger('typEmi', 0);
    fInstance.IncCadBai   :=R.ReadBool('incCadBai'    );
    fInstance.lotePorCarga:=R.ReadBool('lotePorCarga' );
    fInstance.localnfe    :=R.ReadString('localnfe'   );
    fInstance.localschema :=R.ReadString('localschema');
    fInstance.emisNFe     :=R.ReadBool('emisNFe', False);
    fInstance.saveXML     :=R.ReadBool('saveXML', False);
    fInstance.ProcessSinc :=R.ReadBool('ProcessSinc', False);

    N :=R.NodeFindOrCreate('emit');
    fInstance.emit.codigo   :=N.ReadInteger('codigo');
    fInstance.emit.rzSoci		:=N.ReadString('rzSoci');
    fInstance.emit.CNPJ	:=N.ReadString('CNPJ');
    fInstance.emit.IE   :=N.ReadString('IE');
    fInstance.emit.ufCodigo	:=N.ReadInteger('ufCodigo');
    fInstance.emit.ufSigla	:=N.ReadString('ufSigla');
    fInstance.emit.logo			:=N.ReadString('logo');
    fInstance.emit.IdToken	:=N.ReadString('IdToken', '000001');
    fInstance.emit.consNFCe	:=N.ReadString('consNFCe');

    N :=R.NodeFindOrCreate('cert');
    fInstance.cert.SerialNumber :=N.ReadString('serialNumber');
    fInstance.cert.SubjectName	:=N.ReadString('subjectName');
    fInstance.cert.ValidFromDate:=N.ReadDateTime('ValidFromDate');
    fInstance.cert.ValidToDate	:=N.ReadDateTime('ValidToDate');

    N :=R.NodeFindOrCreate('DANFe');
    fInstance.danfe.saida   :=N.ReadInteger('saida'   );
    fInstance.danfe.copias  :=N.ReadInteger('copias'  );
    fInstance.danfe.printer :=N.ReadString('printer'  );
    fInstance.danfe.local   :=N.ReadString('local'    );
    fInstance.danfe.msg_cf  :=N.ReadBool	('msg_cf'   );
    fInstance.danfe.sendmail:=N.ReadBool	('sendmail' );

    N :=R.NodeFindOrCreate('justCont');
    fInstance.conting.DataHora :=N.ReadDateTime('datahora');
    fInstance.conting.Justifica:=N.ReadString  ('justifica');

    N :=R.NodeFindOrCreate('MDFe');
    fInstance.MDFe.tpAmb :=N.ReadInteger('tpAmb', 2);
    fInstance.MDFe.tpEmit:=N.ReadInteger('tpEmit', 2);
    fInstance.MDFe.tpEmis:=N.ReadInteger('tpEmis', 2);
    fInstance.MDFe.sermdf:=N.ReadInteger('sermdf', 1);
    fInstance.MDFe.localmdfe  :=N.ReadString('localmdfe');
    fInstance.MDFe.localschema:=N.ReadString('localschema');
    fInstance.MDFe.saveXML:=N.ReadBool('saveXML');

    N :=R.NodeFindOrCreate('NFCe');
    fInstance.NFCe.tpAmb      :=N.ReadInteger('tpAmb', 1);
    fInstance.NFCe.tpEmi      :=N.ReadInteger('tpEmi', 0);
    fInstance.NFCe.dhCont     :=N.ReadDateTime('dhCont');
    fInstance.NFCe.xCont      :=N.ReadString  ('xCont');
    fInstance.NFCe.IdToken	  :=N.ReadString('IdToken', '000001');
    fInstance.NFCe.localschema:=N.ReadString('localschema');
    fInstance.NFCe.saveXML    :=N.ReadBool('saveXML', False);
    fInstance.NFCe.useNFCe    :=N.ReadBool('useNFCe', False);

  except
  end;
end;

class procedure TnfeConfig.DoSave;
var
  R: TsdElement;
  N: TXmlNode;
begin

  R :=fInstance.Root;
  R.WriteInteger('typAmb'       , fInstance.tpAmb   );
  R.WriteInteger('typEmi'       , fInstance.tpEmi   );
  R.WriteBool   ('incCadBai'    , fInstance.IncCadBai    );
  R.WriteBool   ('lotePorCarga' , fInstance.lotePorCarga );
  R.WriteString ('localnfe'     , fInstance.localnfe     );
  R.WriteString ('localschema'  , fInstance.localschema  );
  R.WriteBool   ('emisNFe'      , fInstance.emisNFe      );
  R.WriteBool   ('saveXML'      , fInstance.saveXML      );
  R.WriteBool   ('ProcessSinc'  , fInstance.ProcessSinc  );

  N :=R.NodeByName('emit');
  N.WriteInteger('codigo'   , fInstance.emit.codigo   );
  N.WriteString ('rzSoci'   , fInstance.emit.rzSoci   );
  N.WriteString ('CNPJ'     , fInstance.emit.CNPJ     );
  N.WriteString ('IE'       , fInstance.emit.IE       );
  N.WriteInteger('ufCodigo' , fInstance.emit.ufCodigo );
  N.WriteString ('ufSigla'  , fInstance.emit.ufSigla  );
  N.WriteString ('logo'     , fInstance.emit.logo     );
  N.WriteString ('IdToken'  , fInstance.emit.IdToken  );
  N.WriteString ('consNFCe'  , fInstance.emit.consNFCe);

  N	:=R.NodeByName('cert');
  N.WriteString('serialNumber'    , fInstance.cert.SerialNumber );
  N.WriteString('subjectName'     , fInstance.cert.SubjectName  );
  N.WriteDateTime('ValidFromDate' , fInstance.cert.ValidFromDate);
  N.WriteDateTime('ValidToDate'   , fInstance.cert.ValidToDate  );

  N :=R.NodeByName('DANFe');
  N.WriteInteger('saida' 	  , fInstance.danfe.saida   );
  N.WriteInteger('copias'   , fInstance.danfe.copias  );
  N.WriteString	('printer'  ,	fInstance.danfe.printer );
  N.WriteString	('local'    ,	fInstance.danfe.local   );
  N.WriteBool		('msg_cf'   , fInstance.danfe.msg_cf  );
  N.WriteBool		('sendmail' , fInstance.danfe.sendmail);

  N :=R.NodeByName('justCont');
  N.WriteDateTime('datahora' , fInstance.conting.DataHora  );
  N.WriteString  ('justifica', fInstance.conting.Justifica );

  N :=R.NodeByName('MDFe');
  N.WriteInteger('tpAmb', fInstance.MDFe.tpAmb);
  N.WriteInteger('tpEmit', fInstance.MDFe.tpEmit);
  N.WriteInteger('tpEmis', fInstance.MDFe.tpEmis);
  N.WriteInteger('sermdf', fInstance.MDFe.sermdf);
  N.WriteString('localmdfe', fInstance.MDFe.localmdfe);
  N.WriteString('localschema', fInstance.MDFe.localschema);
  N.WriteBool('saveXML', fInstance.MDFe.saveXML);

  N :=R.NodeByName('NFCe');
  N.WriteInteger('tpAmb'       , fInstance.NFCe.tpAmb   );
  N.WriteInteger('tpEmi'       , fInstance.NFCe.tpEmi   );
  N.WriteDateTime('dhCont' , fInstance.NFCe.dhCont  );
  N.WriteString  ('xCont', fInstance.NFCe.xCont );
  N.WriteString ('IdToken'      , fInstance.NFCe.IdToken  );
  N.WriteString ('localschema'  , fInstance.NFCe.localschema  );
  N.WriteBool   ('saveXML'      , fInstance.NFCe.saveXML      );
  N.WriteBool   ('useNFCe'      , fInstance.NFCe.useNFCe      );

  fInstance.SaveToFile(getFileName);

end;

class procedure TnfeConfig.freeInstance;
begin
  fInstance.DoSave ;
  fInstance.Destroy;
end;

class function TnfeConfig.GetCertificado: ICertificate2;
var
  Store        : IStore3;
  Certs        : ICertificates2;
  Cert         : ICertificate2;
  I: Integer;
begin

  Result  :=nil;
  Store   :=CoStore.Create;
  Store.Open(CAPICOM_CURRENT_USER_STORE, 'My', CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED);

  Certs :=Store.Certificates as ICertificates2;
  for I :=1 to Certs.Count do
  begin

    OleCheck(IDispatch(Certs.Item[I]).QueryInterface(ICertificate2, Cert));
    if Cert.SerialNumber = fInstance.cert.SerialNumber then
    begin
      Result :=Cert;
      Break;
    end;
  end;

  if not(Assigned(Result)) then
    raise Exception.Create('Certificado Digital não encontrado!');

end;

class function TnfeConfig.getFileName: string;
begin
  Result  :=ExtractFilePath(ParamStr(0));
  Result  :=ExcludeTrailingPathDelimiter(Result) +'\config\nfe';
  if not DirectoryExists(Result) then
  begin
    ForceDirectories(Result) ;
  end;
  Result  :=Format('%s\sistema_nfe.xml', [Result]);
end;

class function TnfeConfig.getInstance: TnfeConfig;
begin
  if fInstance = nil then
  begin
    fInstance :=TnfeConfig.CreateName('AppConfig');
    fInstance.XmlFormat :=xfReadable;
    if not FileExists(getFileName) then
    begin
      DoSave();
    end ;
    DoLoad();
  end ;
  Result :=fInstance ;
end;

class function TnfeConfig.SelCertificado: Boolean;
var
  Store : IStore3;
  Certs : ICertificates2;
  Certs2: ICertificates2;
  Cert  : ICertificate2;

begin
  Result :=False;
  Store :=CoStore.Create;
  Store.Open(CAPICOM_CURRENT_USER_STORE, 'My', CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED);

  Certs   :=Store.Certificates as ICertificates2;
  Certs2  :=Certs.Select('Certificado(s) Digital(is) disponível(is)', 'Selecione o certificado digital para uso no aplicativo', false);
  if not(Certs2.Count = 0) then
  begin
    Cert :=IInterface(Certs2.Item[1]) as ICertificate2;
    fInstance.cert.SerialNumber  :=Cert.SerialNumber;
    fInstance.cert.SubjectName   :=Cert.SubjectName;
    fInstance.cert.ValidFromDate :=Cert.ValidFromDate;
    fInstance.cert.ValidToDate   :=Cert.ValidToDate;
    Result :=True;
  end;
  Store :=nil;
  Certs :=nil;
  Certs2:=nil;
end;

{$ENDREGION}


{ TmdfeConfig }

procedure TmdfeConfig.Create;
begin
  tpAmb :=2;
  tpEmit:=2;
  tpEmis:=2;
  sermdf:=1;
  localmdfe:='';
  localschema:='';
  saveXML :=False;
end;


{ TNativeXmlHlp }

constructor TNativeXmlHlp.Create;
begin
  inherited Create(nil);

end;

procedure TNativeXmlHlp.SaveToFile(const ALocal, AFileName: string);
var
  F: string ;
begin
  if (ALocal<>'') and DirectoryExists(ALocal) then
  begin
    F :=ExcludeTrailingPathDelimiter(ALocal) ;
    F :=F +'\'+ AFileName ;
  end
  else
    F :=AFileName ;
  Self.SaveToFile(F);
end;

class function TNativeXmlHlp.SaveXmlToFile(const xml_format,
  file_name: string): Boolean;
var
  dir: string;
var
  xmlDoc: TNativeXml;
  D: string;
begin

    dir :=ExtractFilePath(file_name);
    Result :=DirectoryExists(dir) ;

    if Result then
    begin

        xmlDoc :=TNativeXml.Create() ;

        try

          xmlDoc.XmlFormat    :=xfReadable;
          xmlDoc.VersionString:=cDefaultVersionString;
          xmlDoc.Charset      :=cDefaultEncodingString;

          try

            xmlDoc.ReadFromString(UTF8String(xml_format));

//            if xmlDoc.Declaration = nil then
//            begin
              D :=Format('<?xml version="%s" encoding="%s"?>',[
                cDefaultVersionString,
                cDefaultEncodingString]) ;
              xmlDoc.ReadFromString(UTF8String(D + xml_format));
//            end;

            xmlDoc.SaveToFile(file_name);
            Result :=True;

          except
            Result :=False ;
          end;

        finally
            xmlDoc.Free;
        end;
    end;
end;


{ TXmlNodeHlp }

procedure TXmlNodeHlp.AttributeAdd(const AName: UTF8String; AValue: integer);
begin
  AttributeAdd(AName, UTF8String(IntToStr(AValue)));

end;

function TXmlNodeHlp.ReadTime(const AName: string): TDateTime;
begin
  Result	:=StrToTimeDef(Self.ReadString(AName), 0) ;

end;

procedure TXmlNodeHlp.WriteDate(const AName: string; const AValue: TDateTime;
  const UseTime, UseLocalBias: Boolean);
begin
    Self.WriteString( AName,
                      sdDateTimeToString(AValue, True, UseTime, Document.SplitSecondDigits,
                                         UseLocalBias));
end;

procedure TXmlNodeHlp.WriteFloat(const AName: string; const AValue: Double;
  const ADig: Byte);
var f:TFormatSettings;
var v:string;
begin
  if ADig > 0 then
    v :='0.'+DupeString('0', ADig)
  else
    v :='0';

  f.DecimalSeparator:='.';
  f.CurrencyFormat  :=ADig;
  v :=FormatFloat(v, AValue, f);
  Self.WriteString(AName, v);

end;

procedure TXmlNodeHlp.WriteTime(const AName: string; const AValue: TDateTime);
begin
  Self.WriteString(AName, FormatDateTime('HH:NN:SS', AValue));

end;


{** TDCP_hash *****************************************************************}

procedure TDCP_hash.DeadInt(Value: integer);
begin
end;

procedure TDCP_hash.DeadStr(Value: string);
begin
end;

function TDCP_hash._GetId: integer;
begin
  Result:= GetId;
end;

function TDCP_hash._GetAlgorithm: string;
begin
  Result:= GetAlgorithm;
end;

function TDCP_hash._GetHashSize: integer;
begin
  Result:= GetHashSize;
end; 

class function TDCP_hash.GetId: integer;
begin
  Result:= -1;
end;

class function TDCP_hash.GetAlgorithm: string;
begin
  Result:= '';
end;

class function TDCP_hash.GetHashSize: integer;
begin
  Result:= -1;
end;

class function TDCP_hash.SelfTest: boolean;
begin
  Result:= false;
end;

procedure TDCP_hash.Init;
begin
end;

procedure TDCP_hash.Final(var Digest);
begin
end;

procedure TDCP_hash.Burn;
begin
end;

procedure TDCP_hash.Update(const Buffer; Size: longword);
begin
end;

procedure TDCP_hash.UpdateStream(Stream: TStream; Size: longword);
var
  Buffer: array[0..8191] of byte;
  i, read: integer;
begin
  FillChar(Buffer, SizeOf(Buffer), 0);
  for i:= 1 to (Size div Sizeof(Buffer)) do
  begin
    read:= Stream.Read(Buffer,Sizeof(Buffer));
    Update(Buffer,read);
  end;
  if (Size mod Sizeof(Buffer))<> 0 then
  begin
    read:= Stream.Read(Buffer,Size mod Sizeof(Buffer));
    Update(Buffer,read);
  end;
end;

procedure TDCP_hash.UpdateStr(const Str: AnsiString);
begin
  Update(Str[1],Length(Str));
end;

{$IFDEF UNICODE}
procedure TDCP_hash.UpdateStr(const Str: UnicodeString);
begin
  Update(Str[1],Length(Str)*Sizeof(Str[1]));
end; { DecryptString }
{$ENDIF}

destructor TDCP_hash.Destroy;
begin
  if fInitialized then
    Burn;
  inherited Destroy;
end;



{ TDCP_sha1 }

procedure TDCP_sha1.Compress;
var
  A, B, C, D, E: DWord;
  W: array[0..79] of DWord;
  i: longword;
begin
  Index:= 0;
  FillChar(W, SizeOf(W), 0);
  Move(HashBuffer,W,Sizeof(HashBuffer));
  for i:= 0 to 15 do
    W[i]:= SwapDWord(W[i]);
  for i:= 16 to 79 do
    W[i]:= ((W[i-3] xor W[i-8] xor W[i-14] xor W[i-16]) shl 1) or ((W[i-3] xor W[i-8] xor W[i-14] xor W[i-16]) shr 31);
  A:= CurrentHash[0]; B:= CurrentHash[1]; C:= CurrentHash[2]; D:= CurrentHash[3]; E:= CurrentHash[4];

  Inc(E,((A shl 5) or (A shr 27)) + (D xor (B and (C xor D))) + $5A827999 + W[ 0]); B:= (B shl 30) or (B shr 2);
  Inc(D,((E shl 5) or (E shr 27)) + (C xor (A and (B xor C))) + $5A827999 + W[ 1]); A:= (A shl 30) or (A shr 2);
  Inc(C,((D shl 5) or (D shr 27)) + (B xor (E and (A xor B))) + $5A827999 + W[ 2]); E:= (E shl 30) or (E shr 2);
  Inc(B,((C shl 5) or (C shr 27)) + (A xor (D and (E xor A))) + $5A827999 + W[ 3]); D:= (D shl 30) or (D shr 2);
  Inc(A,((B shl 5) or (B shr 27)) + (E xor (C and (D xor E))) + $5A827999 + W[ 4]); C:= (C shl 30) or (C shr 2);
  Inc(E,((A shl 5) or (A shr 27)) + (D xor (B and (C xor D))) + $5A827999 + W[ 5]); B:= (B shl 30) or (B shr 2);
  Inc(D,((E shl 5) or (E shr 27)) + (C xor (A and (B xor C))) + $5A827999 + W[ 6]); A:= (A shl 30) or (A shr 2);
  Inc(C,((D shl 5) or (D shr 27)) + (B xor (E and (A xor B))) + $5A827999 + W[ 7]); E:= (E shl 30) or (E shr 2);
  Inc(B,((C shl 5) or (C shr 27)) + (A xor (D and (E xor A))) + $5A827999 + W[ 8]); D:= (D shl 30) or (D shr 2);
  Inc(A,((B shl 5) or (B shr 27)) + (E xor (C and (D xor E))) + $5A827999 + W[ 9]); C:= (C shl 30) or (C shr 2);
  Inc(E,((A shl 5) or (A shr 27)) + (D xor (B and (C xor D))) + $5A827999 + W[10]); B:= (B shl 30) or (B shr 2);
  Inc(D,((E shl 5) or (E shr 27)) + (C xor (A and (B xor C))) + $5A827999 + W[11]); A:= (A shl 30) or (A shr 2);
  Inc(C,((D shl 5) or (D shr 27)) + (B xor (E and (A xor B))) + $5A827999 + W[12]); E:= (E shl 30) or (E shr 2);
  Inc(B,((C shl 5) or (C shr 27)) + (A xor (D and (E xor A))) + $5A827999 + W[13]); D:= (D shl 30) or (D shr 2);
  Inc(A,((B shl 5) or (B shr 27)) + (E xor (C and (D xor E))) + $5A827999 + W[14]); C:= (C shl 30) or (C shr 2);
  Inc(E,((A shl 5) or (A shr 27)) + (D xor (B and (C xor D))) + $5A827999 + W[15]); B:= (B shl 30) or (B shr 2);
  Inc(D,((E shl 5) or (E shr 27)) + (C xor (A and (B xor C))) + $5A827999 + W[16]); A:= (A shl 30) or (A shr 2);
  Inc(C,((D shl 5) or (D shr 27)) + (B xor (E and (A xor B))) + $5A827999 + W[17]); E:= (E shl 30) or (E shr 2);
  Inc(B,((C shl 5) or (C shr 27)) + (A xor (D and (E xor A))) + $5A827999 + W[18]); D:= (D shl 30) or (D shr 2);
  Inc(A,((B shl 5) or (B shr 27)) + (E xor (C and (D xor E))) + $5A827999 + W[19]); C:= (C shl 30) or (C shr 2);

  Inc(E,((A shl 5) or (A shr 27)) + (B xor C xor D) + $6ED9EBA1 + W[20]); B:= (B shl 30) or (B shr 2);
  Inc(D,((E shl 5) or (E shr 27)) + (A xor B xor C) + $6ED9EBA1 + W[21]); A:= (A shl 30) or (A shr 2);
  Inc(C,((D shl 5) or (D shr 27)) + (E xor A xor B) + $6ED9EBA1 + W[22]); E:= (E shl 30) or (E shr 2);
  Inc(B,((C shl 5) or (C shr 27)) + (D xor E xor A) + $6ED9EBA1 + W[23]); D:= (D shl 30) or (D shr 2);
  Inc(A,((B shl 5) or (B shr 27)) + (C xor D xor E) + $6ED9EBA1 + W[24]); C:= (C shl 30) or (C shr 2);
  Inc(E,((A shl 5) or (A shr 27)) + (B xor C xor D) + $6ED9EBA1 + W[25]); B:= (B shl 30) or (B shr 2);
  Inc(D,((E shl 5) or (E shr 27)) + (A xor B xor C) + $6ED9EBA1 + W[26]); A:= (A shl 30) or (A shr 2);
  Inc(C,((D shl 5) or (D shr 27)) + (E xor A xor B) + $6ED9EBA1 + W[27]); E:= (E shl 30) or (E shr 2);
  Inc(B,((C shl 5) or (C shr 27)) + (D xor E xor A) + $6ED9EBA1 + W[28]); D:= (D shl 30) or (D shr 2);
  Inc(A,((B shl 5) or (B shr 27)) + (C xor D xor E) + $6ED9EBA1 + W[29]); C:= (C shl 30) or (C shr 2);
  Inc(E,((A shl 5) or (A shr 27)) + (B xor C xor D) + $6ED9EBA1 + W[30]); B:= (B shl 30) or (B shr 2);
  Inc(D,((E shl 5) or (E shr 27)) + (A xor B xor C) + $6ED9EBA1 + W[31]); A:= (A shl 30) or (A shr 2);
  Inc(C,((D shl 5) or (D shr 27)) + (E xor A xor B) + $6ED9EBA1 + W[32]); E:= (E shl 30) or (E shr 2);
  Inc(B,((C shl 5) or (C shr 27)) + (D xor E xor A) + $6ED9EBA1 + W[33]); D:= (D shl 30) or (D shr 2);
  Inc(A,((B shl 5) or (B shr 27)) + (C xor D xor E) + $6ED9EBA1 + W[34]); C:= (C shl 30) or (C shr 2);
  Inc(E,((A shl 5) or (A shr 27)) + (B xor C xor D) + $6ED9EBA1 + W[35]); B:= (B shl 30) or (B shr 2);
  Inc(D,((E shl 5) or (E shr 27)) + (A xor B xor C) + $6ED9EBA1 + W[36]); A:= (A shl 30) or (A shr 2);
  Inc(C,((D shl 5) or (D shr 27)) + (E xor A xor B) + $6ED9EBA1 + W[37]); E:= (E shl 30) or (E shr 2);
  Inc(B,((C shl 5) or (C shr 27)) + (D xor E xor A) + $6ED9EBA1 + W[38]); D:= (D shl 30) or (D shr 2);
  Inc(A,((B shl 5) or (B shr 27)) + (C xor D xor E) + $6ED9EBA1 + W[39]); C:= (C shl 30) or (C shr 2);

  Inc(E,((A shl 5) or (A shr 27)) + ((B and C) or (D and (B or C))) + $8F1BBCDC + W[40]); B:= (B shl 30) or (B shr 2);
  Inc(D,((E shl 5) or (E shr 27)) + ((A and B) or (C and (A or B))) + $8F1BBCDC + W[41]); A:= (A shl 30) or (A shr 2);
  Inc(C,((D shl 5) or (D shr 27)) + ((E and A) or (B and (E or A))) + $8F1BBCDC + W[42]); E:= (E shl 30) or (E shr 2);
  Inc(B,((C shl 5) or (C shr 27)) + ((D and E) or (A and (D or E))) + $8F1BBCDC + W[43]); D:= (D shl 30) or (D shr 2);
  Inc(A,((B shl 5) or (B shr 27)) + ((C and D) or (E and (C or D))) + $8F1BBCDC + W[44]); C:= (C shl 30) or (C shr 2);
  Inc(E,((A shl 5) or (A shr 27)) + ((B and C) or (D and (B or C))) + $8F1BBCDC + W[45]); B:= (B shl 30) or (B shr 2);
  Inc(D,((E shl 5) or (E shr 27)) + ((A and B) or (C and (A or B))) + $8F1BBCDC + W[46]); A:= (A shl 30) or (A shr 2);
  Inc(C,((D shl 5) or (D shr 27)) + ((E and A) or (B and (E or A))) + $8F1BBCDC + W[47]); E:= (E shl 30) or (E shr 2);
  Inc(B,((C shl 5) or (C shr 27)) + ((D and E) or (A and (D or E))) + $8F1BBCDC + W[48]); D:= (D shl 30) or (D shr 2);
  Inc(A,((B shl 5) or (B shr 27)) + ((C and D) or (E and (C or D))) + $8F1BBCDC + W[49]); C:= (C shl 30) or (C shr 2);
  Inc(E,((A shl 5) or (A shr 27)) + ((B and C) or (D and (B or C))) + $8F1BBCDC + W[50]); B:= (B shl 30) or (B shr 2);
  Inc(D,((E shl 5) or (E shr 27)) + ((A and B) or (C and (A or B))) + $8F1BBCDC + W[51]); A:= (A shl 30) or (A shr 2);
  Inc(C,((D shl 5) or (D shr 27)) + ((E and A) or (B and (E or A))) + $8F1BBCDC + W[52]); E:= (E shl 30) or (E shr 2);
  Inc(B,((C shl 5) or (C shr 27)) + ((D and E) or (A and (D or E))) + $8F1BBCDC + W[53]); D:= (D shl 30) or (D shr 2);
  Inc(A,((B shl 5) or (B shr 27)) + ((C and D) or (E and (C or D))) + $8F1BBCDC + W[54]); C:= (C shl 30) or (C shr 2);
  Inc(E,((A shl 5) or (A shr 27)) + ((B and C) or (D and (B or C))) + $8F1BBCDC + W[55]); B:= (B shl 30) or (B shr 2);
  Inc(D,((E shl 5) or (E shr 27)) + ((A and B) or (C and (A or B))) + $8F1BBCDC + W[56]); A:= (A shl 30) or (A shr 2);
  Inc(C,((D shl 5) or (D shr 27)) + ((E and A) or (B and (E or A))) + $8F1BBCDC + W[57]); E:= (E shl 30) or (E shr 2);
  Inc(B,((C shl 5) or (C shr 27)) + ((D and E) or (A and (D or E))) + $8F1BBCDC + W[58]); D:= (D shl 30) or (D shr 2);
  Inc(A,((B shl 5) or (B shr 27)) + ((C and D) or (E and (C or D))) + $8F1BBCDC + W[59]); C:= (C shl 30) or (C shr 2);

  Inc(E,((A shl 5) or (A shr 27)) + (B xor C xor D) + $CA62C1D6 + W[60]); B:= (B shl 30) or (B shr 2);
  Inc(D,((E shl 5) or (E shr 27)) + (A xor B xor C) + $CA62C1D6 + W[61]); A:= (A shl 30) or (A shr 2);
  Inc(C,((D shl 5) or (D shr 27)) + (E xor A xor B) + $CA62C1D6 + W[62]); E:= (E shl 30) or (E shr 2);
  Inc(B,((C shl 5) or (C shr 27)) + (D xor E xor A) + $CA62C1D6 + W[63]); D:= (D shl 30) or (D shr 2);
  Inc(A,((B shl 5) or (B shr 27)) + (C xor D xor E) + $CA62C1D6 + W[64]); C:= (C shl 30) or (C shr 2);
  Inc(E,((A shl 5) or (A shr 27)) + (B xor C xor D) + $CA62C1D6 + W[65]); B:= (B shl 30) or (B shr 2);
  Inc(D,((E shl 5) or (E shr 27)) + (A xor B xor C) + $CA62C1D6 + W[66]); A:= (A shl 30) or (A shr 2);
  Inc(C,((D shl 5) or (D shr 27)) + (E xor A xor B) + $CA62C1D6 + W[67]); E:= (E shl 30) or (E shr 2);
  Inc(B,((C shl 5) or (C shr 27)) + (D xor E xor A) + $CA62C1D6 + W[68]); D:= (D shl 30) or (D shr 2);
  Inc(A,((B shl 5) or (B shr 27)) + (C xor D xor E) + $CA62C1D6 + W[69]); C:= (C shl 30) or (C shr 2);
  Inc(E,((A shl 5) or (A shr 27)) + (B xor C xor D) + $CA62C1D6 + W[70]); B:= (B shl 30) or (B shr 2);
  Inc(D,((E shl 5) or (E shr 27)) + (A xor B xor C) + $CA62C1D6 + W[71]); A:= (A shl 30) or (A shr 2);
  Inc(C,((D shl 5) or (D shr 27)) + (E xor A xor B) + $CA62C1D6 + W[72]); E:= (E shl 30) or (E shr 2);
  Inc(B,((C shl 5) or (C shr 27)) + (D xor E xor A) + $CA62C1D6 + W[73]); D:= (D shl 30) or (D shr 2);
  Inc(A,((B shl 5) or (B shr 27)) + (C xor D xor E) + $CA62C1D6 + W[74]); C:= (C shl 30) or (C shr 2);
  Inc(E,((A shl 5) or (A shr 27)) + (B xor C xor D) + $CA62C1D6 + W[75]); B:= (B shl 30) or (B shr 2);
  Inc(D,((E shl 5) or (E shr 27)) + (A xor B xor C) + $CA62C1D6 + W[76]); A:= (A shl 30) or (A shr 2);
  Inc(C,((D shl 5) or (D shr 27)) + (E xor A xor B) + $CA62C1D6 + W[77]); E:= (E shl 30) or (E shr 2);
  Inc(B,((C shl 5) or (C shr 27)) + (D xor E xor A) + $CA62C1D6 + W[78]); D:= (D shl 30) or (D shr 2);
  Inc(A,((B shl 5) or (B shr 27)) + (C xor D xor E) + $CA62C1D6 + W[79]); C:= (C shl 30) or (C shr 2);

  CurrentHash[0]:= CurrentHash[0] + A;
  CurrentHash[1]:= CurrentHash[1] + B;
  CurrentHash[2]:= CurrentHash[2] + C;
  CurrentHash[3]:= CurrentHash[3] + D;
  CurrentHash[4]:= CurrentHash[4] + E;
  FillChar(W,Sizeof(W),0);
  FillChar(HashBuffer,Sizeof(HashBuffer),0);
end;

class function TDCP_sha1.Execute(const Buffer: string): string;
var
  sha1: TDCP_sha1;
  Digest:array of Byte;
  I: Byte ;
begin
  sha1 :=TDCP_sha1.Create ;
  try
    try
      sha1.Init ;
      sha1.UpdateStr(Buffer);
      SetLength(Digest, sha1.HashSize div 8);
      sha1.Final(Digest[0]);
      for I :=0 to Length(Digest) -1 do
      begin
        Result  :=Result + IntToHex(Digest[I], 2);
      end;
    except
      on E:EDCP_hash do
      begin
        Result :=E.Message ;
      end;
    end;
  finally
    sha1.Free ;
  end;
end;

class function TDCP_sha1.GetAlgorithm: string;
begin
  Result:= 'SHA1';
end;

class function TDCP_sha1.GetID: integer;
begin
  Result:= DCP_sha1;
end;

class function TDCP_sha1.GetHashSize: integer;
begin
  Result:= 160;
end;

class function TDCP_sha1.SelfTest: boolean;
const
  Test1Out: array[0..19] of byte=
    ($A9,$99,$3E,$36,$47,$06,$81,$6A,$BA,$3E,$25,$71,$78,$50,$C2,$6C,$9C,$D0,$D8,$9D);
  Test2Out: array[0..19] of byte=
    ($84,$98,$3E,$44,$1C,$3B,$D2,$6E,$BA,$AE,$4A,$A1,$F9,$51,$29,$E5,$E5,$46,$70,$F1);
var
  TestHash: TDCP_sha1;
  TestOut: array[0..19] of byte;
begin
  FillChar(TestOut, SizeOf(TestOut), 0);
  TestHash:= TDCP_sha1.Create;
  TestHash.Init;
  TestHash.UpdateStr(AnsiString('abc'));
  TestHash.Final(TestOut);
  Result:= boolean(CompareMem(@TestOut,@Test1Out,Sizeof(Test1Out)));
  TestHash.Init;
  TestHash.UpdateStr(AnsiString('abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq'));
  TestHash.Final(TestOut);
  Result:= boolean(CompareMem(@TestOut,@Test2Out,Sizeof(Test2Out))) and Result;
  TestHash.Free;
end;

procedure TDCP_sha1.Init;
begin
  Burn;
  CurrentHash[0]:= $67452301;
  CurrentHash[1]:= $EFCDAB89;
  CurrentHash[2]:= $98BADCFE;
  CurrentHash[3]:= $10325476;
  CurrentHash[4]:= $C3D2E1F0;
  fInitialized:= true;
end;

procedure TDCP_sha1.Burn;
begin
  LenHi:= 0; LenLo:= 0;
  Index:= 0;
  FillChar(HashBuffer,Sizeof(HashBuffer),0);
  FillChar(CurrentHash,Sizeof(CurrentHash),0);
  fInitialized:= false;
end;

procedure TDCP_sha1.Update(const Buffer; Size: longword);
var
  PBuf: ^byte;
begin
  if not fInitialized then
    raise EDCP_hash.Create('Hash not initialized');

  Inc(LenHi,Size shr 29);
  Inc(LenLo,Size*8);
  if LenLo< (Size*8) then
    Inc(LenHi);

  PBuf:= @Buffer;
  while Size> 0 do
  begin
    if (Sizeof(HashBuffer)-Index)<= DWord(Size) then
    begin
      Move(PBuf^,HashBuffer[Index],Sizeof(HashBuffer)-Index);
      Dec(Size,Sizeof(HashBuffer)-Index);
      Inc(PBuf,Sizeof(HashBuffer)-Index);
      Compress;
    end
    else
    begin
      Move(PBuf^,HashBuffer[Index],Size);
      Inc(Index,Size);
      Size:= 0;
    end;
  end;
end;

procedure TDCP_sha1.Final(var Digest);
begin
  if not fInitialized then
    raise EDCP_hash.Create('Hash not initialized');
  HashBuffer[Index]:= $80;
  if Index>= 56 then
    Compress;
  PDWord(@HashBuffer[56])^:= SwapDWord(LenHi);
  PDWord(@HashBuffer[60])^:= SwapDWord(LenLo);
  Compress;
  CurrentHash[0]:= SwapDWord(CurrentHash[0]);
  CurrentHash[1]:= SwapDWord(CurrentHash[1]);
  CurrentHash[2]:= SwapDWord(CurrentHash[2]);
  CurrentHash[3]:= SwapDWord(CurrentHash[3]);
  CurrentHash[4]:= SwapDWord(CurrentHash[4]);
  Move(CurrentHash,Digest,Sizeof(CurrentHash));
  Burn;
end;

//initialization
//  LocalConfigNFe :=TnfeConfig.getInstance ;

//finalization
//  LocalConfigNFe.freeInstance ;

end.
