{*************************************************************************}
{ Nota Fiscal Eletronica (NF-e) 2G                                        }
{ Copyright (C), 1995-2013, todos os direitos reservados                  }
{ Unidade reponsavel para a geração do XML                                }
{ Autor: Carlos Gonzaga                                                   }
{*************************************************************************}
{ Historico	  Descrição
* ==========	============================================================
* 12.07.2013  Ajustes para suportar o modelo (65) da NFC-e
* 25.05.2013  Nota Tecnica 2013.003 Lei da Transparência dos Tributos
*             Federais, Estaduais e Municipais
* 03.02.2012  Nota Tecnica 005
* 16.02.2011	Versão 2.0 (PL_006a - compatível com o Manual de Integração
*             do Contribuinte v4.0.1 (03/11/2009))
* 01.09.2008	Versão inicial (PL_005a - compatível com o Manual de Integração
*             do Contribuinte v2.0.2 (10/07/2007))
*}
unit unfexml;

interface

{$REGION 'Uses'}
uses
    Windows  ,
    Messages ,
    SysUtils ,
    Variants ,
    Classes  ,
    NativeXml,
    unfeutil
    ,ucapicom
    ;

{$ENDREGION}

{$REGION 'TNFe (Tipo Nota Fiscal Eletrônica)'}
type
  TNFe = class;
  TnfeProduto = class;
  TnfeICMS = class;
  TnfeIPI = class;
  TnfeII = class;
  TnfePIS = class;
  TnfePISST = class;
  TnfeCOFINS = class;
  TnfeCOFINSST = class;
  TnfeImposto = class;
  TnfeDet = class;

  {Indicador da forma de pagamento:
    0-pagamento à vista;
    1-pagamento à prazo;
    2-outros.}
  TnfeIndPagto = (pgAVis,pgAPrz,pgOut);

  {Grupo obrigatório para a NFC-e}
  TnfeFormPagto = (fpDinheiro=1,
    fpCheque  =2,
    fpCrtCre  =3,
    fpCrtDeb  =4,
    fpCrtLoja =5,  // 05- Crédito Loja;
    fpValAlimenta=10, // 10- Vale Alimentação;
    fpValRefeicao=11, // 11- Vale Refeição;
    fpValPresente=12, // 12- Vale Presente;
    fpValCombust=13,  // 13- Vale Combustível;
    fpOutros =99      // 99 – Outros.
    );

  {Tipo do Documento Fiscal:
    0 - entrada;
    1 - saída}
  TnfeTypDoc = (docEnt,docSai);

  {Formato de impressão do DANFE}
  TnfeFormDANFE = (fdNone, //Sem geração de DANFE
    fdRetrat =1,  //DANFE normal , Retrato;
    fdPaizgm =2,  //DANFE normal, Paisagem;
    fdSimples=3,  //DANFE Simplificado;
    fdNFCe =4,    //DANFE NFC-e;
    fdSMS  =5     //DANFE NFC-e em mensagem eletrônica.
    );

  {Forma de emissão da NF-e}
  TnfeEmis = (emisNomal ,   //1 - Normal
              emisCon_FS,   //2 - Contingência FS-IA;
              emisCon_SCAN, //3 - Contingência SCAN;
              emisCon_DPEC, //4 - Contingência DPEC;
              emisCon_FSDA, //5 - Contingência FSDA;
              emisCon_SVCAN=6,//6 - Contingência SVC-AN (SEFAZ Virtual de Contingência do AN);
              emisCon_SVCRS=7,//7 - Contingência SVC-RS (SEFAZ Virtual de Contingência do RS);
              emisCon_NFCe=9, //9 - Contingência off-line da NFC-e (as demais opções de contingência são válidas também para a NFC-e);
              //Nota: As opções de contingência 3, 4, 6 e 7 (SCAN, DPEC e SVC)
              //não estão disponíveis no momento atual.
              emisNone=10);

  {Identificação do Ambiente:
    1 - Produção
    2 - Homologação}
  TnfeAmb = (ambPro, ambHom);

  {Finalidade da emissão da NF-e:
    1 - NFe normal
    2 - NFe complementar
    3 - NFe de ajuste}
  TnfeFinali = (finNormal,finCompl,finAjust);

  {Processo de emissão utilizado com a seguinte codificação:
    0 - emissão de NF-e com aplicativo do contribuinte;
    1 - emissão de NF-e avulsa pelo Fisco;
    2 - emissão de NF-e avulsa, pelo contribuinte com seu certificado digital, através do site do Fisco;
    3 - emissão de NF-e pelo contribuinte com aplicativo fornecido pelo Fisco.}
  TnfeProcEmis = (pemiContri,pemiFisco_001,pemiFisco_002,pemiFisco_003);

  {Modalidade do frete
    0- Por conta do emitente;
    1- Por conta do destinatário/remetente;
    2- Por conta de terceiros;
    9- Sem frete (v2.0 01/01/2010).}
  TnfeFret = (freEmit,freDest,freTerc,freNone);

  {Origem da mercadoria:
    0 - Nacional;
    1 - Estrangeira - Importação direta;
    2 - Estrangeira - Adquirida no mercado interno.}
  TnfeOrig = (oriNacional,oriEst_ImportDir,oriEst_AdqMerInt);

  {Código de Regime Tributário.}
  TnfeCodRegTrib = (
     crtSimples=1,     //1 – Simples Nacional;
     crtSimplesExcRB=2,//2 – Simples Nacional – excesso de sublimite de receita bruta;
     crtNormal=3       //3 – Regime Normal. (v2.0)
     );

  {Identificação de Operação Interna, Interestadual ou com Exterior}
  TnfeIdOpera = (
    opeInt =1,
    opeEst =2,
    opeExt =3) ;

  {Indica operação com Consumidor final}
  TnfeIndOpeFinal = (opfNone, opfFinal);

  {Indicador de presença do comprador no estabelecimento comercial no momento da operação}
  TnfeIndPresCons = (pcNone,//0- Não se aplica (ex, Nota Fiscal complementar ou de ajuste);
    pcPresenca, //1- Operação presencial;
    pcInternet, //2- Operação não presencial, pela Internet;
    pcTeleAtend,//3- Operação não presencial, Teleatendimento;
    pcOutros    //9- Operação não presencial, outros.
    );

  { Modalidade de determinação da BC do ICMS: }
  TnfeModBCIcms = (mbcMargem, //0 - Margem Valor Agregado (%);
    mbcPauta,                 //1 - Pauta (valor);
    mbcPcoTabela,             //2 - Preço Tabelado Máximo (valor);
    mbcVlrOperacao            //3 - Valor da Operação.
    );

  { Modalidade de determinação da BC do ICMS ST: }
  TnfeModBCIcmsST = (
    mbcstPcoTabela,   //  0 - Preço tabelado ou máximo  sugerido;
    mbcstListNegativa,//  1 - Lista Negativa (valor);
    mbcstListPositiva,//  2 - Lista Positiva (valor);
    mbcstListNeutra,  //  3 - Lista Neutra (valor);
    mbcstMargem,      //  4 - Margem Valor Agregado (%);
    mbcstPauta        //  5 - Pauta (valor);
    );

  { Classificação tributaria do ICMS Normal e ST }
  TnfeCSTIcms = (
    cst00,    // 00 - Tributada integralmente;
    cst10=10, // 10 - Tributada e com cobrança do ICMS por substituição tributária;
    cst20=20, // 20 - Com redução de base de cálculo
    cst30=30, // 30 - Isenta ou não tributada e com cobrança do ICMS por substituição tributária;
    cst40=40, // 40 - Isenta;
    cst41=41, // 41 - Não tributada;
    cst50=50, // 50 - Suspensão;
    cst51=51, // 51 - Diferimento (A exigência do preenchimento das informações do ICMS diferido fica à critério de cada UF);
    cst60=60, // 60 - ICMS cobrado anteriormente por substituição tributária;
    cst70=70, // 70 - Com redução de base de cálculo e cobrança do ICMS por substituição tributária;
    cst90=90, // 90 - Outras.
    cstPart10,// não usado
    cstPart90,// não usado
    cstST41);

  TnfeCSOSNIcms = (csosn101, csosn102, csosn103, csosn201, csosn202, csosn203,
    csosn300, csosn400, csosn500, csosn900);

  { Código da Situação Tributária do IPI: }
  TnfeCSTIPI = (ipi00, //00-Entrada com recuperação de crédito
    ipi01=1,  //01-Entrada tributada com alíquota zero
    ipi02=2,  //02-Entrada isenta
    ipi03=3,  //03-Entrada não-tributada
    ipi04=4,  //04-Entrada imune
    ipi05=5,  //05-Entrada com suspensão
    ipi49=49, //49-Outras entradas
    ipi50=50, //50-Saída tributada
    ipi51=51, //51-Saída tributada com alíquota zero
    ipi52=52, //52-Saída isenta
    ipi53=53, //53-Saída não-tributada
    ipi54=54, //54-Saída imune
    ipi55=55, //55-Saída com suspensão
    ipi99=99 //99-Outras saídas
    );

  { Código de Situação Tributária do PIS }
  TnfeCSTPIS = (
    pis01=1,  //01-Operação Tributável - Base de Cálculo = Valor da Operação Alíquota Normal (Cumulativo/Não Cumulativo);
    pis02=2,  //02-Operação Tributável - Base de Calculo = Valor da Operação (Alíquota Diferenciada);
    pis03=3,  //03-Operação Tributável - Base de Calculo = Quantidade Vendida x Alíquota por Unidade de Produto;
    pis04=4,  //04-Operação Tributável - Tributação Monofásica - (Alíquota Zero);
    pis05=5,
    pis06=6,  //06 - Operação Tributável - Alíquota Zero;
    pis07=7,  //07 - Operação Isenta da contribuição;
    pis08=8,  //08 - Operação Sem Incidência da contribuição;
    pis09=9,  //09 - Operação com suspensão da contribuição;
    pis49=49,
    pis50=50, pis51=51, pis52=52, pis53=53, pis54=54, pis55=55, pis56=56,
    pis60=60, pis61=61, pis62=62, pis63=63, pis64=64, pis65=65, pis66=66, pis67=67,
    pis70=70, pis71=71, pis72=72, pis73=73, pis74=74, pis75=75,
    pis98=98,
    pis99=99  //99-Outras Operações.
    );

  { Código de Situação Tributária do COFINS }
  TnfeCSTCOFINS = (
    cof01=1,  //01-Operação Tributável - Base de Cálculo = Valor da Operação Alíquota Normal (Cumulativo/Não Cumulativo);
    cof02=2,  //02-Operação Tributável - Base de Calculo = Valor da Operação (Alíquota Diferenciada);
    cof03=3,  //03-Operação Tributável - Base de Calculo = Quantidade Vendida x Alíquota por Unidade de Produto;
    cof04=4,  //04-Operação Tributável - Tributação Monofásica - (Alíquota Zero);
    cof05=5,
    cof06=6,  //06-Operação Tributável - Alíquota Zero;
    cof07=7,  //07-Operação Isenta da contribuição;
    cof08=8,  //08-Operação Sem Incidência da contribuição;
    cof09=9,  //09-Operação com suspensão da contribuição;
    cof49=49, //49 - Outras Operações de Saída;
    cof50=50, //50-Operação com Direito a Crédito - Vinculada Exclusivamente a Receita Tributada no Mercado Interno;
    cof51=51, //51-Operação com Direito a Crédito – Vinculada Exclusivamente a Receita Não Tributada no Mercado Interno;
    cof52=52, //52-Operação com Direito a Crédito - Vinculada Exclusivamente a Receita de Exportação;
    cof53=53, //53-Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno;
    cof54=54, //54-Operação com Direito a Crédito - Vinculada a Receitas Tributadas no Mercado Interno e de Exportação;
    cof55=55, //55-Operação com Direito a Crédito - Vinculada a Receitas Não-Tributadas no Mercado Interno e de Exportação;
    cof56=56, //56-Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno, e de Exportação;
    cof60=60, //60-Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Tributada no Mercado Interno;
    cof61=61, //61-Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Não-Tributada no Mercado Interno;
    cof62=62, //62-Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita de Exportação;
    cof63=63, //63-Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno;
    cof64=64, //64-Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas no Mercado Interno e de Exportação;
    cof65=65, //65-Crédito Presumido - Operação de Aquisição Vinculada a Receitas Não-Tributadas no Mercado Interno e de Exportação;
    cof66=66, //66-Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno, e de Exportação;
    cof67=67, //67-Crédito Presumido - Outras Operações;
    cof70=70, //70-Operação de Aquisição sem Direito a Crédito;
    cof71=71, //71-Operação de Aquisição com Isenção;
    cof72=72, //72-Operação de Aquisição com Suspensão;
    cof73=73, //73-Operação de Aquisição a Alíquota Zero;
    cof74=74, //74-Operação de Aquisição sem Incidência da Contribuição;
    cof75=75, //75-Operação de Aquisição por Substituição Tributária;
    cof98=98, //98-Outras Operações de Entrada;
    cof99=99  //99-Outras Operações.
    );

  TnfeCodVer = (cv100, cv110, cv200, cv300, cv310) ;


  { Identificação da NF-e }
  Tide = class
  private
  	fnatOp    :string      ;//Descrição da Natureza da Operação (1-60)
    fxJust    :string      ;//Justificativa da entrada em contingência
    fcMod     :Byte  ;
    procedure setnatOp(const Value: string) ;
    procedure setxJust(const Value: string) ;
    procedure setcMod(const Value: Byte);
  public
    cUF      :Byte        ;//Código da UF do emitente do Documento Fiscal. Utilizar a Tabela do IBGE
    cNF      :Integer     ;//Código numérico que compõe a Chave de Acesso. Número aleatório gerado pelo emitente para cada NF-e
    indPag   :TnfeIndPagto;
//    cMod     :string      ;//55=modelo da Nota Fiscal Eletrônica (NF-e), emitida em substituição a Nota Fiscal modelo 1/1A;
                           //65=modelo da NFC-e, utilizada nas vendas a varejo presenciais, onde não for exigida a NF-e por dispositivo legal.
    serie    :Word        ;//Série do Documento Fiscal
    nNF      :Integer     ;//Número do Documento Fiscal
    tpNF     :TnfeTypDoc  ;

    idDest   :TnfeIdOpera ;

    dEmi     :TDateTime   ;//Data de emissão do Documento Fiscal
    dSaiEnt  :TDateTime   ;//Data de saída ou de entrada da mercadoria / produto
    hSaiEnt  :TDateTime   ;//Hora de saída ou de entrada da mercadoria / produto
    cMunFG   :Integer     ;//Código do Município de Ocorrência do Fato Gerador
    tpImp    :TnfeFormDANFE;
    tpEmis   :TnfeEmis    ;
    cDV      :Byte      	;//Digito Verificador da Chave de Acesso da NF-e
    tpAmb    :TnfeAmb     ;
    finNFe   :TnfeFinali  ;

    indFinal: TnfeIndOpeFinal;
    indPres: TnfeIndPresCons;

    procEmi  :TnfeProcEmis;
    verProc  :string      ;//versão do aplicativo utilizado no processo de emissão
    dhCont   :TDateTime   ;//Data e hora de entrada em contingência
//    xJust    :string      ;//Justificativa da entrada em contingência
  public
  	property natOp: string read fnatOp write setnatOp	;
    property xJust: string read fxJust write setxJust	;
    property cMod: Byte read fcMod write setcMod;
    procedure Assign(ide: Tide);
    constructor Create;
    destructor Destroy;override;
  end;

  { Dados do Endereço }
  TEndereco = class
  private
    fxLgr    :string ; // Logradouro
    fnro     :string ; // Numero
    fxCpl    :string ; // Complemento
    fxBairro :string ; // Bairro
    fcMun    :Integer; // Código do município (utilizar a tabela do IBGE), informar 9999999 para operações com o exterior.
    fxMun    :string ; // Nome do município, informar EXTERIOR para operações com o exterior.
    fUF      :string ; // Sigla da UF, informar EX para operações com o exterior.
    fCEP     :string ; // CEP
    fcPais   :Integer; // Código do pais (1058-Brasil)
    fxPais   :string ; // Nome do pais
    ffone    :string ; // Telefone
    procedure SetxLgr(Value: string) ;
    procedure SetxCpl(Value: string) ;
    procedure SetxBairro(Value: string) ;
    procedure SetcMun(Value: Integer) ;
    procedure SetxMun(Value: string) ;
    procedure SetUF(Value: string) ;
    procedure Setfone(Value: string) ;
  public
//    codcid  :Integer;
    property xLgr    :string read fxLgr write SetxLgr ;
    property nro     :string read fnro write fnro ;
    property xCpl    :string read fxCpl write SetxCpl ;
    property xBairro :string read fxBairro write SetxBairro ;
    property cMun    :Integer read fcMun write SetcMun ;
    property xMun    :string read fxMun write SetxMun ;
    property UF      :string read fUF write SetUF ;
    property CEP     :string read fCEP write fCEP ;
    property cPais   :Integer read fcPais write fcPais ;
    property xPais   :string read fxPais write fxPais ;
    property fone    :string read ffone write Setfone ;
  public
    procedure Assign(endereco: TEndereco);
    constructor Create;
    destructor Destroy;override;
    function IsNotEmpty: Boolean;
  end;


  { Identificação do emitente }
  Temit = class
  private
    fxNome      :string  ;//Razao social ou nome do emitente
    fxFant      :string  ;//Nome de fantasia
    procedure setxNome(const Value: string);
    procedure setxFant(const Value: string);
  public
    CNPJ       :string      ; {CNPJ do emitente (Em se tratando de emissão de
                               NF-e avulsa pelo Fisco, as informações do remetente
                               serão informadas neste grupo. O CNPJ ou CPF deverão ser
                               informados com os zeros não significativos.)}
    ender      :TEndereco   ;
    IE         :string      ; //Inscrição Estadual
    IEST       :string      ; //Inscricao Estadual do Substituto Tributário

    {Grupo de informações de interesse da Prefeitura}
    IM         :string      ; //Inscrição Municipal
    CNAE       :string      ; //CNAE Fiscal

    CRT       :Integer      ; {Código de Regime Tributário.
                               Este campo será obrigatoriamente preenchido com:
                               1 – Simples Nacional;
                               2 – Simples Nacional – excesso de sublimite de receita bruta;
                               3 – Regime Normal. (v2.0)}
  public
  	property xNome: string read fxNome write setxNome	;
    property xFant:string read fxFant write setxFant	;
    procedure Assign(emit: Temit);
    constructor Create;
    destructor Destroy;override;
  end;

  { Emissão de avulsa, informar os dados do Fisco emitente }
  Tavulsa = class
  public
    CNPJ    :string;  // CNPJ do Órgão emissor
    xOrgao  :string;  // Órgão emitente
    matr    :string;  // Matricula do agente
    xAgente :string;  // Nome do agente
    fone    :string;  // Telefone
    UF      :string;
    nDAR    :string;    //Número do Documento de Arrecadação de Receita
    dEmi    :TDateTime; // Data de emissão do DAR
    vDAR    :Currency;  // Valor Total constante no DAR
    repEmi  :string;    // Repartição Fiscal emitente
    datPag  :TDateTime; // Data de pagamento do DAR
  end;

  { Identificação do Destinatário }
  Tdest = class
  private
    fCNPJ:string;
    fCPF:string;
    fIdExt: string;
    fxNome: string  ;//Razao social ou nome do destinatário
    procedure setCNPJ(const Value: string);
    procedure setCPF(const Value: string);
    procedure setIdExt(const Value: string);
    procedure setxNome(const Value: string);
  public
    ender: TEndereco ;
    IE       :string ;
    email: string ;
    function GetDoc(): string ;
  public
    cod_dest: Integer; //tag não oficial (somente para apresentação na validação)!
    property CNPJ: string read fCNPJ write setCNPJ ;
    property CPF: string read fCPF write setCPF ;
    property idEstrangeiro: string read fIdExt write setIdExt ;
  	property xNome: string read fxNome write setxNome	;
    constructor Create;
    destructor Destroy;override;
    procedure Assign(dest: Tdest);
  end;

  { Dados do Local de Retirada ou Entrega }
  TLocal = class
  public
    CNPJ    :string;
    xLgr    :string;
    nro     :string;
    xCpl    :string;
    xBairro :string;
    cMun    :Byte  ;
    xMun    :string;
    UF      :string;
  end;

  { Medicamentos }
  TnfeMed = class
  public
    nLote :string;
    qLote :Double;
    dFab  :TDateTime;
    dVal  :TDateTime;
    vPMC  :Currency;
    procedure Assign(med: TnfeMed);
  end;

  { Combustíveis líquidos }
  TnfeComb = class
    type
      TCIDE = record // CIDE Combustíveis
      public
        qBCProd: Currency;  //BC do CIDE ( Quantidade comercializada)
        vAliqProd: Currency;//Alíquota do CIDE  (em reais)
        vCIDE: Currency;    //Valor do CIDE
      end;
  public
    cProdANP: Integer; //Código de produto da ANP. codificação de produtos do SIMP (http://www.anp.gov.br)
    CODIF: string;
    qTemp: Currency;
    UFCons: string ; //Sigla da UF de Consumo
    CIDE: TCIDE;
  end;

  { Dados dos produtos e serviços }
  TnfeProduto = class(TPersistent)
  private
  	fxProd   :string ;// Descrição do produto ou serviço
    procedure SetxProd(const Value: string) ;
  public
    cProd   :string    ;{Código do produto ou serviço. Preencher com CFOP caso se
                         trate de itens não relacionados com mercadorias/produto e
                         que o contribuinte não possua codificação própria Formato "CFOP9999"}
    cEAN    :string    ;{GTIN (Global Trade Item Number) do produto, antigo código
                         EAN ou código de barras}
    NCM     :string    ;// Código NCM (8 posições)
    EXTIPI  :string    ;// Código EX TIPI (3 posições)
                        // de Capítulos da NCM. Em caso de serviço, não incluir a TAG
    CFOP    :Integer   ;// Código Fiscal de Operações e Prestações
    uCom    :string    ;// Unidade comercial
    qCom    :Double    ;// Quantidade Comercial
    vUnCom  :Double    ;// Valor unitário de comercialização
    vProd   :Currency  ;// Valor bruto do produto ou serviço
    cEANTrib:string    ;// GTIN (Global Trade Item Number) da unidade tributável,
                        // antigo código EAN ou código de barras
    uTrib   :string    ;// Unidade tributária
    qTrib   :Double    ;// Quantidade tributária
    vUnTrib :Double    ;// Valor unitário de tributação
    vFrete  :Currency  ;// Valor total do frete
    vSeg  	:Currency  ;// Valor total do seguro
    vDesc   :Currency  ;// Valor total do desconto
    vOutro  :Currency  ;// Outras despesas acessórias
    indTot	:Byte			 ;{Este campo deverá ser preenchido com:
                         0 – o valor do item (vProd) compõe o valor total da NF-e (vProd)
                         1 – o valor do item (vProd) não compõe o valor}

    xPed: string ;     //Informação de interesse do emissor
    nItemPed: Integer ;//para controle do B2B. (v2.0)

    med: TnfeMed;
    comb: TnfeComb;
  public
    property xProd: string read fxProd write SetxProd;
    constructor Create(AOwner: TnfeDet);
    destructor Destroy;override;
  end;

  //ICMS Normal e ST
  TnfeICMS = class(TPersistent)
  public
    orig: TnfeOrig ;            //N11   Origem da mercadoria
    CST: TnfeCSTIcms;           //N12   Tributação do ICMS
    CSOSN: TnfeCSOSNIcms;       //N12a
    modBC: TnfeModBCIcms;       //N13   Modalidade de determinação da BC do ICMS
    pRedBC: currency;           //N14   Percentual de redução da BC
    vBC: currency;              //N15   Valor da BC do ICMS
    pICMS: currency;            //N16   Alíquota do ICMS
    vICMS: currency;            //N17   Valor do ICMS
    modBCST: TnfeModBCIcmsST;   //N18   Modalidade de determinação da BC do ICMS ST
    pMVAST: currency;           //N19   % da Margem de Valor Adicionado ICMS ST
    pRedBCST: currency;         //N20   % de redução da BC ICMS ST
    vBCST: currency;            //N21   Valor da BC do ICMS ST
    pICMSST: currency;          //N22   Alíquota do ICMS ST
    vICMSST: currency;          //N23   Valor do ICMS ST
    UFST: string;               //N24   UF para qual é devido o ICMS ST
    pBCOp: currency;            //N25   Percentual da BC operação própria
    vBCSTRet: currency;         //N26   Valor da BC do ICMS Retido Anteriormente
    vICMSSTRet: currency;       //N27   Valor do ICMS Retido Anteriormente
    motDesICMS: Byte;           //N28   Motivo da desoneração do ICMS
    pCredSN: currency;          //N29
    vCredICMSSN: currency;      //N30
    vBCSTDest: currency;        //N31   Valor da BC do ICMS ST da UF destino
    vICMSSTDest: currency;      //N32   Valor do ICMS ST da UF destino
  end;

  TnfeIPI = class(TPersistent)
  public
    clEnq: string;
    CNPJProd: string;
    cSelo: string;
    qSelo: integer;
    cEnq: string;
    CST: TnfeCSTIpi;
    vBC: currency;
    qUnid: currency;
    vUnid: currency;
    pIPI: currency;
    vIPI: currency;
  end;

  TnfeII = class(TPersistent)
  public
    vBc: currency;
    vDespAdu: currency;
    vII: currency;
    vIOF: currency;
  end;

  TnfePIS = class(TPersistent)
  public
    CST: TnfeCSTPis;
    vBC: currency;
    pPIS: currency;
    vPIS: currency;
    qBCProd: currency;
    vAliqProd: currency;
  end;

  TnfePISST = class(TPersistent)
  public
    vBc: currency;
    pPis: currency;
    qBCProd: currency;
    vAliqProd: currency;
    vPIS: currency;
  end;

  TnfeCOFINS = class(TPersistent)
  public
    CST: TnfeCSTCofins;
    vBC: currency;
    pCOFINS: currency;
    vCOFINS: currency;
    vBCProd: currency;
    vAliqProd: currency;
    qBCProd: currency;
  end;

  TnfeCOFINSST = class(TPersistent)
  public
    vBC: currency;
    pCOFINS: currency;
    qBCProd: currency;
    vAliqProd: currency;
    vCOFINS: currency;
  end;

  { Tributos incidentes nos produtos ou serviços da NF-e }
  TnfeImposto = class(TPersistent)
  public
    vTotTrib: Currency;//Valor estimado total de impostos federais, estaduais e municipais
    ICMS: TnfeICMS;
    IPI: TnfeIPI;
    II: TnfeII;
    PIS: TnfePIS;
    PISST: TnfePISST;
    COFINS: TnfeCOFINS;
    COFINSST: TnfeCOFINSST;
  public
    constructor Create(AOwner: TnfeDet);
    destructor Destroy; override;
  end;

  TnfeDet = class(TCollectionItem)
  private
    FinfAdProd: string;
    procedure SetinfAdProd(const Value: string) ;
  public
    prod: TnfeProduto;
    imposto: TnfeImposto;
    property infAdProd: string read FinfAdProd write SetinfAdProd;
    constructor Create; reintroduce;
    destructor Destroy; override;
  end;

  TnfeDets = class(TCollection)
  private
    function Get(Index: Integer): TnfeDet;
  public
    property Items[Index: Integer]: TnfeDet read Get;
    constructor Create(AOwner: TNFe);
    function Add: TnfeDet;
  end;

  {Totais referentes ao ICMS}
  TICMSTot = class
  private
  	Owner: TNFe;
  private
    FvBC     :Currency;   // BC do ICMS
    FvICMS   :Currency;   // Valor Total do ICMS
    FvBCST   :Currency;   // BC do ICMS ST
    FvST     :Currency;   // Valor Total do ICMS ST
    FvProd   :Currency;   // Valor Total dos produtos e serviços
    FvFrete  :Currency;   // Valor Total do Frete
    FvSeg    :Currency;   // Valor Total do Seguro
    FvDesc   :Currency;   // Valor Total do Desconto
    FvII     :Currency;   // Valor Total do II
    FvIPI    :Currency;   // Valor Total do IPI
    FvPIS    :Currency;   // Valor do PIS
    FvCOFINS :Currency;   // Valor do COFINS
    FvOutro  :Currency;   // Outras Despesas acessórias
    FvNF     :Currency;   // Valor Total da NF-e

    FvTotTrib:Currency;   // Valor estimado dos impostos...

  public
    property vBC     :Currency  read FvBC 	  write FvBC ;
    property vICMS   :Currency  read FvICMS   write FvICMS ;
    property vBCST   :Currency  read FvBCST   write FvBCST ;
    property vST     :Currency  read FvST 	  write FvST ;
    property vProd   :Currency  read FvProd   write FvProd ;
    property vFrete  :Currency  read FvFrete  write FvFrete ;
    property vSeg    :Currency  read FvSeg 	  write FvSeg ;
    property vDesc   :Currency  read FvDesc   write FvDesc ;
    property vII     :Currency  read FvII 	  write FvII ;
    property vIPI    :Currency  read FvIPI 	  write FvIPI ;
    property vPIS    :Currency  read FvPIS 	  write FvPIS;
    property vCOFINS :Currency  read FvCOFINS write FvCOFINS ;
    property vOutro  :Currency  read FvOutro 	write FvOutro ;
    property vNF     :Currency  read FvNF     write FvNF ;
    property vTotTrib:Currency  read FvTotTrib 	write FvTotTrib ;
  public
    constructor Create(AOwner: TNFe); reintroduce;
    procedure DoReCalc();
  end;

  {totais opcionais}
  //TISSQNtot = class;
  //TretTrib = class;

  {Dados do transportador}
  Ttransporta = class
  private
    fCNPJ :string; // CNPJ do transportador
    fCPF  :string; // CPF do transportador
    fxNome     :string; // Razão Social ou nome
    fxEnder    :string; // Endereço completo
    fxMun      :string; // Nome do munícipio
    procedure setCnpj(const Value: string) ;
    procedure setCpf(const Value: string) ;
    procedure setxNome(const Value: string) ;
    procedure setxEnder(const Value: string) ;
    procedure setxMun(const Value: string) ;
  public
    IE        :string; // Inscrição Estadual
    UF        :string; // Sigla da UF
    property CNPJ: string read fCNPJ write setCnpj  ;
    property CPF: string read fCPF write setCpf  ;
    property xNome: string read fxNome write setxNome	;
    property xEnder:string read fxEnder write setxEnder;
    property xMun:string read fxMun write setxMun;
  public
    function IsNotEmpty(): Boolean;
  end;

  {Dados do veículo}
  Tveiculo = class
  public
    placa : string;
    UF    : string;
    RNTC  : string; {Registro Nacional de Transportador de Carga (ANTT)}
  end;

  {Dados dos volumes}
  TvolList = class;
  Tvol = class
  private
    Index   :Integer;
    CParent :TvolList;
  public
    qVol  : Integer;
    esp   : string;
    marca : string;
    nVol  : string;
    pesoL : Currency;
    pesoB : Currency;
  end;

  TvolList = class(TList)
  private
    function Get(index: Integer):Tvol;
  public
    function Add:Tvol;
    function IndexOf(index: Integer):Tvol;
    property Items[index: Integer]:Tvol read Get;
  end;

  { Dados dos transportes da NF-e }
  Ttransp = class
  public
    modFrete  :TnfeFret;
    transporta  :Ttransporta;
    veicTransp  :Tveiculo;
    vol         :Tvol;
    constructor Create;
    destructor  Destroy;override;
  end;

  { Dados da fatura }
  Tfat  = class
  public
    nFat  :string   ; // numero da fatura
    vOrig :Currency ; // Valor original da fatura
    vDesc :Currency ; // Valor do desconto
    vLiq  :Currency ; // Valor liquido da fatura
  end;

  { Dados das duplicatas }
  TdupList = class(TList)
  type  Tdup = class
        private
          Index   :Integer;
          CParent :TdupList;
        public
          nDup  :string   ; // numero da duplicata
          dVenc :TDateTime; // data de vencimento
          vDup  :Currency ; // Valor da duplicata
          // info adicionais
          age_codigo:Integer;
          age_descri:string;
        end;
  private
    function Get(Index: Integer):Tdup;
  public
    function Add:Tdup;
    function IndexOf(nDup: string):Tdup;
    property Items[index: Integer]:Tdup read Get;
  end;

  { Dados da cobrança da NF-e }
  Tcobr = class
  public
    fat :Tfat;
    dup :TdupList;
    constructor Create;
    destructor  Destroy;override;
  end;

  { Grupo de Cartões }
  TCardBand = (bandVISA=1,//01 - VISA;
    bandMaster    =2, //02 - Mastercard;
    bandAmerican  =3, //03 - American Express;
    bandSorocred  =4, //04 - Sorocred;
    bandOutros    =99 //99 – Outros.
    );
  TCard = record
    CNPJ: string ;//CNPJ da Credenciadora de cartão de crédito/débito
    Band: TCardBand ;
    cAut: string; //Número de autorização da operação cartão de crédito e/ou débito
  end;

  { Grupo de Formas de Pagamento }
  TnfePgto = class
    tPag: TnfeFormPagto ;
    vPag: Currency ;
    card: TCard ;
  end;
  TnfePgtos = class(TList)
  private
    Owner: TNFe;
    function Get(Index: Integer): TnfePgto;
  public
    property Items[index: Integer]: TnfePgto read Get;
    function Add(): TnfePgto; overload ;
    constructor Create(AOwner: TNFe);
  end;

  { Informações adicionais da NF-e }
  TobsContList =class(TList)
  type  TobsCont = class
        private
          Index   :Integer;
        public
          xCampo: string;
          xTexto: string;
        end;
  private
    function Get(Index: Integer):TobsCont;
  public
    function Add: TobsCont;
    property Items[index: Integer]: TobsCont read Get;
  end;

  TinfAdic = class
  private
    finfAdFisco: string;
    finfCpl    : string;
    procedure setinfAdFisco(const Value: string) ;
    procedure setinfCpl(const Value: string) ;
  public
    obsCont   : TobsContList;
    property infAdFisco: string read finfAdFisco 	write setinfAdFisco;
    property infCpl    : string read finfCpl			write setinfCpl;
    constructor Create;
    destructor  Destroy;override;
  end;

  { Informações da Nota Fiscal eletrônica }
  TNFe = class(TPersistent)
  private
    Fversao  :string;
    FId: string ;
    Fide     :Tide;
    Femit    :Temit;
    Favulsa  :Tavulsa;
    Fdest    :Tdest;
    Fretirada:TLocal;
    Fentrega :TLocal;
    Fdet     :TnfeDets; //Tdet;
    Ftotal   :TICMSTot;
    Ftransp  :Ttransp;
    Fcobr    :Tcobr;
    Fpag     :TnfePgtos;
    FinfAdic :TinfAdic;
    FXML     :string;
    function GetId: string;
    function GetXML: string;
    function GetSegCodBar: string ;
    procedure SetXML(const Value: string);

  protected
    const HOM_CNPJ='99999999000191';
    const HOM_NOME='NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL';
    const QTD_CASAS_DEC_VUNIT=6 ;

  protected
    FDocXML :TNativeXml;  // Doc XML

  public
    const MOD_55 =55;
    const MOD_65 =65;
    const SER_DOC =000 ;

    const COD_GEN_NCM =98 ;

    const COD_DON_ENVIO=88  ; //NF-e bem formatada/assinada e pronto para envio
    const COD_PEN_RETORNO=99; //NF-e pendente de retorno

    const COD_AUT_USO_NFE=100; //Autorizado o uso da NF-e
    const COD_CAN_HOM_NFE=101; //Cancelamento de NF-e homologado
    const COD_INU_HOM_NFE=102; //Inutilização de número homologado
    const COD_LOT_REC_SUCESS=103; //Lote recebido com sucesso
    const COD_LOT_PROCESS=104; //Lote processado
    const COD_SERV_OPER=107; //Serviço em operação
    const COD_SERV_INOPER=108; //Serviço Paralisado Momentaneamente (curto prazo)
    const COD_SERV_STOP=109; //Serviço Paralisado sem Previsão
    const COD_DEN_USO_NFE=110;	//Uso Denegado
    const COD_DEN_USO_EMIT=301;	//Uso Denegado: Irregularidade fiscal do emitente
    const COD_DEN_USO_DEST=302;	//Uso Denegado: Irregularidade fiscal do destinatário
    const COD_REJ_DUPLI_NFE=204;
    const COD_REJ_XML_MAU_FORMADO=215;
    const COD_REJ_FALHA_SCHEMA_XML=225;

  public
    class function GetTpEmis(const tpEmis: TnfeEmis): string;
  public

    constructor Create();
    destructor  Destroy; override;

  	procedure Clear;
    function Assinar(Cert: ICertificate2; out retMsg: String): Boolean;
    function Validar(out codStt: Integer; out motStt: String; const localSchema: string =''): Boolean;
    function LoadFromFile(const file_name: String; out ret_msg: String): Integer;

    property versao   :string   read Fversao;
    //property Id       :string   read GetId      ;
    property Id       :string   read FId      write FId     ;
    property ide      :Tide     read Fide       write Fide      ;
    property emit     :Temit    read Femit      write Femit     ;
    property avulsa   :Tavulsa  read Favulsa    write Favulsa   ;
    property dest     :Tdest    read Fdest      write Fdest     ;
    property retirada :TLocal   read Fretirada  write Fretirada ;
    property entrega  :TLocal   read Fentrega   write Fentrega  ;
//    property det      :Tdet     read Fdet       write Fdet      ;
    property det      :TnfeDets read Fdet       write Fdet      ;
    property total    :TICMSTot read Ftotal     write Ftotal    ;
    property transp   :Ttransp  read Ftransp    write Ftransp   ;
    property cobr     :Tcobr    read Fcobr      write Fcobr     ;
    property pag      :TnfePgtos read Fpag      write Fpag      ;
    property infAdic  :TinfAdic read FinfAdic   write FinfAdic  ;
  public
    property XML			:string 	read GetXML 		write SetXML	;
    property SegCodBar:string   read GetSegCodBar      ;
  end;

{$ENDREGION}

{$REGION 'TprotNFe (Tipo Protocolo de status resultado do processamento da NF-e)'}
type
//  TprotNFe = class
//  public
//    versao: string;
//  end;

  TBaseRetorno = class
  public
    versao: string;
    tpAmp   :TnfeAmb;
    verAplic:string;
    cStat   :Integer;
    xMotivo :string;
    cUF: Word;
    dhRecbto:TDateTime;
  end;

  { Dados do protocolo de status }
  //TinfProt = class (TprotNFe)
  TinfProt = class
  private
    Index   :Integer;
  public
    versao: string ;
    tpAmp   :TnfeAmb;
    verAplic:string;
    chNFe   :string;
    dhRecbto:TDateTime;
    nProt   :string;
    digVal  :string;
    cStat   :Integer;
    xMotivo :string;
  end;

  { Retorno do Pedido de Consulta do Recido do Lote de NF-e }
  TretConsReciNFe = class (TList)
  private
    function Get(Index: Integer): TinfProt;
  public
    tpAmp   :TnfeAmb;
    verAplic:string;
    nRec    :string;
    cStat   :Integer;
    xMotivo :string;
    cUF     :Integer;
  public
    property Items[index: Integer]: TinfProt read Get;
    function CreateNew: TinfProt;
    function IndexOfKey(const Key: String): TinfProt;
  end;

{$ENDREGION}

{$REGION 'TnfeProc (NF-e processada)'}
type
  TnfeProc = class
  private
    Fversao :string   ;
    FNFe    :TNFe     ;
    FProtNFe:TinfProt ;
  public
    property  versao :string    read Fversao;
    constructor Create (NFe: TNFe; ProtNFe:TinfProt);
    destructor Destroy;override;
    function Execute (APath: string): Boolean	;
  end;
{$ENDREGION}


type

  TinfProtNfe = record
  public
    tpAmp   :TnfeAmb;
    verAplic:string;
    chNFe   :string;
    dhRecbto:TDateTime;
    nProt   :string;
    digVal  :string;
    cStat   :Integer;
    xMotivo :string;
  end;

  TProtNFe = record
  public
    versao: string;
    infProt: TinfProtNfe ;
  end;

  TinfCancNfe = record
  public
    Id: string ;
    TpAmb: TnfeAmb ;
    verApp: string ;
    cStat: Word ;
    xMotivo: string;
    cUF: Word ;
    chNFe: string;
    dhRecbto: TDateTime;
    nProt: string ;
  end;

  TRetCancNfe = record
  public
    versao: string ;
    infCanc: TinfCancNfe ;
  end;

  TRetConsSitNFe = class
  private
    FVersao: string ;
  public
    ProtNFe: TProtNFe ;
    RetCancNfe: TRetCancNfe ;
    constructor Create(const AVersao: string);
  end;


type
  TnfeTipEvento = (tevCCe,tevCancel,tevManifest);
  TnfeDetEvento = class
  private
    fversao: string;
    fdescEvento: string;
    fnProt: string;    // Cancelamento
    fxJust: string;    // Cancelamento
    fxCorrecao: string;                           // CC-e
    procedure SetxCorrecao(const AValue: String); // CC-e
    function GetxCondUso: string ;                // CC-e
    procedure SetxJust(const AValue: String); // Cancelamento
  public
    property versao: string read fversao write fversao;
    property descEvento: string read fdescEvento write fdescEvento;
    property nProt: string      read fnProt      write fnProt;
    property xJust: string      read fxJust      write SetxJust;
    property xCorrecao: string read fxCorrecao write SetxCorrecao ;
    property xCondUso: string read GetxCondUso;
  end;

  TnfeEvento = class
  private
    fVersao: string;
    fId: string ;
    fXML: string ;
    function GetId: string;
    function GetXML: String;
    procedure SetXML(const AValue: string);
    procedure DoFill ;
  public
    const EVT_TYP_CCE = 110110;
    const EVT_TYP_CAN = 110111;
    const COD_PROCESS_LOTE = 128;
    const COD_EVT_VINC_NFE = 135;
    const COD_EVT_NVINC_NFE = 136;
  public
    property Id: string read GetId;
  public
    cOrgao: Byte;
    tpAmb: TnfeAmb;
    CNPJ: string ;
    chNFe: string ;
    dhEvento: TDateTime;
    tpEvento: Integer ;
    nSeqEvento: Integer;
    verEvento: string;
    detEvento: TnfeDetEvento;
    property XML: string read GetXML write SetXML ;
    constructor Create;
    destructor Destroy; override ;
    function Assinar(Cert: ICertificate2; out retMsg: String): Boolean;
  end;


{$REGION 'const'}
const
  NFE_VER_APP = 'SW NF-e v3.0';
  NFE_TIPO_AMB :array[TnfeAmb] of String = ('Produção','Homologação - SEM VALOR FISCAL');
//  NFE_TIPO_EMIS:array[TnfeEmis] of String = (
//    'Normal','FS-AI','SCAN','DPEC','FS-DA','SVC-AN','SVC-RS','NFC-e','Nenhum'
//    );

{$ENDREGION}

{$REGION 'function'}
function SaveXmlToFile(const Axml: string; const Afile: string): Boolean;
{$ENDREGION}

implementation

uses DateUtils, StrUtils
  ,unfews
  ;

{$REGION 'function'}
function SaveXmlToFile(const Axml: string; const Afile: string): Boolean;
const Declara ='<?xml version="1.0" encoding="UTF-8"?>';
var xmlDoc: TNativeXml;
var dir: string;
begin
    dir   :=ExtractFilePath(Afile);
    if dir<>'' then
    begin
        if not DirectoryExists(dir) then
        begin
            ForceDirectories(dir);
        end;
    end;

    xmlDoc :=TNativeXml.Create() ;
    //xmlDoc :=TNativeXml.CreateEx(nil, True, True, False, '');
    try

//      xmlDoc.VersionString :='1.0';
//      xmlDoc.Charset :='UTF-8';

      try
        if PosEx(Declara, Axml)>0 then
            xmlDoc.ReadFromString(UTF8String(Axml))
        else
            xmlDoc.ReadFromString(UTF8String(Declara + Axml));

//        if Assigned(xmlDoc.Declaration) then
//        begin
//            xmlDoc.Declaration.Version  :=xmlDoc.VersionString ;
//            xmlDoc.Declaration.Encoding :=xmlDoc.Charset;
//        end;

        xmlDoc.SaveToFile(Afile);
        Result :=True;
      except
        Result :=False ;
      end;
    finally
        xmlDoc.Free;
    end;
end;

function Mod10(Valor: string):string;
var
   Auxiliar : string;
   Contador, Peso: integer;
//   Produto : integer;
   Digito : integer;
begin
   Auxiliar := '';
   Peso := 2;
   for Contador := Length(Valor) downto 1 do
   begin
      //Produto := StrToInt(Valor[Contador]) * Peso;
//      if Produto > 9 then
//        Produto := IntToStr(Produto)[1] + IntToStr(Produto)[2];
      Auxiliar := IntToStr(StrToInt(Valor[Contador]) * Peso) + Auxiliar;
      if Peso = 1 then
         Peso := 2
      else
         Peso := 1;
   end;

   Digito := 0;
   for Contador := 1 to Length(Auxiliar) do
   begin
      Digito := Digito + StrToInt(Auxiliar[Contador]);
   end;
   Digito := 10 - (Digito mod 10);
   if (Digito > 9) then
      Digito := 0;
   Result := IntToStr(Digito);
end;

function Mod11(const Valor :string; Base :Integer = 9; Resto :Boolean = False):string;
var
   Soma : integer;
   Contador, Peso, Digito : integer;
begin
   Soma := 0;
   Peso := 2;
   for Contador := Length(Valor) downto 1 do
   begin
      Soma := Soma + (StrToInt(Valor[Contador]) * Peso);
      if Peso < Base then
         Peso := Peso + 1
      else
         Peso := 2;
   end;

   if Resto then
      Result := IntToStr(Soma mod 11)
   else
   begin
      Digito := 11 - (Soma mod 11);
      if (Digito > 9) then
         Digito := 0;
      Result := IntToStr(Digito);
   end
end;

{$ENDREGION}


{$REGION 'Tnotafe00List'}

{ Tide }

procedure Tide.Assign(ide: Tide);
begin
    cUF     :=ide.cUF;
    cNF     :=ide.cNF;
    natOp   :=ide.natOp;
    indPag  :=ide.indPag;
    cMod    :=ide.cMod;
    serie   :=ide.serie;
    nNF     :=ide.nNF;
    tpNF    :=ide.tpNF;
    dEmi    :=ide.dEmi;
    dSaiEnt :=ide.dSaiEnt;
    cMunFG  :=ide.cMunFG;
    tpImp   :=ide.tpImp;
    tpEmis  :=ide.tpEmis;
    cDV     :=ide.cDV;
    tpAmb   :=ide.tpAmb;
    finNFe  :=ide.finNFe;
    procEmi :=ide.procEmi;
    verProc :=ide.verProc;
    {Informar apenas para tpEmis diferente de 1}
    dhCont  :=ide.dhCont;
    xJust   :=ide.xJust;
end;

constructor Tide.Create;
begin
  inherited Create;
  cUF    := 0;
  cNF    := 0;
  indPag := pgAVis;
  cMod   := 55;
  serie  := 0;
  nNF    := 0;
  tpNF   := docSai;
  cMunFG := 0;
  tpImp  := fdRetrat;
  tpEmis := emisNomal;
  tpAmb  := ambHom;
  finNFe := finNormal;
  procEmi:= pemiContri;
  verProc:= NFE_VER_APP;
end;

destructor Tide.Destroy;
begin

  inherited Destroy;
end;

procedure Tide.setcMod(const Value: Byte);
begin
    if Value in[55,65] then
    begin
      fcMod :=Value ;
      if fcMod = TNFe.MOD_65 then
      begin
        idDest :=opeInt;
      end;
    end;
    //else raise Exception.CreateFmt('');
end;

procedure Tide.setnatOp(const Value: string);
begin
    if Value<>'' then
    begin
        fnatOp :=Tnfeutil.TrataString(Value, 60);
    end;
end;

procedure Tide.setxJust(const Value: string);
begin
    if Value<>'' then
    begin
        fxJust :=Tnfeutil.TrataString(Value, 255)	;
    end;
end;

{ Temit }

procedure Temit.Assign(emit: Temit);
begin
    CNPJ    :=emit.CNPJ;
    xNome   :=emit.xNome;
    xFant   :=emit.xFant;
    ender.Assign(emit.ender);
    IE      :=emit.IE;
    IEST    :=emit.IEST;
    IM      :=emit.IM;
end;

constructor Temit.Create;
begin
    inherited Create;
    ender:=TEndereco.Create;
end;

destructor Temit.Destroy;
begin
    ender.Destroy;
    inherited Destroy;
end;


procedure Temit.setxFant(const Value: string);
begin
    if Value<>'' then
    begin
        fxFant :=Tnfeutil.TrataString(Value, 60)	;
    end;
end;

procedure Temit.setxNome(const Value: string);
begin
    if Value<>'' then
    begin
        fxNome :=Tnfeutil.TrataString(Value, 60)	;
    end;
end;

{ TEndereco }

procedure TEndereco.Assign(Endereco: TEndereco);
begin
    xLgr    :=endereco.xLgr;
    nro     :=endereco.nro;
    xCpl    :=endereco.xCpl;
    xBairro :=endereco.xBairro;
    cMun    :=endereco.cMun;
    xMun    :=endereco.xMun;
    UF      :=endereco.UF;
    CEP     :=endereco.CEP;
    cPais   :=endereco.cPais;
    xPais   :=endereco.xPais;
    fone    :=endereco.fone;
end;

constructor TEndereco.Create;
begin
  inherited Create;
  fnro     := '000';
  fxBairro := 'CENTRO';
  fcPais   := 1058;
  fxPais   := 'Brasil';
end;

destructor TEndereco.Destroy;
begin

  inherited Destroy;
end;

function TEndereco.IsNotEmpty: Boolean;
begin
  Result := (Self.fxLgr<>'') and
            (Self.fnro<>'' )and
            (Self.fxBairro<>'') and
            (Self.fcMun > 0) and
            (Self.xMun<>'') and
            (Self.fUF<>'');
end;

procedure TEndereco.SetcMun(Value: Integer);
begin
    fcMun :=Value;
end;

procedure TEndereco.Setfone(Value: string);
begin
    ffone :=Tnfeutil.LimpaNumero(Value);
    ffone :=Copy(ffone, 1, 10);
end;

procedure TEndereco.SetUF(Value: string);
begin
    fUF :=Value;
end;

procedure TEndereco.SetxBairro(Value: string);
begin
    fxBairro :=Tnfeutil.TrataString(Value, 60);
end;

procedure TEndereco.SetxCpl(Value: string);
begin
    fxCpl :=Tnfeutil.TrataString(Value, 60);
end;

procedure TEndereco.SetxLgr(Value: string);
begin
    fxLgr :=Tnfeutil.TrataString(Value, 60);
end;

procedure TEndereco.SetxMun(Value: string);
begin
    fxMun :=Tnfeutil.TrataString(Value, 60);
end;

{ Tdest }

procedure Tdest.Assign(dest: Tdest);
begin
    CNPJ  :=dest.CNPJ;
    CPF   :=dest.CPF;
    xNome     :=dest.xNome;
    ender.Assign(dest.ender);
    IE        :=dest.IE;
end;

constructor Tdest.Create;
begin
  inherited Create;
  ender := TEndereco.Create;
end;

destructor Tdest.Destroy;
begin
  ender.Destroy;
  inherited Destroy;
end;

function Tdest.GetDoc: string;
begin
  Result :=Self.CNPJ;
  if Result = '' then
  begin
    Result :=Self.CPF ;
    if Result = '' then
      Result :=Self.idEstrangeiro;
  end;
end;

procedure Tdest.setCNPJ(const Value: string);
begin
    if Value<>'' then
    begin
        fCNPJ :=Value;
        fCPF  :='';
        fIdExt:='';
    end;
end;

procedure Tdest.setCPF(const Value: string);
begin
    if Value<>'' then
    begin
        fCPF  :=Value;
        fCNPJ :='';
        fIdExt:='';
    end;
end;

procedure Tdest.setIdExt(const Value: string);
begin
    fIdExt:=Value;
    fCNPJ :='';
    fCPF  :='';
end;

procedure Tdest.setxNome(const Value: string);
begin
    if Value<>'' then
    begin
        fxNome :=Tnfeutil.TrataString(Value, 60);
    end;
end;

{ TnfeMed }

procedure TnfeMed.Assign(med: TnfeMed);
begin
    nLote :=med.nLote;
    qLote :=med.qLote;
    dFab  :=med.dFab;
    dVal :=med.dVal;
    vPMC :=med.vPMC;
end;

{ TnfeProduto }

constructor TnfeProduto.Create(AOwner: TnfeDet);
begin
  inherited Create;
  med :=TnfeMed.Create;
  comb:=TnfeComb.Create;
end;

destructor TnfeProduto.Destroy;
begin
  med.Destroy ;
  comb.Destroy;
  inherited;
end;

procedure TnfeProduto.SetxProd(const Value: string);
begin
  fxProd :=Tnfeutil.TrataString(Value, 60) ;
end;

{ Ttransporta }

function Ttransporta.IsNotEmpty: Boolean;
begin
    Result :=Self.CNPJ<>'';
    if not Result then
    begin
        Result :=Self.CPF<>'';
    end;
end;

procedure Ttransporta.setCnpj(const Value: string);
begin
  	if Value<>'' then
    begin
        fCNPJ :=Tnfeutil.GetNumbers(Value, 14) ;
        fCPF  :='';
    end;
end;

procedure Ttransporta.setCpf(const Value: string);
begin
  	if Value<>'' then
    begin
        fCPF  :=Tnfeutil.GetNumbers(Value, 11) ;
        fCNPJ :='';
    end;
end;

procedure Ttransporta.setxEnder(const Value: string);
begin
  	if Value<>'' then
    begin
        fxEnder :=Tnfeutil.TrataString(Value, 60) ;
    end;
end;

procedure Ttransporta.setxMun(const Value: string);
begin
  	if Value<>'' then
    begin
        fxMun :=Tnfeutil.TrataString(Value, 60) ;
    end;
end;

procedure Ttransporta.setxNome(const Value: string);
begin
  	if Value<>'' then
    begin
        fxNome :=Tnfeutil.TrataString(Value, 60) ;
    end;
end;

{ TvolList }

function TvolList.Add: Tvol;
begin
  Result := Tvol.Create;
  Result.CParent := Self;
  Result.Index   := Self.Count;
  inherited Add(Result);
end;

function TvolList.Get(index: Integer): Tvol;
begin
    Result := inherited Items[Index];
end;

function TvolList.IndexOf(index: Integer): Tvol;
var i:integer;
begin
  Result:= nil;
  for i := 0 to Self.Count - 1 do
  begin
    if Self.Items[i].Index = index then
    begin
      Result := Self.Items[i];
      Break;
    end;
  end;
end;

{ Ttransp }

constructor Ttransp.Create;
begin
  inherited Create;
  modFrete    :=freEmit;
  transporta  :=Ttransporta.Create;
  veicTransp  :=Tveiculo.Create;
  vol         :=Tvol.Create ;
end;

destructor Ttransp.Destroy;
begin
  transporta.Destroy;
  veicTransp.Destroy;
  vol.Destroy;
  inherited Destroy;
end;

{ TNFe }

function TNFe.Assinar(Cert: ICertificate2; out retMsg: String): Boolean;
var outMsg: String;
begin
    Result :=False;
    if Cert<>nil then
    begin
        Result  :=Tnfeutil.Assinar(Self.XML,
                                    Cert 	 ,
                                    outMsg ,
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

procedure TNFe.Clear;
begin
    FXML	:='';
//    Fdet.ProdList		.Clear;
//    Fdet.ImpostoList.Clear;
    Fdet.Clear;
    Fcobr.dup				.Clear;
    FinfAdic.infAdFisco	:='';
    FinfAdic.infCpl	:='';
    FinfAdic.obsCont.Clear;
    //FDocXML.Clear	;
end;

constructor TNFe.Create();
begin
  inherited Create;
  Fversao   :=NFE_VER_NFE;
  Fide      :=Tide.Create;
  Femit     :=Temit.Create;
  Favulsa   :=Tavulsa.Create;
  Fdest     :=Tdest.Create;
  Fretirada :=TLocal.Create;
  Fentrega  :=TLocal.Create;
  Fdet      :=TnfeDets.Create(Self); //Tdet.Create;
  Ftotal    :=TICMSTot.Create(Self);
  Ftransp   :=Ttransp.Create;
  Fcobr     :=Tcobr.Create;
  FinfAdic  :=TinfAdic.Create;

  Fpag     :=TnfePgtos.Create(Self);

  FDocXML   :=TNativeXml.CreateName('NFe');
  FDocXML.XmlFormat       :=xfCompact;
//  FDocXML.Utf8Encoded     :=True;
//  FDocXML.Encodingstring	:='utf-8';
  FDocXML.FloatSignificantDigits :=2;
  FDocXML.FloatAllowScientific:=False;

  FDocXML.SplitSecondDigits :=0;
  FDocXML.UseLocalBias :=False ;
end;

destructor TNFe.Destroy;
begin
  Fide.Destroy;
  Femit.Destroy;
  Favulsa.Destroy;
  Fdest.Destroy;
  Fretirada.Destroy;
  Fentrega.Destroy;
  Fdet.Destroy;
  Ftotal.Destroy;
  Ftransp.Destroy;
  Fcobr.Destroy;
  FinfAdic.Destroy;

  Fpag.Destroy;

  FDocXML.Destroy;
  inherited Destroy;
end;

function TNFe.GetId: string;
begin
    {02}Result	:=IntToStr(Self.Fide.cUF);
    {04}Result	:=Result 	+FormatDateTime('YYMM',Self.Fide.dEmi);
    {14}Result	:=Result 	+Self.Femit.CNPJ;
    {02}Result	:=Result 	+IntToStr(Self.Fide.cMod);
    {03}Result	:=Result 	+Tnfeutil.FInt(Self.Fide.serie,3);
    {09}Result	:=Result 	+Tnfeutil.FInt(Self.Fide.nNF,9);
    {01}Result	:=Result 	+IntToStr(Ord(Self.Fide.tpEmis)+1);
    {08}Result	:=Result	+Tnfeutil.FInt(Self.Fide.cNF,8);
    {01}Fide.cDV:=Tnfeutil.Mod11(Result);
    //**********************************
    {44}Result := Result	+IntToStr(Fide.cDV);
end;

function TNFe.GetSegCodBar: string;
begin
    Result :=Format('%d%d%s', [ide.cUF,Ord(ide.tpEmis)+1,emit.CNPJ]);
    Result :=Result +Tnfeutil.PadD(Tnfeutil.FFlt(total.vNF*100,'0'),14,'0');
    if total.vICMS > 0 then
    begin
      Result :=Result +'1'; // há destaque de ICMS próprio
    end
    else begin
      Result :=Result +'2'; // não há destaque de ICMS próprio
    end;
    if total.vST > 0 then
    begin
      Result :=Result +'1';  // há destaque de ICMS por ST
    end
    else begin
      Result :=Result +'2';  // não há destaque de ICMS por ST
    end;
    Result :=Result +FormatDateTime('dd',ide.dEmi);
    Result :=Result +IntToStr(Tnfeutil.Mod11(Result));
end;

class function TNFe.GetTpEmis(const tpEmis: TnfeEmis): string;
begin
  case tpEmis of
    emisNomal: Result :='Normal';
    emisCon_FS: Result :='FS-AI';
    emisCon_SCAN: Result :='SCAN';
    emisCon_DPEC: Result :='DPEC';
    emisCon_FSDA: Result :='FS-DA';
    emisCon_SVCAN: Result :='SVC-AN';
    emisCon_SVCRS: Result :='SVC-RS';
    emisCon_NFCe: Result :='NFC-e';
  else
    Result  :='Nenhum';
  end;
end;

function TNFe.GetXML: string;
var
  doc: TNativeXml;
  pro :TnfeProduto; // Tprod;
  imp :TnfeImposto; // Timposto;
  det: TnfeDet;
  dpl :TdupList.Tdup;
  fpg :TnfePgto;
  obs	:TobsContList.TobsCont;

var
  vBC ,
  vICMS ,
  vBCST ,
  vST   ,
  vProd ,
  vFrete,
  vSeg  ,
  vDesc ,
  vIPI  ,
  vOutro:Currency;

  vTotTrib:Currency;

var
  I,D :Integer;

begin
  //
  if PosEx('<Signature', FXML)>0 then
  begin
    Result	:=FXML ;
    Exit;
  end;

  doc :=TNativeXml.CreateName('NFe');
  try
    doc.XmlFormat       :=xfCompact;
    doc.FloatAllowScientific  :=False;
    doc.FloatSignificantDigits:=2;
    doc.SplitSecondDigits :=0;
    doc.UseLocalBias :=(ide.cMod = MOD_65);

    with doc.Root do
    begin
      AttributeAdd('xmlns', NFE_PORTALFISCAL_INF_BR);

      // infNFe
      with NodeNew('infNFe') do
      begin
        case ide.cMod of
          MOD_55: AttributeAdd('versao', NFE_VER_NFE);
          MOD_65: AttributeAdd('versao', NFCE_VER_NFCE);
        end;

        AttributeAdd('Id'    , 'NFe'+Self.Id);

        //ide
        with NodeNew('ide') do
        begin
          WriteInteger('cUF'    , ide.cUF);
          WriteString('cNF'     , Tnfeutil.FInt(ide.cNF,8));
          WriteString('natOp'   , ide.natOp);
          WriteInteger('indPag' , Ord(ide.indPag));
          WriteInteger('mod'    , ide.cMod);
          WriteInteger('serie'  , ide.serie);
          WriteInteger('nNF'    , ide.nNF);

          if ide.cMod = MOD_55 then
          begin
            WriteDate('dEmi', ide.dEmi);
            if ide.dSaiEnt > 0 then
            begin
              WriteDate('dSaiEnt', ide.dSaiEnt);
              WriteTime('hSaiEnt', ide.hSaiEnt);
            end;
          end
          else begin
            WriteDateTime('dhEmi', ide.dEmi);
//            if ide.dSaiEnt > 0 then
//            begin
//              WriteDateTime('dhSaiEnt', ide.dSaiEnt +ide.hSaiEnt);
//            end;
          end;

          WriteInteger('tpNF'   , Ord(ide.tpNF));
          if ide.cMod = MOD_65 then
          begin
            WriteInteger('idDest'   , Ord(ide.idDest));
          end;
          WriteInteger('cMunFG' , ide.cMunFG);
          {NFref
          with NodeNew('NFref') do
          begin
              ...
          end}
          WriteInteger('tpImp'    , Ord(ide.tpImp));

          case ide.tpEmis of
            emisCon_FS: WriteInteger('tpEmis'   , 2);
            emisCon_SCAN: WriteInteger('tpEmis' , 3);
            emisCon_DPEC: WriteInteger('tpEmis' , 4);
            emisCon_FSDA: WriteInteger('tpEmis' , 5);
            emisCon_SVCAN: WriteInteger('tpEmis', 6);
            emisCon_SVCRS: WriteInteger('tpEmis', 7);
            emisCon_NFCe: WriteInteger('tpEmis' , 9);
          else
            WriteInteger('tpEmis', 1);
          end;

          WriteInteger('cDV'      , ide.cDV				 	);
          WriteInteger('tpAmb'    , Ord(ide.tpAmb)+1);
          WriteInteger('finNFe'   , Ord(ide.finNFe)+1);
          if ide.cMod = MOD_65 then
          begin
            WriteInteger('indFinal', Ord(ide.indFinal));
            WriteInteger('indPres', Ord(ide.indPres));
          end;

          WriteInteger('procEmi'  , Ord(ide.procEmi));
          WriteString('verProc'   , ide.verProc);
          if ide.tpEmis<>emisNomal then
          begin
            //WriteDateTime	('dhCont'  , ide.dhCont);
            WriteDate('dhCont' , ide.dhCont, True);
            WriteString('xJust', ide.xJust);
          end;
        end;

        // emit
        with NodeNew('emit') do
        begin
          if ide.tpAmb=ambPro then
          begin
            Writestring('CNPJ'  , emit.CNPJ);
            Writestring('xNome' , emit.xNome);
            if not Tnfeutil.IsEmpty(emit.xFant) then
            begin
              Writestring('xFant', emit.xFant);
            end;
          end
          else begin
            Writestring('CNPJ'  , emit.CNPJ);
            Writestring('xNome' , Self.HOM_NOME );
          end;

          // enderEmit
          with NodeNew('enderEmit') do
          begin
            Writestring('xLgr'    , emit.ender.xLgr);
            Writestring('nro'     , emit.ender.nro);
            if emit.ender.xCpl<>'' then
            begin
              Writestring('xCpl'   , emit.ender.xCpl);
            end;
            Writestring('xBairro' , emit.ender.xBairro);
            WriteInteger('cMun'   , emit.ender.cMun);
            Writestring('xMun'    , emit.ender.xMun);
            Writestring('UF'      , emit.ender.UF);
            if not Tnfeutil.IsEmpty(emit.ender.CEP) then
            begin
              WriteString('CEP'    , emit.ender.CEP);
            end;
            WriteInteger('cPais'  , emit.ender.cPais);
            Writestring('xPais'   , emit.ender.xPais);
            if emit.ender.fone <> '' then
            begin
              WriteString('fone'   , emit.ender.fone);
            end;
          end;
          WriteString('IE', emit.IE);
          WriteInteger('CRT', emit.CRT);
        end;

        // dest
        if dest.GetDoc <> '' then
        with NodeNew('dest') do
        begin
          if dest.CNPJ<>'' then
          begin
            WriteString('CNPJ', dest.CNPJ);
          end
          else if dest.CPF<>'' then
          begin
            WriteString('CPF', dest.CPF);
          end
          else begin
            WriteString('idEstrangeiro', dest.idEstrangeiro);
          end;
          if ide.tpAmb=ambPro then
          begin
            WriteString('xNome', dest.xNome);
          end
          else
          begin
            WriteString('xNome' , Self.HOM_NOME);
          end;

          // enderDest
          if dest.ender.IsNotEmpty then
          with NodeNew('enderDest') do
          begin
            Writestring('xLgr'    , dest.ender.xLgr);
            Writestring('nro'     , dest.ender.nro);
            if dest.ender.xCpl <> '' then
            begin
              Writestring('xCpl'    , dest.ender.xCpl);
            end;
            Writestring('xBairro' , dest.ender.xBairro);
            WriteInteger('cMun'   , dest.ender.cMun);
            Writestring('xMun'    , dest.ender.xMun);
            Writestring('UF'      , dest.ender.UF);
            if not Tnfeutil.IsEmpty(dest.ender.CEP) then
            begin
              WriteString('CEP'    , dest.ender.CEP);
            end;
            WriteInteger('cPais'  , dest.ender.cPais);
            Writestring('xPais'   , dest.ender.xPais);
            if dest.ender.fone <> '' then
            begin
            WriteString('fone'   , dest.ender.fone);
            end;
          end;{with enderDest}

          if ide.cMod = MOD_55 then
          begin
            WriteString('IE', dest.IE) ;
          end;
          if dest.email<>'' then
          begin
            WriteString('email', dest.email) ;
          end;

        end;{with dest}

       {retirada
       with NodeNew('retirada') do
       begin
         // ...
       end;}

       {entrega
       with NodeNew('entrega') do
       begin
         // ...
       end;}

       //Detalhes da NF-e
       vBC 	:=0;
       vICMS:=0;
       vBCST:=0;
       vST	:=0;
       vProd:=0	;
       vFrete:=0;
       vSeg :=0;
       vDesc :=0;
       vIPI :=0;
       vOutro :=0;
       vTotTrib:=0;

        //for I := 0 to det.ProdList.Count -1 do
        for I := 0 to Self.det.Count -1 do
        begin
          // det
          det :=Self.det.Items[I] ;
          pro :=det.prod;
          imp :=det.imposto;
          with NodeNew('det') do
          begin
             AttributeAdd('nItem', I+1);
//             pro    :=det.ProdList.Items[i];
             vProd	:=vProd 	+pro.vProd ;
             vFrete :=vFrete	+pro.vFrete;
             vSeg   :=vSeg    +pro.vSeg	 ;
             vDesc	:=vDesc		+pro.vDesc ;
             vOutro	:=vOutro	+pro.vOutro;

             with NodeNew('prod') do
             begin
               WriteString('cProd'    ,pro.cProd);
               WriteString('cEAN'     ,pro.cEAN);
               WriteString('xProd'    ,pro.xProd);
               WriteString('NCM'      ,pro.NCM);
               {Writestring('EXTIPI'  ,Prod.EXTIPI);}
               WriteInteger('CFOP'    ,pro.CFOP		);
               WriteString('uCom'     ,pro.uCom		);
               WriteFloat('qCom'      ,pro.qCom			,4);
               WriteFloat('vUnCom'    ,pro.vUnCom		,Self.QTD_CASAS_DEC_VUNIT);
               WriteFloat('vProd'     ,pro.vProd		,2);
               WriteString('cEANTrib'	,pro.cEANTrib   );
               WriteString('uTrib'   	,pro.uTrib      );
               WriteFloat('qTrib'   	,pro.qTrib  	,4);
               WriteFloat('vUnTrib' 	,pro.vUnTrib	,Self.QTD_CASAS_DEC_VUNIT);

               if pro.vFrete>0 then
               begin
                  WriteFloat('vFrete', pro.vFrete, 2);
               end;

               if pro.vSeg>0 then
               begin
                  WriteFloat('vSeg', pro.vSeg, 2);
               end;

               if pro.vDesc>0 then
               begin
                  WriteFloat('vDesc', pro.vDesc, 2);
               end;

               if pro.vOutro>0 then
               begin
                  WriteFloat('vOutro'  , pro.vOutro, 2);
               end;

               WriteInteger('indTot'   , pro.indTot);

               //med
               if pro.med.nLote <> '' then
               with NodeNew('med') do
               begin
                 WriteString('nLote' , pro.med.nLote);
                 WriteFloat('qLote' , pro.med.qLote, 3);
                 WriteDate('dFab', pro.med.dFab);
                 WriteDate('dVal', pro.med.dVal);
                 WriteFloat('vPMC', pro.med.vPMC, 2);
               end{with med}
               //comb
               else if pro.comb.cProdANP > 0 then
               with NodeNew('comb') do
               begin
                 WriteInteger('cProdANP' , pro.comb.cProdANP);
                 if pro.comb.CODIF<>'' then
                 begin
                    WriteString('CODIF' , pro.comb.CODIF);
                 end;
                 if pro.comb.qTemp>0 then
                 begin
                    WriteFloat('qTemp' , pro.comb.qTemp, 4);
                 end;
                 if pro.comb.UFCons<>'' then
                 begin
                    WriteString('UFCons' , pro.comb.UFCons);
                 end;
                 if pro.comb.CIDE.vCIDE>0 then
                 begin
                    with NodeNew('CIDE') do
                    begin
                      WriteFloat('qBCProd'  , pro.comb.CIDE.qBCProd, 4);
                      WriteFloat('vAliqProd', pro.comb.CIDE.vAliqProd, 4);
                      WriteFloat('vCIDE'    , pro.comb.CIDE.vCIDE);
                    end;
                 end;
               end{with comb}

             end;{with prod}

             // imposto
             //imp := det.ImpostoList[i];

             // ICMS Normal e ST
             with NodeNew('imposto') do
             begin
               //Homologação 15/05/13;
               {if ide.dEmi >= EncodeDate(2013,5,15) then
               begin
                 vTotTrib :=vTotTrib +imp.vTotTrib ;
                 WriteFloat('vTotTrib', imp.vTotTrib, 2);
               end;}

               with NodeNew('ICMS') do
               begin
                 // Tributção pelo ICMS
                 //case imp.ICMS.icmsst of
                 case imp.ICMS.CST of

                   // 00 - Tributada integralmente
                   cst00:
                   with NodeNew('ICMS00') do
                   begin
                     vBC 		:=vBC 	+imp.ICMS.vBC	;
                     vICMS	:=vICMS +imp.ICMS.vICMS	;
                     WriteInteger('orig'  , Ord(imp.ICMS.orig         ) );
                     WriteString('CST'    , Tnfeutil.FInt(Ord(imp.ICMS.CST)));
                     WriteInteger('modBC' , Ord(imp.ICMS.modBC)             );
                     WriteFloat('vBC'     , imp.ICMS.vBC  , 2 );
                     WriteFloat('pICMS'   , imp.ICMS.pICMS, 2 );
                     WriteFloat('vICMS'   , imp.ICMS.vICMS, 2 );
                   end;{ICMS00}

                   // 10 - Tributada e com cobrança do ICMS por substituição
                   // tributária
                   cst10:
                   with NodeNew('ICMS10') do
                   begin
                     vBC 		:=vBC 	+imp.ICMS.vBC	;
                     vICMS	:=vICMS +imp.ICMS.vICMS	;
                     vBCST	:=vBCST +imp.ICMS.vBCST	;
                     vST		:=vST		+imp.ICMS.vICMSST;
                     WriteInteger('orig'     , Ord(imp.ICMS.orig));
                     WriteString('CST'       , Tnfeutil.FInt(ord(imp.ICMS.CST)));
                     WriteInteger('modBC'    , Ord(imp.ICMS.modBC));
                     WriteFloat('vBC'       , imp.ICMS.vBC  , 2);
                     WriteFloat('pICMS'     , imp.ICMS.pICMS, 2);
                     WriteFloat('vICMS'     , imp.ICMS.vICMS, 2);
                     WriteInteger('modBCST'  , Ord(imp.ICMS.modBCST));
                     if imp.ICMS.pMVAST > 0 then WriteFloat('pMVAST', imp.ICMS.pMVAST, 2);
                     if imp.ICMS.pRedBCST > 0 then WriteFloat('pRedBCST', imp.ICMS.pRedBCST, 2);
                     WriteFloat('vBCST'     , imp.ICMS.vBCST  , 2);
                     WriteFloat('pICMSST'   , imp.ICMS.pICMSST, 2);
                     WriteFloat('vICMSST'   , imp.ICMS.vICMSST, 2);
                   end;{ICMS10}

                   // 20 - Com redução de base de cálculo
                   cst20:
                   with NodeNew('ICMS20') do
                   begin
                     vBC 	:=vBC 	+imp.ICMS.vBC	;
                     vICMS:=vICMS +imp.ICMS.vICMS	;
                     WriteInteger('orig'   , Ord(imp.ICMS.orig));
                     WriteString('CST'     , Tnfeutil.FInt(ord(imp.ICMS.CST)));
                     WriteInteger('modBC'  , ord(imp.ICMS.modBC));
                     WriteFloat('pRedBC'  , imp.ICMS.pRedBC , 2);
                     WriteFloat('vBC'     , imp.ICMS.vBC    , 2);
                     WriteFloat('pICMS'   , imp.ICMS.pICMS  , 2);
                     WriteFloat('vICMS'   , imp.ICMS.vICMS  , 2);
                   end;{ICMS20}

                   // 30 - Isenta ou não tributada e com cobrança do ICMS por
                   // substituição tributária
                   cst30:
                   with NodeNew('ICMS30') do
                   begin
                     vBCST	:=vBCST +imp.ICMS.vBCST	;
                     vST		:=vST		+imp.ICMS.vICMSST	;
                     WriteInteger('orig'     , Ord(imp.ICMS.orig));
                     WriteString('CST'       , Tnfeutil.FInt(ord(imp.ICMS.CST)));
                     WriteInteger('modBCST'  , Ord(imp.ICMS.modBCST));
                     WriteFloat('pMVAST'    , imp.ICMS.pMVAST   , 2);
                     WriteFloat('pRedBCST'  , imp.ICMS.pRedBCST , 2);
                     WriteFloat('vBCST'     , imp.ICMS.vBCST    , 2);
                     WriteFloat('pICMSST'   , imp.ICMS.pICMSST  , 2);
                     WriteFloat('vICMSST'   , imp.ICMS.vICMSST  , 2);
                   end;{ICMS30}

                   // 40 - Isenta; 41 - Não tributada; 50 - Suspensão
                   cst40,cst41,cst50:
                   with NodeNew('ICMS40') do
                   begin
                     WriteInteger('orig', Ord(imp.ICMS.orig));
                     Writestring('CST'  , Tnfeutil.FInt(ord(imp.ICMS.CST)));
                   end;{ICMS40}

                   // 51 - Diferimento. A exigência do preenchimento das
                   // informações do ICMS diferido fica à critério de cada UF.
                   cst51:
                   with NodeNew('ICMS51') do
                   begin
                     vBC 	:=vBC + imp.ICMS.vBC	;
                     vICMS:=vICMS +imp.ICMS.vICMS	;
                     WriteInteger('orig'     , Ord(imp.ICMS.orig));
                     WriteString('CST'       , Tnfeutil.FInt(Ord(imp.ICMS.CST)));
                     WriteInteger('modBC'    , Ord(imp.ICMS.modBC));
                     WriteFloat('pRedBC'    , imp.ICMS.pRedBC , 2);
                     WriteFloat('vBC'       , imp.ICMS.vBC    , 2);
                     WriteFloat('pICMS'     , imp.ICMS.pICMS  , 2);
                     WriteFloat('vICMS'     , imp.ICMS.vICMS  , 2);
                   end;{ICMS51}

                   // 60 - ICMS cobrado anteriormente por substituição tributária
                   cst60:
                   with NodeNew('ICMS60') do
                   begin
                     WriteInteger('orig'     , Ord(imp.ICMS.orig));
                     WriteString('CST'       , Tnfeutil.FInt(Ord(imp.ICMS.CST)));
                     WriteFloat('vBCSTRet'	 , imp.ICMS.vBCSTRet  , 2);
                     WriteFloat('vICMSSTRet', imp.ICMS.vICMSSTRet , 2);
                   end;{ICMS60}

                   // 70 - Com redução de base de cálculo e cobrança do ICMS por
                   // substituição tributária
                   cst70:
                   with NodeNew('ICMS70') do
                   begin
                     vBC 		:=vBC 	+imp.ICMS.vBC	;
                     vICMS	:=vICMS +imp.ICMS.vICMS	;
                     vBCST	:=vBCST +imp.ICMS.vBCST	;
                     vST		:=vST		+imp.ICMS.vICMSST	;
                     WriteInteger('orig'     , Ord(imp.ICMS.orig         ));
                     WriteString('CST'       , Tnfeutil.FInt(Ord(imp.ICMS.CST)));
                     WriteInteger('modBC'    , Ord(imp.ICMS.modBC));
                     WriteFloat('pRedBC'    , imp.ICMS.pRedBC , 2);
                     WriteFloat('vBC'       , imp.ICMS.vBC    , 2);
                     WriteFloat('pICMS'     , imp.ICMS.pICMS  , 2);
                     WriteFloat('vICMS'     , imp.ICMS.vICMS  , 2);
                     WriteInteger('modBCST'  , Ord(imp.ICMS.modBCST));
                     if imp.ICMS.pMVAST  > 0 then WriteFloat('pMVAST', imp.ICMS.pMVAST, 2);
                     if imp.ICMS.pRedBCST> 0 then WriteFloat('pRedBCST', imp.ICMS.pRedBCST, 2);
                     WriteFloat('vBCST'  , imp.ICMS.vBCST  , 2);
                     WriteFloat('pICMSST', imp.ICMS.pICMSST, 2);
                     WriteFloat('vICMSST', imp.ICMS.vICMSST, 2);
                   end;{ICMS70}
                 else
                   // 90 - Outras
                   with NodeNew('ICMS90') do
                   begin
                     vBC 		:=vBC 	+imp.ICMS.vBC	;
                     vICMS	:=vICMS +imp.ICMS.vICMS	;
                     vBCST	:=vBCST +imp.ICMS.vBCST	;
                     vST		:=vST		+imp.ICMS.vICMSST	;
                     WriteInteger('orig'     , Ord(imp.ICMS.orig));
                     WriteString('CST'       , Tnfeutil.FInt(Ord(imp.ICMS.CST)));
                     if imp.ICMS.vBC > 0 then
                     begin
                       WriteInteger('modBC', Ord(imp.ICMS.modBC));
                       WriteFloat('vBC'    , imp.ICMS.vBC, 2);
                       if imp.ICMS.pRedBC > 0 then WriteFloat('pRedBC', imp.ICMS.pRedBC, 2);
                       WriteFloat('pICMS'  , imp.ICMS.pICMS, 2);
                       WriteFloat('vICMS'  , imp.ICMS.vICMS, 2);
                     end;
                     if imp.ICMS.vBCST > 0 then
                     begin
                       WriteInteger('modBCST'  , Ord(imp.ICMS.modBCST));
                       if imp.ICMS.pMVAST > 0 then WriteFloat('pMVAST' , imp.ICMS.pMVAST, 2);
                       if imp.ICMS.pRedBCST > 0 then WriteFloat('pRedBCST', imp.ICMS.pRedBCST, 2);
                       WriteFloat('vBCST'  , imp.ICMS.vBCST, 2);
                       WriteFloat('pICMSST', imp.ICMS.pICMSST, 2);
                       WriteFloat('vICMSST', imp.ICMS.vICMSST, 2);
                     end;
                   end;{ICMS90}
                 end;{case CST}
               end;{with ICMS}

               // IPI
               if imp.IPI.pIPI > 0 then
               begin
                 with NodeNew('IPI') do
                 begin
                    WriteString('cEnq', imp.IPI.cEnq);
                    with NodeNew('IPITrib') do
                    begin
                      vIPI	:=vIPI	+imp.IPI.vIPI	;
                      WriteInteger('CST' , Ord(imp.IPI.CST));
                      WriteFloat('vBC' , imp.IPI.vBC  , 2);
                      WriteFloat('pIPI', imp.IPI.pIPI , 2);
                      WriteFloat('vIPI', imp.IPI.vIPI , 2);
                    end;
                 end;
               end;

               // PIS
               with NodeNew('PIS') do
               begin
                 // PIS
                 case imp.PIS.CST of
                   //
                   pis01,pis02:
                   with NodeNew('PISAliq') do
                   begin
                     WriteString('CST'  , Tnfeutil.FInt(Ord(imp.PIS.CST)));
                     WriteFloat('vBC'  , imp.PIS.vBC  , 2);
                     WriteFloat('pPIS' , imp.PIS.pPIS , 2);
                     WriteFloat('vPIS' , imp.PIS.vPIS , 2);
                   end;{cpAliq}
                   //
                   pis03:
                   with NodeNew('PISQtde') do
                   begin
                     WriteString('CST'     , Tnfeutil.FInt(ord(imp.PIS.CST)));
                     WriteFloat('qBCProd'  , imp.PIS.qBCProd   , 4);
                     WriteFloat('vAliqProd', imp.PIS.vAliqProd , 4);
                     WriteFloat('vPIS'     , imp.PIS.vPIS      , 2);
                   end;{cpQtde}
                   //
                   pis04,pis06,pis07,pis08,pis09:
                   with NodeNew('PISNT') do
                      Writestring('CST', Tnfeutil.FInt(Ord(imp.PIS.CST)));
                   //
                   pis99:
                   with NodeNew('PISOutr') do
                   begin
                     WriteString('CST'       , Tnfeutil.FInt(Ord(imp.PIS.CST)));
                     WriteFloat('vBC'        , imp.PIS.vBC      , 2);
                     WriteFloat('vPIS'       , imp.PIS.vPIS     , 2);
                     WriteFloat('qBCProd'    , imp.PIS.qBCProd  , 4);
                     WriteFloat('vAliqProd'  , imp.PIS.vAliqProd, 4);
                     WriteFloat('pPIS'       , imp.PIS.pPIS     , 2);
                   end;{cpOutr}
                 end;{case pis}
               end;{with PIS}

               // COFINS
               with NodeNew('COFINS') do
               begin
                 // COFINS
                 case imp.COFINS.CST of
                   //
                   cof01,cof02:
                   with NodeNew('COFINSAliq') do
                   begin
                     WriteString('CST'     , Tnfeutil.FInt(ord(imp.COFINS.CST)));
                     WriteFloat('vBC'      , imp.COFINS.vBC     , 2);
                     WriteFloat('pCOFINS'  , imp.COFINS.pCOFINS , 2);
                     WriteFloat('vCOFINS'  , imp.COFINS.vCOFINS , 2);
                   end;{ccAliq}
                   //
                   cof03:
                   with NodeNew('COFINSQtde') do
                   begin
                     WriteString('CST'       , Tnfeutil.FInt(Ord(imp.COFINS.CST)));
                     WriteFloat('qBCProd'    , imp.COFINS.qBCProd   , 4);
                     WriteFloat('vAliqProd'  , imp.COFINS.vAliqProd , 4);
                     WriteFloat('vCOFINS'    , imp.COFINS.vCOFINS   , 2);
                   end;{ccQtde}
                   //
                   cof04,cof06,cof07,cof08,cof09:
                   with NodeNew('COFINSNT') do
                      Writestring('CST', Tnfeutil.FInt(Ord(imp.COFINS.CST)));
                   //
                 else
                   with NodeNew('COFINSOutr') do
                   begin
                     WriteString('CST'     , Tnfeutil.FInt(ord(imp.COFINS.CST)));
                     WriteFloat('vBC'      , imp.COFINS.vBC       , 2);
                     WriteFloat('pCOFINS'  , imp.COFINS.pCOFINS   , 2);
                     WriteFloat('qBCProd'  , imp.COFINS.qBCProd   , 4);
                     WriteFloat('vAliqProd', imp.COFINS.vAliqProd , 4);
                     WriteFloat('vCOFINS'  , imp.COFINS.vCOFINS   , 2);
                   end;{ccOutr}
                 end;{case cofins}
               end;{with cofins}

             end;{with imposto}

             // Inf adicionais do produto
//             if not Tnfeutil.IsEmpty(pro.infAdProd) then
             if not Tnfeutil.IsEmpty(det.infAdProd) then
             begin
               Writestring('infAdProd', det.infAdProd);
             end;

          end;{with det}

        end;{for det}

        // totais da NF-e
        with NodeNew('total').NodeNew('ICMSTot') do
        begin
          // ICMSTot
//            with NodeNew('ICMSTot') do
//            begin
          total.vBC    :=vBC	;
          total.vICMS  :=vICMS	;
          total.vBCST  :=vBCST	;
          total.vST	  :=vST	;
          total.vProd  :=vProd	;
          total.vFrete :=vFrete;
          total.vSeg   :=vSeg	;
          total.vDesc  :=vDesc	;
          total.vIPI   :=vIPI	;
          total.vOutro :=vOutro;
          total.vTotTrib :=vTotTrib;
          WriteFloat('vBC'      , total.vBC 			, 2);
          WriteFloat('vICMS'    , total.vICMS    , 2);
          WriteFloat('vBCST'    , total.vBCST		, 2);
          WriteFloat('vST'      , total.vST      , 2);
          WriteFloat('vProd'    , total.vProd    , 2);
          WriteFloat('vFrete'   , total.vFrete   , 2);
          WriteFloat('vSeg'     , total.vSeg     , 2);
          WriteFloat('vDesc'    , total.vDesc    , 2);
          WriteFloat('vII'      , total.vII      , 2);
          WriteFloat('vIPI'     , total.vIPI     , 2);
          WriteFloat('vPIS'     , total.vPIS     , 2);
          WriteFloat('vCOFINS'  , total.vCOFINS  , 2);
          WriteFloat('vOutro'   , total.vOutro   , 2);
          WriteFloat('vNF'      , total.vNF      , 2);
          {if total.vTotTrib > 0 then
          begin
          WriteFloat('vTotTrib', total.vTotTrib, 2);
          end;}
//            end;{with ICMSTot}
        end;{with total}

        // Dados dos transportes
        with NodeNew('transp') do
        begin
          if ide.cMod = MOD_65 then
            WriteInteger('modFrete', 9)
          else begin
            WriteInteger('modFrete', Ord(transp.modFrete));
            // transporta
            if transp.transporta.IsNotEmpty then with NodeNew('transporta') do
            begin
              if transp.transporta.CNPJ<>'' then
                WriteString('CNPJ'    , transp.transporta.CNPJ)
              else
                WriteString('CPF'     , transp.transporta.CPF);
              if transp.transporta.xNome<>''  then WriteString('xNome'   , transp.transporta.xNome);
              if transp.transporta.IE<>''     then WriteString('IE'      , transp.transporta.IE);
              if transp.transporta.xEnder<>'' then WriteString('xEnder'  , transp.transporta.xEnder);
              if transp.transporta.xMun<>''   then WriteString('xMun'    , transp.transporta.xMun);
              if transp.transporta.UF<>''     then WriteString('UF'      , transp.transporta.UF);
            end;{transporta}

            if transp.veicTransp.placa <> '' then with NodeNew('veicTransp') do
            begin
              WriteString('placa', transp.veicTransp.placa);
              WriteString('UF'   , transp.veicTransp.UF);
              if transp.veicTransp.RNTC<>'' then Writestring('RNTC' , transp.veicTransp.RNTC);
            end;

            with NodeNew('vol') do
            begin
              WriteInteger('qVol' , transp.vol.qVol);
              WriteString('esp'   , 'VOLUME');
              if transp.vol.marca  <> '' then WriteString('marca', transp.vol.marca);
              if transp.vol.nVol   <> '' then WriteString('nVol' , transp.vol.nVol);
              if transp.vol.pesoL > 0 then WriteFloat('pesoL', transp.vol.pesoL, 3);
              if transp.vol.pesoB > 0 then WriteFloat('pesoB', transp.vol.pesoB, 3);
            end;{vol}
          end;
        end;{with transp}

        // Dados da cobrança
        if cobr.dup.Count > 0 then
        begin
          with NodeNew('cobr') do
          begin
            // fatura
            with NodeNew('fat') do
            begin
              WriteString('nFat'	, cobr.fat.nFat    );
              WriteFloat('vOrig'	, cobr.fat.vOrig, 2);
              if cobr.fat.vDesc > 0 then
              begin
                WriteFloat('vDesc' , cobr.fat.vDesc, 2);
              end;
              if cobr.fat.vLiq > 0 then
              begin
                WriteFloat('vLiq'  , cobr.fat.vLiq, 2);
              end;
            end;
            // duplicatas
            for d :=0 to cobr.dup.Count -1 do
            begin
              dpl :=cobr.dup.Items[d];
              with NodeNew('dup') do
              begin
                WriteString ('nDup'   , dpl.nDup    );
                WriteDate   ('dVenc'  , dpl.dVenc   );
                WriteFloat	('vDup'   , dpl.vDup	,2);
              end;
            end;
          end;
        end;

        //Grupo YA – Formas de Pagamento (NFC-e)
        if ide.cMod = MOD_65 then
        begin
          for I :=0 to pag.Count -1 do
          begin
            fpg :=pag.Items[I] ;
            with NodeNew('pag') do
            begin
              WriteString('tPag', Tnfeutil.FInt(Ord(fpg.tPag)));
              WriteFloat('vPag', fpg.vPag, 2);
            end;
          end;
        end;

        // dados adic
        with NodeNew('infAdic') do
        begin
          if not Tnfeutil.IsEmpty(infAdic.infCpl) then
          begin
            WriteString('infCpl', infAdic.infCpl	);
          end;
          if infAdic.obsCont.Count>0 then
          begin
            for i :=0 to infAdic.obsCont.Count -1 do
            begin
              obs :=infAdic.obsCont.Items[i];
              if not Tnfeutil.IsEmpty(obs.xTexto) then with NodeNew('obsCont') do
              begin
                AttributeAdd('xCampo', obs.xCampo	);
                WriteString	('xTexto', obs.xTexto	);
              end;
            end;
          end;
        end;

      end;{with infNFe}

      // Retorno
      //Result	:=FDocXML.Root.WriteToString;
      Result	:=doc.Root.WriteToString;

    end;{with NFe}

  finally
    doc.Free ;
  end;

end;

function TNFe.LoadFromFile(const file_name: String;
	out ret_msg: String): Integer;
var Pi,Pf:Integer	;
begin
    Result :=0;
    FDocXML.LoadFromFile(file_name);
    ret_msg	:=FDocXML.Root.WriteToString;
    Pi 			:=Pos('nfeProc', ret_msg);
    if Pi>0 then
    begin
      	Pi	:=Pos('<NFe',ret_msg)	;
        Pf 	:=Pos('</NFe>',ret_msg)	;
        ret_msg	:=Copy(ret_msg,Pi,(Pf-Pi)+6) ;
    end;
    Self.XML	:=ret_msg;
end;

procedure TNFe.SetXML(const Value: string);
var
  doc: TNativeXml;
  r,p: TXmlNode;
var
  pro: TnfeProduto; // Tprod;
  imp: TnfeImposto; // Timposto;
  det: TnfeDet;
  dup: TdupList.Tdup;
  fpg :TnfePgto;
//var obs: TobsContList.TobsCont;
var
  I: Integer;

begin

  if Tnfeutil.IsEmpty(Value) then
  begin
    Exit;
  end;

  Self.Clear;
  FXML :=Value ;

  doc :=TNativeXml.Create;
  try
    doc.ReadFromString(Value);
    r :=doc.Root.NodeByName('infNFe');

    // att
    Fversao	:=r.ReadAttributeString('versao') ;
    FId :=Copy(r.ReadAttributeString('Id'),4,44) ;

    // ide
    p :=r.NodeByName('ide');
    ide.cUF    :=p.ReadInteger('cUF');
    ide.cNF    :=p.ReadInteger('cNF');
    ide.natOp  :=p.ReadString('natOp');
    ide.indPag :=TnfeIndPagto(p.ReadInteger('indPag'));
    ide.cMod   :=p.ReadInteger('mod');
    ide.serie  :=p.ReadInteger('serie');
    ide.nNF    :=p.ReadInteger('nNF');
    if ide.cMod = MOD_55 then
    begin
      ide.dEmi   :=p.ReadDateTime('dhEmi');
      ide.dSaiEnt :=p.ReadDateTime('dhSaiEnt');
      ide.hSaiEnt :=p.ReadTime('hSaiEnt');
    end
    else begin
      ide.dEmi   :=p.ReadDateTime('dhEmi');
      if ide.dSaiEnt > 0 then
      begin
        ide.dSaiEnt :=p.ReadDateTime('dhSaiEnt');
        ide.hSaiEnt :=TimeOf(ide.dSaiEnt);
      end;
    end;

    ide.tpNF   :=TnfeTypDoc(p.ReadInteger('tpNF'));
    ide.idDest :=TnfeIdOpera(p.ReadInteger('idDest', 1));
    ide.cMunFG :=p.ReadInteger('cMunFG');
    ide.tpImp  :=TnfeFormDANFE(p.ReadInteger('tpImp'));
    case p.ReadInteger('tpEmis', 1) of
      1:ide.tpEmis :=emisNomal;
      2:ide.tpEmis :=emisCon_FS;
      3:ide.tpEmis :=emisCon_SCAN;
      4:ide.tpEmis :=emisCon_DPEC;
      5:ide.tpEmis :=emisCon_FSDA;
      6:ide.tpEmis :=emisCon_SVCAN;
      7:ide.tpEmis :=emisCon_SVCRS;
      9:ide.tpEmis :=emisCon_NFCe ;
    end;
    ide.cDV    :=p.ReadInteger('cDV');
    ide.tpAmb  :=Tnfeutil.SeSenao(p.ReadInteger('tpAmb')=1,ambPro,ambHom);
    case p.ReadInteger('finNFe') of
      1:ide.finNFe :=finNormal;
      2:ide.finNFe :=finCompl;
      3:ide.finNFe :=finAjust;
    else
      ide.finNFe :=finNormal;
    end;

    // v3.00
    ide.indFinal  :=TnfeIndOpeFinal(p.ReadInteger('indFinal'));
    ide.indPres   :=TnfeIndPresCons(p.ReadInteger('indPres'));

    ide.procEmi   :=TnfeProcEmis(p.ReadInteger('procEmi'));

    // v2.00
    if p.FindNode('dhCont')<>nil then
    begin
      ide.dhCont	:=p.ReadDateTime('dhCont');
      ide.xJust		:=p.ReadString('xJust');
    end;

    // emitente
    p :=r.NodeByName('emit');
    emit.CNPJ  :=p.ReadString('CNPJ');
    emit.xNome :=p.ReadString('xNome');
    emit.xFant :=p.ReadString('xFant');
    emit.IE   :=p.ReadString('IE');
    emit.CRT	:=p.ReadInteger('CRT'); //v2.00
    p :=p.NodeByName('enderEmit');
    if p <> nil then
    begin
      emit.ender.xLgr    :=p.ReadString('xLgr');
      emit.ender.nro     :=p.ReadString('nro');
      emit.ender.xCpl    :=p.ReadString('xCpl');
      emit.ender.xBairro :=p.ReadString('xBairro');
      emit.ender.cMun    :=p.ReadInteger('cMun');
      emit.ender.xMun    :=p.ReadString('xMun');
      emit.ender.UF      :=p.ReadString('UF');
      emit.ender.CEP     :=p.ReadString('CEP');
      emit.ender.cPais   :=p.ReadInteger('cPais');
      emit.ender.xPais   :=p.ReadString('xPais');
      emit.ender.fone    :=p.ReadString('fone');
    end;

    // dest/rem
    p :=r.NodeByName('dest');
    if p <> nil then
    begin
      if p.ReadString('CNPJ')<>'' then
      begin
        dest.CNPJ  :=p.ReadString('CNPJ');
      end
      else if p.ReadString('CPF')<>'' then
      begin
        dest.CPF  :=p.ReadString('CPF');
      end
      else begin
        dest.idEstrangeiro :=p.ReadString('idEstrangeiro');
      end;
      dest.xNome:=p.ReadString('xNome');
      dest.IE   :=p.ReadString('IE');
      p :=p.NodeByName('enderDest');
      if p <> nil then
      begin
        dest.ender.xLgr    :=p.ReadString('xLgr');
        dest.ender.nro     :=p.ReadString('nro');
        dest.ender.xCpl    :=p.ReadString('xCpl');
        dest.ender.xBairro :=p.ReadString('xBairro');
        dest.ender.cMun    :=p.ReadInteger('cMun');
        dest.ender.xMun    :=p.ReadString('xMun');
        dest.ender.UF      :=p.ReadString('UF');
        dest.ender.CEP     :=p.ReadString('CEP');
        dest.ender.cPais   :=p.ReadInteger('cPais');
        dest.ender.xPais   :=p.ReadString('xPais');
        dest.ender.fone    :=p.ReadString('fone');
      end;
    end;

    // det
    for I :=0 to r.NodeCount -1 do
    begin
      if r.Nodes[I].ReadAttributeInteger('nItem') > 0 then
      begin
        det :=Self.det.Add ;
        pro :=det.prod ;
        imp :=det.imposto;
        // *******
        // produto
        // *******
        p   :=r.Nodes[I].NodeByName('prod');
//        pro :=det.ProdList.Add;
        pro.cProd   :=p.ReadString('cProd');
        pro.cEAN    :=p.ReadString('cEAN');
        pro.xProd   :=p.ReadString('xProd');
        pro.NCM     :=p.ReadString('NCM');
        pro.EXTIPI  :=p.ReadString('EXTIPI');
        pro.CFOP    :=p.ReadInteger('CFOP');
        pro.uCom    :=p.ReadString('uCom');
        pro.qCom    :=p.ReadFloat('qCom');
        pro.vUnCom  :=p.ReadFloat('vUnCom');
        pro.vProd   :=p.ReadFloat('vProd');
        pro.cEANTrib:=p.ReadString('cEANTrib');
        pro.uTrib   :=p.ReadString('uTrib');
        pro.qTrib   :=p.ReadFloat('qTrib');
        pro.vUnTrib :=p.ReadFloat('vUnTrib');
        pro.vFrete	:=p.ReadFloat('vFrete');
        pro.vSeg    :=p.ReadFloat('vSeg');
        pro.vDesc		:=p.ReadFloat('vDesc');
        pro.vOutro	:=p.ReadFloat('vOutro');
        pro.indTot	:=p.ReadInteger('indTot');

        if p.NodeByName('med') <> nil then
        begin
          p	:=p.NodeByName('med');
          pro.med.nLote	:=p.ReadString('nLote');
          pro.med.qLote :=p.ReadFloat('qLote');
          pro.med.dFab	:=p.ReadDateTime('dFab');
          pro.med.dVal	:=p.ReadDateTime('dVal');
          pro.med.vPMC	:=p.ReadFloat('vPMC');
        end
        else if p.NodeByName('comb') <> nil then
        begin
          p	:=p.NodeByName('comb');
          pro.comb.cProdANP :=p.ReadInteger('cProdANP');
          pro.comb.CODIF    :=p.ReadString('CODIF');
          pro.comb.qTemp    :=p.ReadFloat('qTemp');
          pro.comb.UFCons   :=p.ReadString('UFCons');
          p	:=p.NodeByName('CIDE');
          if p<>nil then
          begin
            pro.comb.CIDE.qBCProd   :=p.ReadFloat('qBCProd');
            pro.comb.CIDE.vAliqProd :=p.ReadFloat('vAliqProd');
            pro.comb.CIDE.vCIDE     :=p.ReadFloat('vCIDE');
          end;
        end;

        // *******
        // imposto
        // *******

        // ICMS Normal e ST
        p :=r.Nodes[I].NodeByName('imposto');

        imp.vTotTrib :=p.ReadFloat('vTotTrib') ;

        p :=p.NodeByName('ICMS');

        if p.NodeByName('ICMS00')<>nil then
        begin
          p :=p.NodeByName('ICMS00');
          imp.ICMS.CST  :=cst00;
        end

        else if p.NodeByName('ICMS10')<>nil then
        begin
          p :=p.NodeByName('ICMS10');
          imp.ICMS.CST  :=cst10;
        end

        else if p.NodeByName('ICMS20')<>nil then
        begin
          p :=p.NodeByName('ICMS20');
          imp.ICMS.CST    :=cst20 ;
        end

        else if p.NodeByName('ICMS30')<>nil then
        begin
          p :=p.NodeByName('ICMS30');
          imp.ICMS.CST		 :=cst30 ;
        end

        else if p.NodeByName('ICMS40')<>nil then
        begin
          p :=p.NodeByName('ICMS40')	;
          imp.ICMS.CST  :=TnfeCSTIcms(p.ReadInteger('CST', 40));
        end

        else if p.NodeByName('ICMS51')<>nil then
        begin
          p :=p.NodeByName('ICMS51');
          imp.ICMS.CST    :=cst51;
        end

        else if p.NodeByName('ICMS60')<>nil then
        begin
          p :=p.NodeByName('ICMS60');
          imp.ICMS.CST		:=cst60;
        end

        else if p.NodeByName('ICMS70')<>nil then
        begin
          p :=p.NodeByName('ICMS70');
          imp.ICMS.CST  :=cst70;
        end

        else if p.NodeByName('ICMS90') <> nil then
        begin
          p :=p.NodeByName('ICMS90');
          imp.ICMS.CST		:=cst90;
        end

        { TODO : TRATAR O SIMPLES }
        else begin
          if p.NodeByName('ICMSSN101') <> nil then
          begin
            p :=p.NodeByName('ICMSSN101');
            imp.ICMS.CSOSN :=csosn101 ;
          end
          else if p.NodeByName('ICMSSN102') <> nil then
          begin
            p :=p.NodeByName('ICMSSN102');
            imp.ICMS.CSOSN :=csosn102 ;
          end
        end;

        imp.ICMS.orig   :=TnfeOrig(p.ReadInteger('orig'))	;
        imp.ICMS.modBC  :=TnfeModBCIcms(p.ReadInteger('modBC'));
        imp.ICMS.vBC		:=p.ReadFloat('vBC');
        imp.ICMS.pRedBC :=p.ReadFloat('pRedBC');
        imp.ICMS.pICMS	:=p.ReadFloat('pICMS');
        imp.ICMS.vICMS	:=p.ReadFloat('vICMS');
        imp.ICMS.modBCST	:=TnfeModBCIcmsST(p.ReadInteger('modBCST'))	;
        imp.ICMS.pMVAST   :=p.ReadFloat('pMVAST');
        imp.ICMS.pRedBCST :=p.ReadFloat('pRedBCST');
        imp.ICMS.vBCST		:=p.ReadFloat('vBCST');
        imp.ICMS.pICMSST	:=p.ReadFloat('pICMSST');
        imp.ICMS.vICMSST	:=p.ReadFloat('vICMSST');
        imp.ICMS.vBCSTRet   :=p.ReadFloat('vBCSTRet');
        imp.ICMS.vICMSSTRet :=p.ReadFloat('vICMSSTRet');

        imp.ICMS.pCredSN :=p.ReadFloat('pCredSN')  ;
        imp.ICMS.vCredICMSSN :=p.ReadFloat('vCredICMSSN')  ;

        // IPI
        p :=r.Nodes[I].NodeByName('imposto').NodeByName('IPI');
        if p<>nil then
        begin
          imp.IPI.clEnq :=p.ReadString('clEnq') ;
          imp.IPI.CNPJProd :=p.ReadString('CNPJProd');
          imp.IPI.cSelo :=p.ReadString('cSelo') ;
          imp.IPI.qSelo :=p.ReadInteger('qSelo');
          imp.IPI.cEnq :=p.ReadString('cEnq') ;
          if p.NodeByName('IPITrib') <> nil then
          begin
            p :=p.NodeByName('IPITrib');
            imp.IPI.CST	:=TnfeCSTIpi(p.ReadInteger('CST'));
            imp.IPI.vBC	:=p.ReadFloat('vBC')	;
            imp.IPI.pIPI:=p.ReadFloat('pIPI')	;
            imp.IPI.qUnid	:=p.ReadFloat('qUnid');
            imp.IPI.vUnid	:=p.ReadFloat('vUnid');
            imp.IPI.vIPI:=p.ReadFloat('vIPI');
          end
          else begin
            p :=p.NodeByName('IPINT');
            imp.IPI.CST :=TnfeCSTIpi(p.ReadInteger('CST'));
          end;
        end;

      end;

    end;

    // totais
    p :=r.NodeByName('total').NodeByName('ICMSTot');
    total.vBC    :=p.ReadFloat('vBC');
    total.vICMS  :=p.ReadFloat('vICMS');
    total.vBCST  :=p.ReadFloat('vBCST');
    total.vST    :=p.ReadFloat('vST');
    total.vProd  :=p.ReadFloat('vProd');
    total.vFrete :=p.ReadFloat('vFrete');
    total.vSeg   :=p.ReadFloat('vSeg');
    total.vDesc  :=p.ReadFloat('vDesc');
    total.vII    :=p.ReadFloat('vII');
    total.vIPI   :=p.ReadFloat('vIPI');
    total.vPIS   :=p.ReadFloat('vPIS');
    total.vCOFINS:=p.ReadFloat('vCOFINS');
    total.vOutro :=p.ReadFloat('vOutro');
    total.vNF    :=p.ReadFloat('vNF');
    total.vTotTrib :=p.ReadFloat('vTotTrib');

    // transportes
    p :=r.NodeByName('transp');
    transp.modFrete  :=TnfeFret(p.ReadInteger('modFrete'));
    if p.NodeByName('transporta')<>nil then
    begin
      p :=p.NodeByName('transporta') ;
      if p.ReadString('CNPJ')<>'' then
      begin
        transp.transporta.CNPJ :=p.ReadString('CNPJ');
      end
      else
      begin
        transp.transporta.CPF :=p.ReadString('CPF');
      end;
      transp.transporta.xNome    :=p.ReadString('xNome');
      transp.transporta.IE       :=p.ReadString('IE');
      transp.transporta.xEnder   :=p.ReadString('xEnder');
      transp.transporta.xMun     :=p.ReadString('xMun');
      transp.transporta.UF       :=p.ReadString('UF');
    end;
    p :=r.NodeByName('transp');
    if p.NodeByName('veicTransp')<>nil then
    begin
      p :=p.NodeByName('veicTransp') ;
      transp.veicTransp.placa :=p.ReadString('placa') ;
      transp.veicTransp.UF 		:=p.ReadString('UF') ;
      transp.veicTransp.RNTC	:=p.ReadString('RNTC') ;
    end;
    p :=r.NodeByName('transp');
    if p.NodeByName('vol')<>nil then
    begin
        p :=p.NodeByName('vol') ;
        transp.vol.qVol :=p.ReadInteger('qVol');
        transp.vol.esp	:=p.ReadString('esp') ;
        transp.vol.marca:=p.ReadString('marca');
        transp.vol.nVol	:=p.ReadString('nVol');
        transp.vol.pesoL:=p.ReadFloat('pesoL');
        transp.vol.pesoB:=p.ReadFloat('pesoB');
    end	;

    // cobranças
    p :=r.NodeByName('cobr');
    if p<>nil then
    begin
      p :=r.NodeByName('cobr');
      // fat
      if p.NodeByName('fat')<>nil then
      begin
        cobr.fat.nFat :=p.NodeByName('fat').ReadString('nFat');
        cobr.fat.vOrig:=p.NodeByName('fat').ReadFloat('vOrig');
        cobr.fat.vDesc:=p.NodeByName('fat').ReadFloat('vDesc');
        cobr.fat.vLiq	:=p.NodeByName('fat').ReadFloat('vLiq');
      end;
      // dups
      for i :=0 to p.NodeCount -1 do
      begin
        if p.Nodes[i].ReadString('nDup')<>'' then
        begin
          dup	:=cobr.dup.Add	;
          dup.nDup	:=p.Nodes[i].ReadString('nDup')	;
          dup.dVenc :=p.Nodes[i].ReadDateTime('dVenc');
          dup.vDup	:=p.Nodes[i].ReadFloat('vDup');
        end;
      end;
    end;

    //Grupo YA – Formas de Pagamento (NFC-e)
    p :=r.NodeByName('pag');
    if p<>nil then
    begin
      for i :=0 to r.NodeCount -1 do
      begin
        p :=r.Nodes[i];
        if p.ReadInteger('tPag') > 0 then
        begin
          fpg :=pag.Add;
          fpg.tPag :=TnfeFormPagto(p.ReadInteger('tPag'));
          fpg.vPag :=p.ReadFloat('vPag');
          p :=p.NodeByName('card');
          if p <> nil then
          begin
            fpg.card.CNPJ :=p.ReadString('CNPJ') ;
            fpg.card.Band :=TCardBand(p.ReadInteger('Band'));
            fpg.card.cAut :=p.ReadString('cAut');
          end;
        end;
      end;
    end;

    // info adicionais
    p :=r.NodeByName('infAdic');
    if p<>nil then
    begin
      infAdic.infCpl	:=p.ReadString('infCpl');
    end;
  finally
    doc.Free;
  end;
end;

function TNFe.Validar(out codStt: Integer; out motStt: String; const localSchema: string): Boolean;
var s:string;
var i:Integer;
var pro: TnfeProduto;  //Tprod;
//var imp: TnfeImposto; //Timposto;
var det: TnfeDet;
//var dup :TdupList.Tdup;
var schema:string ;
begin
    // default
    codStt  :=000;
    motStt  :='';

    //****************
    //validação prévia
    //****************

    // valida ide
    if Tnfeutil.IsEmpty(ide.natOp) then
    begin
      codStt  :=Self.COD_REJ_XML_MAU_FORMADO;
      motStt  :='Rejeição: Natureza de operação não informada!';
    end

    // emit
//    else if not isCGC(emit.CNPJ) then
//    begin
//      codStt  :=Self.COD_REJ_FALHA_SCHEMA_XML; //207;
//      motStt  :=Format('Rejeição: CNPJ do emitente inválido!'#13'[%s|%s]',[
//                  emit.CNPJ,emit.xNome]);
//    end
    else if not Tnfeutil.ValidaCEP(emit.ender.UF, emit.ender.CEP) then
    begin
      codStt  :=Self.COD_REJ_FALHA_SCHEMA_XML;
      motStt  :=Format('Rejeição: CEP inválido!'#13'[%s]',[emit.xNome]);
    end

    // Valida dest
//    else if (dest.CPF<>'') and (not isCPF(dest.CPF)) then
//    begin
//      codStt  :=Self.COD_REJ_FALHA_SCHEMA_XML; //237;
//      motStt  :=Format('Rejeição: CPF do destinatário inválido!'#13'[%s|%s]',[
//                  dest.CPF,dest.xNome]);
//    end
//    else if (dest.CNPJ<>'') and (not isCGC(dest.CNPJ)) then
//    begin
//      codStt  :=Self.COD_REJ_FALHA_SCHEMA_XML; //208;
//      motStt  :=Format('Rejeição: CNPJ do destinatário inválido!'#13'[%s|%s]',[
//                  dest.CNPJ,dest.xNome]);
//    end
    else if Tnfeutil.IsEmpty(dest.ender.nro) then
    begin
      codStt  :=Self.COD_REJ_FALHA_SCHEMA_XML;
      motStt  :=Format('Rejeição: Número de logradouro do destinatário não informado!'#13'[%s]',[dest.xNome]);
    end
    else if Tnfeutil.IsEmpty(dest.ender.xBairro) then
    begin
      codStt  :=Self.COD_REJ_FALHA_SCHEMA_XML;
      motStt  :=Format('Rejeição: Bairro do destinatário não informado!'#13'[%s]',[dest.xNome]);
    end
    else if dest.ender.cMun = 0 then
    begin
      codStt  :=Self.COD_REJ_FALHA_SCHEMA_XML;
      motStt  :=Format('Rejeição: Código município de IBGE do destinatário não informado!'#13'[%s]',[dest.ender.xMun]);
    end
    else if Tnfeutil.IsEmpty(dest.ender.xMun) then
    begin
      codStt  :=Self.COD_REJ_FALHA_SCHEMA_XML;
      motStt  :=Format('Rejeição: Município do destinatário não informado!'#13'[%s]',[dest.xNome]);
    end
    else if Tnfeutil.IsEmpty(dest.ender.UF) then
    begin
      codStt  :=Self.COD_REJ_FALHA_SCHEMA_XML;
      motStt  :=Format('Rejeição: Unidade federativa no município do destinatário não informada!'#13'[%s]',[dest.ender.xMun]);
    end
    else if not Tnfeutil.ValidaCEP(dest.ender.UF, dest.ender.CEP) then
    begin
      codStt  :=Self.COD_REJ_FALHA_SCHEMA_XML;
      motStt  :=Format('Rejeição: CEP inválido no cadastro do destinatário!'#13'[%s]',[dest.xNome]);
    end
    else if dest.ender.fone<>'' then
    begin
      if not(Length(dest.ender.fone)in[6..14])then
      begin
        codStt  :=Self.COD_REJ_FALHA_SCHEMA_XML;
        motStt  :=Format('Rejeição: Fone inválido no cadastro do destinatário!'#13'[%s]',[dest.xNome]);
      end;
    end;

    Result  :=codStt = 000;

    if Result then
    begin
      if Tnfeutil.ValidaCodMun(dest.ender.cMun) then
      begin
        if not Tnfeutil.ValidaCodMun(dest.ender.UF, dest.ender.cMun) then
        begin
          codStt  :=275;
          motStt  :=Format('Rejeição: Código município do destinatário difere da UF!'#13'[%s(%d/%s)]',[
                    dest.ender.xMun,
                    dest.ender.cMun,
                    dest.ender.UF]);
        end;
      end
      else begin
        codStt  :=274;
        motStt  :=Format('Rejeição: Código município do destinatário inválido!'#13'[%s(%d)]',[
                    dest.ender.xMun,
                    dest.ender.cMun]);
      end;

    end;

    Result  :=codStt = 000;

    if Result then
    begin
      // valida transp
      s :=transp.veicTransp.placa;
      if not Tnfeutil.ValidaPlaca(transp.veicTransp.placa, s) then
      begin
        codStt  :=Self.COD_REJ_FALHA_SCHEMA_XML ;
        motStt  :=Format('Rejeição: Placa do transportador incorreta!'#13'[%s(%s)]',[
                    transp.transporta.xNome ,
                    transp.veicTransp.placa]);
      end;
      transp.veicTransp.placa :=s;

      if not Tnfeutil.IsEmpty(transp.transporta.CNPJ) then
      begin
//        if not isCGC(transp.transporta.CNPJ) then
//        begin
//          codStt  :=Self.COD_REJ_FALHA_SCHEMA_XML;
//          motStt  :=Format('Rejeição: CNPJ do transportador invalido!'#13'[%s(%s)]',[
//                      transp.transporta.xNome ,
//                      transp.transporta.CNPJ]);
//        end;
      end;
    end;

    Result  :=codStt = 000;

    if Result then
    begin

      // valida itens
      for I :=0 to Self.det.Count -1 do
      begin
          det :=Self.det.Items[I];
          pro :=det.prod;
//          imp :=det.imposto;
          if pro<>nil then
          begin

              if(pro.NCM='00000000')or not(Length(pro.NCM) in[2,8]) then
              begin
                  codStt  :=Self.COD_REJ_FALHA_SCHEMA_XML;
                  motStt  :=Format('Rejeição: NCM invalido ou não informado!'#13'Item [%s|%s(%s)]',[
                                  pro.cProd ,
                                  pro.xProd ,
                                  pro.NCM]);
                  Break;
              end;

              if pro.CFOP = 0 then
              begin
                  codStt  :=Self.COD_REJ_FALHA_SCHEMA_XML;
                  motStt  :=Format('Rejeição: CFOP não informado!'#13'Item [%s|%s]',[
                                  pro.cProd  ,
                                  pro.xProd]);
                  Break;
              end ;

              if pro.med.nLote<>'' then
              begin
              		if YearOf(pro.med.dFab)<=1900 then
                  begin
                      codStt  :=Self.COD_REJ_FALHA_SCHEMA_XML;
                      motStt  :=Format('Rejeição: Data de fabricação do lote não informada!'#13'Item [%s|%s]',[
                                      pro.cProd  ,
                                      pro.xProd]);
                      Break;
                  end;
              		if YearOf(pro.med.dVal)<=1900 then
                  begin
                      codStt  :=Self.COD_REJ_FALHA_SCHEMA_XML;
                      motStt  :=Format('Rejeição: Data de validade do lote não informada!'#13'Item [%s|%s]',[
                                      pro.cProd  ,
                                      pro.xProd]);
                      Break;
                  end;
//                  if pro.med.vPMC=0.00 then
//                  begin
//                      codStt  :=225;
//                      motStt  :=Format('Preço máximo consumidor não informado!'#13'Item [%s|%s]',[
//                                      pro.cProd  ,
//                                      pro.xProd]);
//                      Break;
//                  end;
              end;

          end;
      end;

      if Self.det.Count = 0 then
      begin
          codStt  :=Self.COD_REJ_FALHA_SCHEMA_XML;
          motstt  :='Rejeição: Nota Fiscal sem produtos informados!';
      end;

    end;

    Result  :=codStt = 000;

    //******************************
    //validação oficial dos schema´s
    //******************************

    if Result then
    begin
        if DirectoryExists(localSchema) then
        begin
            schema :=ExcludeTrailingPathDelimiter(localSchema);
            schema :=schema +Format('\NFe_v%s.xsd',[NFE_VER_NFE]) ;
            Result :=Tnfeutil.xml_Validar( Self.XML,
                                           NFE_PORTALFISCAL_INF_BR ,
                                           schema  ,
                                           motStt  );
        end ;
        if not Result then
        begin
            codStt  :=Self.COD_REJ_XML_MAU_FORMADO;
        end;
    end;

end;

{ TdupList }

function TdupList.Add: Tdup;
begin
  Result := Tdup.Create;
  Result.CParent := Self;
  Result.Index   := Self.Count;
  inherited Add(Result);
end;

function TdupList.Get(Index: Integer): Tdup;
begin
  Result := inherited Items[Index];
end;

function TdupList.IndexOf(nDup: string): Tdup;
var i:integer;
begin
  Result  :=nil;
  for i :=0 to Self.Count -1 do
  begin
    if Self.Items[i].nDup = nDup then
    begin
      Result := Self.Items[i];
      Break;
    end;
  end;
end;

{ Tcobr }

constructor Tcobr.Create;
begin
  inherited Create;
  fat :=Tfat.Create;
  dup :=TdupList.Create;
end;

destructor Tcobr.Destroy;
begin
  fat.Destroy;
  dup.Destroy;
  inherited Destroy;
end;

{ TobsContList }

function TobsContList.Add: TobsCont;
begin
  Result := TobsCont.Create;
  Result.Index   := Self.Count;
  inherited Add(Result);
end;

function TobsContList.Get(Index: Integer): TobsCont;
begin
    Result := inherited Items[Index];
end;

{ TinfAdic }

constructor TinfAdic.Create;
begin
  inherited Create;
  obsCont   :=TobsContList.Create;
end;

destructor TinfAdic.Destroy;
begin
  obsCont.Destroy;
  inherited Destroy;
end;

procedure TinfAdic.setinfAdFisco(const Value: string);
begin
  	if Value<>'' then
    begin
        finfAdFisco :=Tnfeutil.TrataString(Value, 2000) ;
    end;
end;

procedure TinfAdic.setinfCpl(const Value: string);
begin
  	if Value<>'' then
    begin
        finfCpl :=Tnfeutil.TrataString(Value, 5000) ;
    end;
end;

{$ENDREGION}

{ TretConsReciNFe }

function TretConsReciNFe.CreateNew: TinfProt;
begin
  Result :=TinfProt.Create;
//  Result.CParent := Self;
  Result.Index   := Self.Count;
  inherited Add(Result);
end;

function TretConsReciNFe.Get(Index: Integer): TinfProt;
begin
  Result := inherited Items[Index];
end;

function TretConsReciNFe.IndexOfKey(const Key: String): TinfProt;
var i:integer;
begin
  Result  :=nil;
  for i :=0 to Self.Count -1 do
  begin
    if Self.Items[i].chNFe = Key then
    begin
      Result := Self.Items[i];
      Break;
    end;
  end;
end;

{ TnfeProc }

constructor TnfeProc.Create (NFe: TNFe; ProtNFe:TinfProt);
begin
    inherited Create;
    FNFe    :=NFe ;
    FProtNFe:=ProtNFe;
end;

destructor TnfeProc.Destroy;
begin
//  FNFe.Destroy      ;
//  FprotNFe.Destroy  ;
  inherited Destroy ;
end;

function TnfeProc.Execute(APath: string): Boolean;
begin
    Result	:=Assigned(FNFe) and Assigned(FProtNFe) ;
    if Result	then
    begin

    end;
end;

{ TICMSTot }

constructor TICMSTot.Create(AOwner: TNFe);
begin
    inherited Create;
    Owner :=AOwner	;
    FvBC :=0;
    FvICMS :=0;
    FvBCST :=0;
    FvST :=0;
    FvProd :=0;
    FvFrete :=0;
    FvSeg :=0;
    FvDesc :=0;
    FvII :=0;
    FvIPI :=0;
    FvOutro :=0;
end;

procedure TICMSTot.DoReCalc;
var
  	I: Integer;
    pro: TnfeProduto;
    imp: TnfeImposto;
    det: TnfeDet;
begin
    FvBC :=0;
    FvICMS:=0;
    FvBCST:=0;
    FvST :=0;
    FvProd :=0;
    FvFrete:=0;
    FvSeg :=0;
    FvDesc:=0;
    FvII :=0;
    FvIPI:=0;
    FvOutro:=0;
    FvTotTrib:=0;
    for I :=0 to Owner.det.Count -1 do
    begin
        det :=Owner.det.Items[I];
        pro :=det.prod;
        imp :=det.imposto;

        FvProd  :=FvProd +pro.vProd ;
        FvFrete :=FvFrete +pro.vFrete;
        FvSeg   :=FvSeg +pro.vSeg ;
        FvDesc  :=FvDesc +pro.vDesc ;
        FvOutro :=FvOutro +pro.vOutro;

        FvTotTrib :=FvTotTrib +imp.vTotTrib ;
        FvBC :=FvBC +imp.ICMS.vBC;
        FvICMS:=FvICMS  +imp.ICMS.vICMS;
        FvBCST:=FvBCST  +imp.ICMS.vBCST;
        FvST :=FvST +imp.ICMS.vICMSST;

        FvIPI:=FvIPI +imp.IPI.vIPI ;
        FvII:=FvII +imp.II.vII ;

//        case imp.ICMS.icmsst of
{        case imp.ICMS.CST of
          cst00:
          begin
            FvBC  :=FvBC    +imp.ICMS.vBC;
            FvICMS:=FvICMS  +imp.ICMS.vICMS;
          end;

          cst10:
          begin
            FvBC :=FvBC +imp.ICMS.vBC;
            FvICMS:=FvICMS  +imp.ICMS.vICMS;
            FvBCST:=FvBCST  +imp.ICMS.vBCST;
            FvST :=FvST +imp.ICMS.vICMSST;
          end;

          cst20:
          begin
            FvBC  :=FvBC    +imp.ICMS.vBC;
            FvICMS:=FvICMS  +imp.ICMS.vICMS;
          end;

          cst51:
          begin
            FvBC  :=FvBC    +imp.ICMS.vBC;
            FvICMS:=FvICMS  +imp.ICMS.vICMS;
          end;

          icmsst70:
          begin
            FvBC :=FvBC +imp.ICMS.vBC;
            FvICMS:=FvICMS  +imp.ICMS.vICMS;
            FvBCST:=FvBCST  +imp.ICMS.vBCST;
            FvST :=FvST +imp.ICMS.vICMSST;
          end;

          icmsst90:
          begin
            FvBC :=FvBC +imp.ICMS.vBC;
            FvICMS:=FvICMS  +imp.ICMS.vICMS;
            FvBCST:=FvBCST  +imp.ICMS.vBCST;
            FvST :=FvST +imp.ICMS.vICMSST;
          end;
        end;
}
    end;
    FvNF :=(FvProd -FvDesc) +FvST +FvFrete +FvSeg +FvOutro +FvII +FvIPI;
end;

{ TnfePgtos }

function TnfePgtos.Add: TnfePgto;
begin
    Result :=TnfePgto.Create ;
    inherited Add(Result);
end;

constructor TnfePgtos.Create(AOwner: TNFe);
begin
  Owner :=AOwner ;

end;

function TnfePgtos.Get(Index: Integer): TnfePgto;
begin
    Result :=inherited Items[Index] ;
end;

{ TRetConsSitNFe }

constructor TRetConsSitNFe.Create(const AVersao: string);
begin
    inherited Create();
    FVersao :=AVersao ;
end;


{ TnfeEvento }

function TnfeEvento.Assinar(Cert: ICertificate2;
  out retMsg: String): Boolean;
var outMsg: String;
begin
    Result :=False;
    if Cert<>nil then
    begin
        Result  :=Tnfeutil.Assinar(Self.XML	,
                                    Cert 		,
                                    outMsg  ,
                                    retMsg);

        if Result then
        begin
            fXML	:=outMsg;
        end;
    end
    else
    begin
        retMsg :='Certificado não informado!';
    end;
end;

constructor TnfeEvento.Create;
begin
    detEvento :=TnfeDetEvento.Create ;
end;

destructor TnfeEvento.Destroy;
begin
    detEvento.Destroy ;
    inherited;
end;

procedure TnfeEvento.DoFill;
var
    xml: TNativeXml;
    r: TsdElement;
    n: TXmlNode;
begin
    xml :=TNativeXml.Create;
    try
        xml.XmlFormat      :=xfCompact;
        xml.FloatSignificantDigits :=2;
        xml.FloatAllowScientific:=False;

        xml.LoadFromFile(fXML);
        r :=xml.Root ;
        n :=r.NodeByName('infEvento') ;
        if n<>nil then
        begin
            Self.cOrgao :=n.ReadInteger('cOrgao') ;
            Self.tpAmb  :=TnfeAmb(n.ReadInteger('tpAmb'));
            Self.CNPJ :=n.ReadString('CNPJ') ;
            Self.chNFe:=n.ReadString('chNFe');
            Self.dhEvento:=n.ReadDateTime('dhEvento');
            Self.tpEvento :=n.ReadInteger('tpEvento');
            Self.nSeqEvento :=n.ReadInteger('nSeqEvento');
            Self.verEvento:=n.ReadString('verEvento');
            n :=n.NodeByName('detEvento');
            if n<>nil then
            begin
                detEvento.versao    :=n.ReadAttributeString('versao');
                detEvento.descEvento:=n.ReadString('descEvento');

                case tpEvento of
                    110110: detEvento.xCorrecao  :=n.ReadString('xCorrecao');
                    110111:
                    begin
                        detEvento.nProt :=n.ReadString('nProt');
                        detEvento.xJust :=n.ReadString('xJust');
                    end;
                end;
            end;
        end;
    finally
        xml.Free ;
    end;
end;

function TnfeEvento.GetId: string;
begin
    Result :='ID' ;
    Result :=Result +IntToStr(tpEvento);
    Result :=Result +chNFe  ;
    Result :=Result +Tnfeutil.FInt(nSeqEvento,2);
end;

function TnfeEvento.GetXML: String;
var
//    DocXML: TNativeXml;
  xml: TNativeXml;
  r: TsdElement;
  n: TXmlNode ;
begin
  Result :='';
  if PosEx('<Signature', fXML)>0 then
  begin
    Result	:=fXML ;
  end
  else begin
    xml :=TNativeXml.CreateName('evento');
    try
      xml.XmlFormat :=xfCompact;
      xml.FloatSignificantDigits:=2;
      xml.FloatAllowScientific  :=False;
      xml.UseLocalBias :=True;

      case tpEvento of
        EVT_TYP_CCE: fVersao :=NFE_VER_EVT_CCE;
        EVT_TYP_CAN: fVersao :=NFE_VER_EVT_CAN;
      end;

      r :=xml.Root;
      r.AttributeAdd('versao', fVersao);
      r.AttributeAdd('xmlns' , URL_PORTALFISCAL_INF_BR_NFE);

      n :=r.NodeNew('infEvento');
      n.AttributeAdd('Id', Self.Id);
      n.WriteInteger('cOrgao', Self.cOrgao);
      n.WriteInteger('tpAmb', Ord(Self.tpAmb)+1);
      n.WriteString('CNPJ', Self.CNPJ);
      n.WriteString('chNFe', Self.chNFe);
      n.WriteDateTime('dhEvento', Self.dhEvento);
      n.WriteInteger('tpEvento', Self.tpEvento);
      n.WriteInteger('nSeqEvento', Self.nSeqEvento);
      n.WriteString('verEvento', fVersao);

      n :=n.NodeNew('detEvento');
      n.AttributeAdd('versao', fVersao);

      //n.WriteString('descEvento', detEvento.descEvento);
      case tpEvento of
          EVT_TYP_CCE:
          begin
              n.WriteString('descEvento', 'Carta de Correcao');
              n.WriteString('xCorrecao', detEvento.xCorrecao);
              n.WriteString('xCondUso', detEvento.xCondUso);
          end;
          EVT_TYP_CAN:
          begin
              n.WriteString('descEvento', 'Cancelamento');
              n.WriteString('nProt', detEvento.nProt);
              n.WriteString('xJust', detEvento.xJust);
          end;
      end;

      Result :=r.WriteToString ;

    finally
      xml.Free ;
    end;
  end;
end;

procedure TnfeEvento.SetXML(const AValue: String);
begin
  if AValue<>'' then
  begin
    fXML :=AValue ;
    DoFill ;
  end;
end;

{ TnfeDetEvento }

function TnfeDetEvento.GetxCondUso: string;
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

procedure TnfeDetEvento.SetxCorrecao(const AValue: String);
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

procedure TnfeDetEvento.SetxJust(const AValue: String);
begin
    if (Length(AValue) < 15)and(Length(AValue) > 255) then
    begin
        raise Exception.Create('A justificativa do cancelamento deve ter no min 15 e no max 255 bytes!');
    end
    else
    begin
        fxJust :=Tnfeutil.TrataString(AValue) ;
    end;
end;



{ TnfeImposto }

constructor TnfeImposto.Create(AOwner: TnfeDet);
begin
  inherited Create;
  ICMS :=TnfeICMS.Create ;
  IPI :=TnfeIPI.Create;
  II :=TnfeII.Create;
  PIS :=TnfePIS.Create;
  PISST :=TnfePISST.Create;
  COFINS:=TnfeCOFINS.Create;
  COFINSST :=TnfeCOFINSST.Create;
end;

destructor TnfeImposto.Destroy;
begin
  ICMS.Destroy;
  IPI.Destroy;
  II.Destroy;
  PIS.Destroy;
  PISST.Destroy;
  COFINS.Destroy;
  COFINSST.Destroy;
  inherited;
end;

{ TnfeDet }

constructor TnfeDet.Create;
begin
  prod :=TnfeProduto.Create(Self) ;
  imposto :=TnfeImposto.Create(Self) ;
end;

destructor TnfeDet.Destroy;
begin
  prod.Destroy ;
  imposto.Destroy;
  inherited;
end;

procedure TnfeDet.SetinfAdProd(const Value: string);
begin
  FinfAdProd :=Tnfeutil.TrataString(Value, 500) ;
end;

{ TnfeDets }

function TnfeDets.Add: TnfeDet;
begin
  Result :=TnfeDet(inherited Add);
  Result.Create ;
end;

constructor TnfeDets.Create(AOwner: TNFe);
begin
  inherited Create(TnfeDet);
end;

function TnfeDets.Get(Index: Integer): TnfeDet;
begin
  Result := TnfeDet(inherited GetItem(Index));
end;

end.
