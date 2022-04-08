SET NAMES latin1;
SET FOREIGN_KEY_CHECKS=0;

BEGIN;
DROP DATABASE IF EXISTS `DB_Progetto`;
CREATE DATABASE IF NOT EXISTS `DB_Progetto`;
COMMIT;

USE `DB_Progetto`;
/*
------------------------------------------------------------------------------------------------------------------
--													TABLE STRUCTURES
------------------------------------------------------------------------------------------------------------------
*/

/* Table Structure Consumo */
DROP TABLE IF EXISTS Consumo;
CREATE TABLE Consumo(
	FK_CodiceForaggio_C VARCHAR(15) NOT NULL,
    FK_CodiceAllestimento_C VARCHAR(15) NOT NULL,
    TempoMedioConsumo FLOAT NOT NULL,
    
    PRIMARY KEY (FK_CodiceForaggio_C, FK_CodiceAllestimento_C),
    CONSTRAINT
		FOREIGN KEY (FK_CodiceForaggio_C)
        REFERENCES Foraggio(CodiceForaggio),
	CONSTRAINT
		FOREIGN KEY (FK_CodiceAllestimento_C)
        REFERENCES Allestimento(CodiceAllestimento)
);

/* Table Structure Foraggio */
DROP TABLE IF EXISTS Foraggio;
CREATE TABLE Foraggio(
		CodiceForaggio VARCHAR(15) NOT NULL,
        Proteine FLOAT NOT NULL,
        Glucidi FLOAT NOT NULL,
        Fibre FLOAT NOT NULL,
        KcalAlKg FLOAT NOT NULL,
        Stato ENUM('Fresco','Fieno','Insilato'),
        
        PRIMARY KEY(CodiceForaggio)
);

/* Table Structure Dispone F */
DROP TABLE IF EXISTS DisponeF;
CREATE TABLE DisponeF(
	FK_CodiceForaggio_D VARCHAR(15) NOT NULL,
    FK_CodiceLocale_D VARCHAR(15) NOT NULL,
	
	PRIMARY KEY(FK_CodiceForaggio_D,FK_CodiceLocale_D),
	CONSTRAINT 
		FOREIGN KEY (FK_CodiceForaggio_D)
		REFERENCES Foraggio(CodiceForaggio),
	CONSTRAINT 
		FOREIGN KEY (FK_CodiceLocale_D)
		REFERENCES Locale(CodiceLocale)
);

/* Table Structure Stato */

DROP TABLE IF EXISTS Stato;
CREATE TABLE Stato(
	CodiceRiferimento VARCHAR(15) NOT NULL,
    TimestampStato TIMESTAMP NOT NULL,
    ValoreCorrente VARCHAR(20) NOT NULL,
    TipoMisura ENUM('Livello di Riempimento','Temperatura Impostata','Intensità Luce','Foraggio Contenuto','Sostanza Disciolta') NOT NULL,
    
    PRIMARY KEY(CodiceRiferimento,TimestampStato,TipoMisura)
);

/* Table Structure Composto */
DROP TABLE IF EXISTS Composto;
CREATE TABLE Composto(
	Nome VARCHAR(20) NOT NULL,
    Tipo VARCHAR(20) NOT NULL,
    PRIMARY KEY (Nome)
);


/* Table Structure Formato */

DROP TABLE IF EXISTS Formato;
CREATE TABLE Formato(
	FK_CodiceForaggio_F VARCHAR (15) NOT NULL,
    FK_Nome_F VARCHAR (20) NOT NULL,
    Percentuale INT UNSIGNED NOT NULL,
    PRIMARY KEY (FK_CodiceForaggio_F, FK_Nome_F),
    CONSTRAINT
		FOREIGN KEY (FK_CodiceForaggio_F)
        REFERENCES Foraggio(CodiceForaggio),
	CONSTRAINT
		FOREIGN KEY (FK_Nome_F)
        REFERENCES Composto(Nome)
);

/* Table Structure Ricetta */
DROP TABLE IF EXISTS Ricetta;
CREATE TABLE Ricetta(
	NomeRicetta VARCHAR(30) NOT NULL,
    GiorniStagionatura INT UNSIGNED NOT NULL,
    NumFasi INT UNSIGNED NOT NULL,
    ZonaOrigine VARCHAR(30) NOT NULL,
    LitriLatte FLOAT NOT NULL,
	GradoDeperibilita ENUM('Basso','Medio','Alto'),
	TipoPasta ENUM ('Dura','Molle'),
    
    PRIMARY KEY(NomeRicetta)
);

/* Table Structure Fase */
DROP TABLE IF EXISTS Fase;
CREATE TABLE Fase(
	CodiceFase VARCHAR(15) NOT NULL,
    NumFase INT UNSIGNED NOT NULL,
    MinutiFase INT UNSIGNED NOT NULL,
    MinutiRiposo INT UNSIGNED NOT NULL,
    SalaturaGrammi FLOAT NOT NULL,
    TemperaturaLatte FLOAT NOT NULL,
    Descrizione VARCHAR(500) NOT NULL,
    FK_NomeRicetta_F VARCHAR(30),
    FK_CodiceProdotto_F VARCHAR(15),
    
    PRIMARY KEY(CodiceFase),
    CONSTRAINT
		FOREIGN KEY (FK_NomeRicetta_F)
        REFERENCES Ricetta(NomeRicetta),
        FOREIGN KEY (FK_CodiceProdotto_F)
        REFERENCES Prodotto(CodiceProdotto)
);

/*Table Structure Esplora*/
DROP TABLE IF EXISTS Esplora;
CREATE TABLE Esplora(
    FK_CodiceEscursione_E VARCHAR(15) NOT NULL,
    FK_NomeArea_E VARCHAR(30) NOT NULL,
    
    PRIMARY KEY(FK_CodiceEscursione_E,FK_NomeArea_E),
    CONSTRAINT
		FOREIGN KEY (FK_CodiceEscursione_E)
        REFERENCES Escursione(CodiceEscursione),
        FOREIGN KEY (FK_NomeArea_E)
        REFERENCES Area (NomeArea)
);

/* Table structure Itinerario */
DROP TABLE IF EXISTS Itinerario;
CREATE TABLE Itinerario(
	FK_CodiceEscursione_I VARCHAR (15) NOT NULL,
    TimestampArrivo TIMESTAMP NOT NULL,
    NomeArea VARCHAR(30) NOT NULL,
    MinutiSosta INT UNSIGNED NOT NULL,
    PRIMARY KEY (TimestampArrivo,FK_CodiceEscursione_I),
    CONSTRAINT
		FOREIGN KEY (FK_CodiceEscursione_I)
        REFERENCES Escursione(CodiceEscursione)
);
/* Table Structure Area*/
DROP TABLE IF EXISTS Area;
CREATE TABLE Area (
	NomeArea VARCHAR(30) NOT NULL,
    TipoArea VARCHAR(30) NOT NULL,
    
    PRIMARY KEY(NomeArea)
);

/* Table Structure Escursione*/
DROP TABLE IF EXISTS Escursione;
CREATE TABLE Escursione(
	CodiceEscursione VARCHAR(15) NOT NULL,
    DataEscursione TIMESTAMP NOT NULL,
    TimestampPrenotazione TIMESTAMP NOT NULL,
    FK_CodicePersonale_E VARCHAR(15) NOT NULL,
    FK_CodicePrenotazione_E VARCHAR(15) NOT NULL,
    
    PRIMARY KEY(CodiceEscursione),
    CONSTRAINT
		FOREIGN KEY (FK_CodicePersonale_E)
        REFERENCES Personale(CodicePersonale),
        FOREIGN KEY (FK_CodicePrenotazione_E)
        REFERENCES Prenotazione(CodicePrenotazione)
);

/* Table Structure Pagamento*/
DROP TABLE IF EXISTS Pagamento;
CREATE TABLE Pagamento(
	CodicePagamento VARCHAR(15) NOT NULL,
    MetodoPagamento ENUM('Carta di credito','Carta di debito','PayPal','Contanti'),
    TimestampPagamento TIMESTAMP NOT NULL,
    Importo FLOAT NOT NULL,
    FK_CodicePrenotazione_P VARCHAR(15) NOT NULL,
    CodiceCarta VARCHAR(16),
    
    PRIMARY KEY(CodicePagamento),
    CONSTRAINT
		FOREIGN KEY(FK_CodicePrenotazione_P)
        REFERENCES Prenotazione(CodicePrenotazione)
    
);

/* Table Structure Richiede */
DROP TABLE IF EXISTS Richiede;
CREATE TABLE Richiede(
	FK_CodiceServizio_R VARCHAR(15) NOT NULL,
    FK_CodicePrenotazione_R VARCHAR(15) NOT NULL,
    GiorniRichiesta INT UNSIGNED NOT NULL,
    
    PRIMARY KEY (FK_CodiceServizio_R,FK_CodicePrenotazione_R),
    CONSTRAINT
		FOREIGN KEY (FK_CodiceServizio_R)
        REFERENCES ServiziAggiuntivi(CodiceServizio),
        FOREIGN KEY (FK_CodicePrenotazione_R)
        REFERENCES Prenotazione(CodicePrenotazione)
);

/* Table Structure Propone */
DROP TABLE IF EXISTS Propone;
CREATE TABLE Propone(
	FK_CodiceServizio_P VARCHAR(15) NOT NULL,
    FK_CodiceStanza_P VARCHAR(15) NOT NULL,
    
    PRIMARY KEY (FK_CodiceServizio_P, FK_CodiceStanza_P),
    CONSTRAINT
		FOREIGN KEY (FK_CodiceServizio_P)
        REFERENCES ServiziAggiuntivi(CodiceServizio),
        FOREIGN KEY (FK_CodiceStanza_P)
        REFERENCES Stanza(CodiceStanza)
);

/* Table Structure Servizi Aggiuntivi */
DROP TABLE IF EXISTS ServiziAggiuntivi;
CREATE TABLE ServiziAggiuntivi(
	CodiceServizio VARCHAR(15) NOT NULL,
    NomeServizio VARCHAR(50) NOT NULL,
    CostoGiornaliero FLOAT NOT NULL,
    
    PRIMARY KEY(CodiceServizio)
);

/* Table Structure Riferita S */
DROP TABLE IF EXISTS RiferitaS;
CREATE TABLE RiferitaS(
	FK_CodiceStanza_R VARCHAR(15) NOT NULL,
    FK_CodicePrenotazione_RS VARCHAR(15) NOT NULL,
    
    PRIMARY KEY (FK_CodiceStanza_R,FK_CodicePrenotazione_RS),
    CONSTRAINT
		FOREIGN KEY (FK_CodiceStanza_R)
        REFERENCES Stanza(CodiceStanza),
        FOREIGN KEY (FK_CodicePrenotazione_RS)
        REFERENCES Prenotazione(CodicePrenotazione)
);

/* Table Structure Stanza */
DROP TABLE IF EXISTS Stanza;
CREATE TABLE Stanza(
	CodiceStanza VARCHAR(15) NOT NULL,
    PostiLetto  INT UNSIGNED NOT NULL,
    CostoGiornaliero FLOAT NOT NULL,
    TipoStanza ENUM('Stanza semplice','Suite'),
    
	PRIMARY KEY (CodiceStanza)
);

/* Table Structure Prenotazione*/
DROP TABLE IF EXISTS Prenotazione;
CREATE TABLE Prenotazione(
	CodicePrenotazione VARCHAR(15) NOT NULL,
    CostoTotale FLOAT NOT NULL,
    SaldoRimanente FLOAT NOT NULL,
    NumOspiti INT UNSIGNED NOT NULL,
    InizioSoggiorno DATE NOT NULL,
    FineSoggiorno DATE NOT NULL,
    DataPrenotazione DATE NOT NULL,
    FK_CodiceCarta_P VARCHAR(16) NOT NULL,
    
    PRIMARY KEY(CodicePrenotazione),
    CONSTRAINT
		FOREIGN KEY (FK_CodiceCarta_P)
        REFERENCES UtenteRegistrato(CodiceCartaCredito)
);

/* Table Structure Utente Non Registrato */
DROP TABLE IF EXISTS UtenteNonRegistrato;
CREATE TABLE UtenteNonRegistrato(
	CodiceCartaCredito VARCHAR(16) NOT NULL,
    Nome VARCHAR(50) NOT NULL,
    Cognome VARCHAR(50) NOT NULL,
    
    PRIMARY KEY(CodiceCartaCredito)
);
/* Table Structure Utente Registrato */
DROP TABLE IF EXISTS UtenteRegistrato;
CREATE TABLE UtenteRegistrato(
	CodiceCartaCredito VARCHAR(16) NOT NULL,
    Nome VARCHAR(50) NOT NULL,
    Cognome VARCHAR(50) NOT NULL,
    Indirizzo VARCHAR(50) NOT NULL,
    Username VARCHAR(50) NOT NULL,
    DataIscrizione TIMESTAMP NOT NULL,
    PasswordU VARCHAR(50) NOT NULL,
    CodiceFiscale VARCHAR(16) NOT NULL,
    NumTelefono VARCHAR(12) NOT NULL,
    DomandaSicurezza VARCHAR(50) NOT NULL,
    RispostaSicurezza VARCHAR(50) NOT NULL,
    TipoDocumento VARCHAR(20) NOT NULL,
    NumeroDocumento VARCHAR(9) NOT NULL,
    ScadenzaDocumento DATE NOT NULL,
    EnteRilascio VARCHAR(50) NOT NULL,
    
    UNIQUE(NumeroDocumento),
    UNIQUE(CodiceFiscale),
    PRIMARY KEY(CodiceCartaCredito)
);

/* Table Structure Recensione*/
DROP TABLE IF EXISTS Recensione;
CREATE TABLE Recensione(
	FK_CodiceProdotto_R VARCHAR(15) NOT NULL,
	Reso ENUM('Si','No') NOT NULL,
    GradimentoGenerale INT UNSIGNED NOT NULL,
    Conservazione ENUM('Scadente','Buona') NOT NULL,
    Gusto ENUM('Scadente','Normale','Buono') NOT NULL,
    QualitaPercepita ENUM('Pessima','Passabile','Buona','Ottima') NOT NULL,
    Altro VARCHAR(1000),

    
    PRIMARY KEY (FK_CodiceProdotto_R),
	CONSTRAINT
			FOREIGN KEY (FK_CodiceProdotto_R)
            REFERENCES ProdottoFinito(CodiceProdotto)
);

/* Table Structure ProdottoAcquistabile */
DROP TABLE IF EXISTS ProdottoAcquistabile;
CREATE TABLE ProdottoAcquistabile(
    Nome VARCHAR(30) NOT NULL,
    Prezzo FLOAT NOT NULL,
    PesoKg FLOAT NOT NULL,
    
    PRIMARY KEY(Nome)
);

/* Table Structure Ordine */
DROP TABLE IF EXISTS Ordine;
CREATE TABLE Ordine(
	CodiceOrdine VARCHAR(15) NOT NULL,
    DataOrdine TIMESTAMP NOT NULL,
    StatoOrdine ENUM('Pendente','In processazione','In preparazione','Spedito','Evaso'),
    NomeUtente VARCHAR(50) NOT NULL,
    Prezzo FLOAT NOT NULL,
    DataConsegna DATE NOT NULL,
    StatoConsegna ENUM('Spedita','In transito','In consegna','Consegnata'),
    HubCorrente VARCHAR(50) NOT NULL,
    HubFinale VARCHAR(50) NOT NULL,
    FK_CodiceCarta_O VARCHAR(16) NOT NULL,
    
    PRIMARY KEY (CodiceOrdine),
    CONSTRAINT
		FOREIGN KEY (FK_CodiceCarta_O)
        REFERENCES UtenteRegistrato(CodiceCartaCredito)
);


/* Table Structure Acquisto */
DROP TABLE IF EXISTS Acquisto;
CREATE TABLE Acquisto(
    FK_Nome_A VARCHAR(30) NOT NULL,
    FK_CodiceOrdine_A VARCHAR(15) NOT NULL,
    Quantita INT UNSIGNED NOT NULL,
    
    PRIMARY KEY( FK_Nome_A, FK_CodiceOrdine_A),
    CONSTRAINT
		FOREIGN KEY (FK_CodiceOrdine_A)
        REFERENCES Ordine(CodiceOrdine)
		ON UPDATE CASCADE,
	CONSTRAINT
        FOREIGN KEY (FK_Nome_A)
        REFERENCES ProdottoAcquistabile(Nome)
        ON UPDATE CASCADE
);


/* Table Structure Controllo Cantina */
DROP TABLE IF EXISTS ControlloCantina;
CREATE TABLE ControlloCantina(
	FK_CodiceCantina_C VARCHAR(15) NOT NULL,
    TimestampControllo TIMESTAMP NOT NULL,
    Temperatura INT UNSIGNED NOT NULL,
    Umidita FLOAT NOT NULL,
    
    PRIMARY KEY(FK_CodiceCantina_C,TimestampControllo),
    CONSTRAINT
		FOREIGN KEY (FK_CodiceCantina_C)
        REFERENCES Cantina(CodiceCantina)
);

/* Table Structure Cantina */

DROP TABLE IF EXISTS Cantina;
CREATE TABLE Cantina(
	CodiceCantina VARCHAR(15) NOT NULL,
    NumScaffaliC INT UNSIGNED NOT NULL,
    PRIMARY KEY(CodiceCantina)
);

/* Table Structure Magazzino */

DROP TABLE IF EXISTS Magazzino;
CREATE TABLE Magazzino(
	CodiceMagazzino VARCHAR(15) NOT NULL,
    NumScaffaliM INT UNSIGNED NOT NULL,
    PRIMARY KEY(CodiceMagazzino)
);

/* Table Structure Lavora L */

DROP TABLE IF EXISTS Lavora_L;
CREATE TABLE Lavora_L(
	FK_CodiceLotto_L VARCHAR(15) NOT NULL,
    FK_CodicePersonale_L VARCHAR(15) NOT NULL,
    PRIMARY KEY(FK_CodiceLotto_L,FK_CodicePersonale_L),
    
    CONSTRAINT
		FOREIGN KEY (FK_CodiceLotto_L)
        REFERENCES Lotto(CodiceLotto),
        FOREIGN KEY (FK_CodicePersonale_L)
        REFERENCES Personale(CodicePersonale)
);

/* Table Structure Lotto */
DROP TABLE IF EXISTS Lotto;
CREATE TABLE Lotto(
	CodiceLotto VARCHAR(15) NOT NULL,
    LabProduzione INT UNSIGNED NOT NULL,
    DurataMinProduzione FLOAT NOT NULL,
    ScadenzaLotto DATE NOT NULL,
    DataProduzione DATE NOT NULL,
    
    PRIMARY KEY(CodiceLotto)
);


/* Table Structure Scaffale */

DROP TABLE IF EXISTS Scaffale;
CREATE TABLE Scaffale(
	FK_CodiceStoccaggio_S VARCHAR(15) NOT NULL,
	CodiceScaffale VARCHAR(15) NOT NULL,
	CapacitaTot INT UNSIGNED NOT NULL,
    CapacitaResidua INT UNSIGNED NOT NULL,    
    PRIMARY KEY(CodiceScaffale)
);

/* Table Structure Paletto */

DROP TABLE IF EXISTS Paletto;
CREATE TABLE Paletto(
	IDPaletto VARCHAR(15) NOT NULL,
	PRIMARY KEY (IDPaletto)
);

/* Table structure Prodotto Finito*/

DROP TABLE IF EXISTS ProdottoFinito; 
CREATE TABLE ProdottoFinito(
	CodiceProdotto VARCHAR(15) NOT NULL,
    Nome VARCHAR(30) NOT NULL,
    Peso FLOAT NOT NULL,
    ScadenzaProdotto DATE,
    DataFineStagionatura DATE,
    FK_CodiceSilos_P VARCHAR(15) NOT NULL,
    FK_CodiceLotto_P VARCHAR(15) NOT NULL,
    FK_NomeRicetta_P VARCHAR(30) NOT NULL,
    FK_CodiceScaffale_P VARCHAR(15),
    FK_CodiceOrdine_P VARCHAR(15),
    PRIMARY KEY (CodiceProdotto),
    CONSTRAINT
		FOREIGN KEY (FK_CodiceOrdine_P)
		REFERENCES Ordine(CodiceOrdine),
    CONSTRAINT
		FOREIGN KEY (FK_CodiceSilos_P)
		REFERENCES Silos(CodiceSilos),
	CONSTRAINT
		FOREIGN KEY (FK_CodiceLotto_P)
		REFERENCES Lotto(CodiceLotto),
	CONSTRAINT
		FOREIGN KEY (FK_NomeRicetta_P)
		REFERENCES Ricetta(NomeRicetta),
	CONSTRAINT
		FOREIGN KEY (FK_CodiceScaffale_P)
		REFERENCES Scaffale(CodiceScaffale)
);

/* Table Structure Personale*/

DROP TABLE IF EXISTS Personale;
CREATE TABLE Personale(
	Nome VARCHAR(15) NOT NULL,
    Cognome VARCHAR(15) NOT NULL,
    Professione ENUM('Pulizie','Medico','Lavoratore Lotto','Guida Escursione'),
    CodicePersonale VARCHAR (15) NOT NULL,
    
    PRIMARY KEY(CodicePersonale)
);

/* Table Structure Lavora P*/

DROP TABLE IF EXISTS Lavora_P;
CREATE TABLE Lavora_P(
	FK_CodicePersonale_L VARCHAR (15) NOT NULL,
    FK_CodiceLocale_L VARCHAR (15) NOT NULL,
    
    PRIMARY KEY (FK_CodicePersonale_L, FK_CodiceLocale_L),
    CONSTRAINT
		FOREIGN KEY (FK_CodicePersonale_L)
        REFERENCES Personale(CodicePersonale), 
	CONSTRAINT
        FOREIGN KEY (FK_CodiceLocale_L)
        REFERENCES Locale(CodiceLocale)
);

/* Table Structure Rimedio */

DROP TABLE IF EXISTS Rimedio;
CREATE TABLE Rimedio(
	Nome VARCHAR(30) NOT NULL,
	Tipo VARCHAR(30) NOT NULL,
	DosaggioMax INT UNSIGNED NOT NULL,

	PRIMARY KEY(Nome)
);


/* Table Structure Prescrive */

DROP TABLE IF EXISTS Prescrive;
CREATE TABLE Prescrive(
	FK_Nome_P VARCHAR (30) NOT NULL,
	FK_CodiceCura_P VARCHAR (15) NOT NULL,
	Posologia VARCHAR (100) NOT NULL,
	PRIMARY KEY(FK_Nome_P, FK_CodiceCura_P),
	CONSTRAINT
		FOREIGN KEY (FK_Nome_P)
		REFERENCES Rimedio(Nome),
	CONSTRAINT
		FOREIGN KEY (FK_CodiceCura_P)
		REFERENCES Cura(FK_CodiceControllo_C)
);

/* Table Structure Cura */

DROP TABLE IF EXISTS Cura;
CREATE TABLE Cura(
	FK_CodiceControllo_C VARCHAR(15) NOT NULL,
	NomePatologia VARCHAR (30) NOT NULL,
	DataInizio TIMESTAMP NOT NULL,
	Durata INT UNSIGNED NOT NULL,
    Esito ENUM ('Positivo','Negativo'),
	PRIMARY KEY (FK_CodiceControllo_C),
	CONSTRAINT
		FOREIGN KEY (FK_CodiceControllo_C) 
		REFERENCES ControlloMedico(CodiceControllo)
);

/* Table Structure Esame */

DROP TABLE IF EXISTS Esame;
CREATE TABLE Esame(
	CodiceEsame VARCHAR(15) NOT NULL,
	Tipo TEXT(20) NOT NULL,
	EsitoEsame ENUM('Positivo','Negativo') NOT NULL,
	Descrizione TEXT(50) NOT NULL,
	TimeStampEsame TIMESTAMP NOT NULL,
	Macchinario VARCHAR (20),
	FK_CodiceControllo_E VARCHAR (15) NOT NULL,
	PRIMARY KEY (CodiceEsame),
	CONSTRAINT 
		FOREIGN KEY (FK_CodiceControllo_E)
		REFERENCES Controllo(CodiceControllo)
);

/* Table Structure ControlloMedico */

DROP TABLE IF EXISTS ControlloMedico;
CREATE TABLE ControlloMedico(
	CodiceControllo VARCHAR(15) NOT NULL,
	TipoControllo CHAR(30) NOT NULL,
	DataProgrammata TIMESTAMP NOT NULL,
	DataRealizzazione TIMESTAMP,
	StatoControllo ENUM('Programmato', 'Eseguito') NOT NULL,
	EsitoControllo ENUM('Positivo','Negativo'),	
	FK_CodiceAnimale_C VARCHAR (15) NOT NULL,
	FK_CodiceGestazione_C VARCHAR (15),
	FK_CodiceMedico_C VARCHAR (15) NOT NULL,
	PRIMARY KEY (CodiceControllo),
	CONSTRAINT
		FOREIGN KEY (FK_CodiceAnimale_C)
		REFERENCES Animale(CodiceAnimale),
	CONSTRAINT
		FOREIGN KEY (FK_CodiceGestazione_C)
		REFERENCES Gestazione(CodiceRiproduzione),
	CONSTRAINT
		FOREIGN KEY (FK_CodiceMedico_C)
		REFERENCES Personale(CodicePersonale)
);

/* Table Structure Gestazione */

DROP TABLE IF EXISTS Gestazione;
CREATE TABLE Gestazione(
	CodiceRiproduzione VARCHAR(15) NOT NULL,
	TimeStampRiproduzione TIMESTAMP NOT NULL,
	Complicanze VARCHAR(50) NOT NULL,
	StatoGestazione ENUM('In Corso','Fallita','Successo') NOT NULL,
	EsitoRiproduzione ENUM ('Fallita','Successo') NOT NULL,
	FK_CodiceAnimale_F VARCHAR (15) NOT NULL,
	FK_CodiceAnimale_M VARCHAR (15) NOT NULL,
	FK_CodiceMedico_R VARCHAR (15) NOT NULL,
	FK_CodiceMedico_G VARCHAR(15),
	PRIMARY KEY (CodiceRiproduzione),
	CONSTRAINT
		FOREIGN KEY (FK_CodiceAnimale_M)
		REFERENCES Animale(CodiceAnimale),
	CONSTRAINT
		FOREIGN KEY (FK_CodiceAnimale_F)
		REFERENCES Animale(CodiceAnimale),
	CONSTRAINT
		FOREIGN KEY (FK_CodiceMedico_R)
		REFERENCES Personale(CodicePersonale),
	CONSTRAINT
		FOREIGN KEY (FK_CodiceMedico_G)
		REFERENCES Personale(CodicePersonale)
);

/* Table Structure Parametri */

DROP TABLE IF EXISTS Parametri;
CREATE TABLE Parametri(
	CodiceParametri VARCHAR (15) NOT NULL,
    ConcEnzimi FLOAT NOT NULL,
    ConcAcqua FLOAT NOT NULL,
    ConcProteine FLOAT NOT NULL,
    ConcLipidi FLOAT NOT NULL,
    ConcZuccheri FLOAT NOT NULL,
    ConcMinerali FLOAT NOT NULL,
    PRIMARY KEY (CodiceParametri)
);

/* Table Structure Silos */

DROP TABLE IF EXISTS Silos;
CREATE TABLE Silos(
	CodiceSilos VARCHAR (15) NOT NULL,
	PercLivelloRiempimento  FLOAT NOT NULL,
	Capacita FLOAT NOT NULL,
	PRIMARY KEY (CodiceSilos)
);

/* Table Structure Latte */

DROP TABLE IF EXISTS Latte;
CREATE TABLE Latte(
	CodiceLatte VARCHAR(15) NOT NULL,
	Quantita FLOAT NOT NULL,
    DataMungitura TIMESTAMP NOT NULL,
	FK_CodiceSilos_L VARCHAR (15),
	FK_CodiceAnimale_L VARCHAR (15) NOT NULL,
	FK_CodiceMungitrice_L VARCHAR (15) NOT NULL,
	PRIMARY KEY (CodiceLatte),
	CONSTRAINT
		FOREIGN KEY (FK_CodiceSilos_L)
		REFERENCES Silos(CodiceSilos),
	CONSTRAINT
		FOREIGN KEY (FK_CodiceAnimale_L)
		REFERENCES Animale(CodiceAnimale),
	CONSTRAINT
		FOREIGN KEY (FK_CodiceMungitrice_L)
		REFERENCES Mungitrice(CodiceMungitrice)
);


/* Table Structure Mungitrice */
DROP TABLE IF EXISTS Mungitrice;
CREATE TABLE Mungitrice(
	CodiceMungitrice VARCHAR(15) NOT NULL,
    Marca TEXT(20),
    Modello TEXT(50),
    PRIMARY KEY (CodiceMungitrice)
);

/* Table Structure InfoGPS */ 

DROP TABLE IF EXISTS InfoGPS;
CREATE TABLE InfoGPS(
	CodiceGPS VARCHAR(15) NOT NULL,
	TimestampGPS TIMESTAMP NOT NULL,
	Latitudine DECIMAL(10, 7) NOT NULL,
	Longitudine DECIMAL(10, 7) NOT NULL,
	Zona VARCHAR(15) NOT NULL,
	PRIMARY KEY (CodiceGPS, TimestampGPS)
);

/* Table Structure Delimita */

DROP TABLE IF EXISTS Delimita;
CREATE TABLE Delimita(
	FK_IDPaletto_D VARCHAR (15) NOT NULL,
	FK_CodicePascolo_D VARCHAR (15) NOT NULL,
	PRIMARY KEY (FK_IDPaletto_D,FK_CodicePascolo_D),
	CONSTRAINT
		FOREIGN KEY (FK_IDPaletto_D)
		REFERENCES Paletto(IDPaletto),
		FOREIGN KEY (FK_CodicePascolo_D)
		REFERENCES Pascolo(CodicePascolo)
);

/* Table Structure Pascola */

DROP TABLE IF EXISTS Pascola;
CREATE TABLE Pascola(
	FK_CodicePascolo_P VARCHAR(15) NOT NULL,
    FK_CodiceLocale_P VARCHAR(15) NOT NULL,
	OraAccesso TIME,
	OraRientro TIME,
   	PRIMARY KEY (FK_CodiceLocale_P, FK_CodicePascolo_P),
    CONSTRAINT
		FOREIGN KEY (FK_CodiceLocale_P)
        REFERENCES Locale(CodiceLocale),
	CONSTRAINT
		FOREIGN KEY (FK_CodicePascolo_P)
        REFERENCES Pascolo(CodicePascolo)
);

/* Table Structure Pascolo */

DROP TABLE IF EXISTS Pascolo;
CREATE TABLE Pascolo(
	CodicePascolo VARCHAR(15) NOT NULL,
	PRIMARY KEY (CodicePascolo)
);

/* Table Structure Allestimento */

DROP TABlE IF EXISTS Allestimento;
CREATE TABLE Allestimento(
	CodiceAllestimento VARCHAR(15) NOT NULL,
    FK_CodiceLocale_AL VARCHAR(15) NOT NULL,
    UltimoRiempimento TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
    Tipologia TEXT(50),
    Funzione ENUM('Condizionatore','Mangiatoia','Abbeveratoio','Illuminazione'),
    
    PRIMARY KEY (CodiceAllestimento),
    CONSTRAINT
		FOREIGN KEY(FK_CodiceLocale_AL)
        REFERENCES Locale(CodiceLocale)
);

/* Table Structure Dispone SA */

DROP TABLE IF EXISTS DisponeSA;
CREATE TABLE DisponeSA(
	FK_Nome_D VARCHAR(30) NOT NULL,
    FK_CodiceLocale_D VARCHAR(15) NOT NULL,
    PRIMARY KEY (FK_Nome_D,FK_CodiceLocale_D),
    CONSTRAINT
		FOREIGN KEY (FK_CodiceLocale_D)
		REFERENCES Locale(CodiceLocale),
	CONSTRAINT
        FOREIGN KEY (FK_Nome_D)
		REFERENCES Sostanze_Acqua(Nome)
);

/* Table Structure Sostanze Acqua */

DROP TABLE IF EXISTS SostanzeAcqua;
CREATE TABLE SostanzeAcqua(
	Nome VARCHAR(30) NOT NULL,
	Tipologia CHAR(20) NOT NULL,
	PRIMARY KEY (Nome)
);

/* Table Structure Fornitore */

DROP TABLE IF EXISTS  Fornitore;
CREATE TABLE Fornitore(
	PartitaIVA VARCHAR(12) NOT NULL,
	RagioneSociale VARCHAR (30) NOT NULL,
	Indirizzo VARCHAR (40) NOT NULL,
	Nome VARCHAR (30) NOT NULL,
	PRIMARY KEY (PartitaIVA)
);
/* Table Structure Locale*/

DROP TABLE IF EXISTS Locale;
CREATE TABLE Locale(
	CodiceLocale VARCHAR(15) NOT NULL,
	NMaxAnimali INT UNSIGNED NOT NULL,
	Specie ENUM('Bovino','Ovino','Caprino') NOT NULL,
	NStalla INT UNSIGNED NOT NULL,
	Pavimentazione CHAR(15) NOT NULL,
	OrientamentoFinestre ENUM('Nord','Nord-Est','Est','Sud-Est','Sud','Sud-Ovest','Ovest','Nord-Ovest') NOT NULL,
	StatoPulizia ENUM ('Richiesto','Effettuato') DEFAULT 'Effettuato',
	Lunghezza INT UNSIGNED NOT NULL,
	Larghezza INT UNSIGNED NOT NULL,
	Altezza INT UNSIGNED NOT NULL,
	PRIMARY KEY (CodiceLocale)
);

/* Table Structure Animale */

DROP TABLE IF EXISTS Animale;
CREATE TABLE Animale(
	Valutazione INT UNSIGNED NOT NULL,
    FreqRitardi ENUM('Trascurabile','Significativa','Critica') DEFAULT 'Trascurabile',
	CodiceAnimale VARCHAR(15),
	Razza VARCHAR(20) NOT NULL,
	Specie ENUM('Bovino','Ovino','Caprino') NOT NULL,
	Famiglia VARCHAR(15) NOT NULL,
	Sesso ENUM ('M','F') NOT NULL,
	DataNascita DATE NOT NULL,
	Altezza FLOAT NOT NULL,
	Peso INT UNSIGNED NOT NULL,
	StatoSalute ENUM('Deceduto','Sano','Malato','Quarantena'),
    DataAcquisto DATE,
    DataArrivo DATE,	
    FK_CodiceLocale_A VARCHAR(15) NOT NULL,
	FK_PartitaIVA VARCHAR (12), 
	FK_AnimalePadre VARCHAR (15),
	FK_AnimaleMadre VARCHAR (15),
	PRIMARY KEY (CodiceAnimale),
	CONSTRAINT
		FOREIGN KEY (FK_CodiceLocale_A)
		REFERENCES Locale(CodiceLocale),
	CONSTRAINT
		FOREIGN KEY (FK_PartitaIVA)
		REFERENCES Fornitore(PartitaIVA),
	CONSTRAINT
		FOREIGN KEY (FK_AnimalePadre)
		REFERENCES Animale(CodiceAnimale),
	CONSTRAINT
		FOREIGN KEY (FK_AnimaleMadre)
		REFERENCES Animale(CodiceAnimale)
);

/* Table Structure Igiene */ 

DROP TABLE IF EXISTS Igiene;
CREATE TABLE Igiene(
	TimestampIgiene TIMESTAMP NOT NULL,
	FK_CodiceLocale_I VARCHAR(15) NOT NULL,
	LivelloSporcizia INT UNSIGNED DEFAULT 0,
	Azoto INT UNSIGNED NOT NULL,
	Ossigeno INT UNSIGNED NOT NULL,
	AnidrideCarbonica INT UNSIGNED NOT NULL,
	Metano INT UNSIGNED NOT NULL,
	PRIMARY KEY (TimestampIgiene,FK_CodiceLocale_I),
	CONSTRAINT 
		FOREIGN KEY (FK_CodiceLocale_I)
		REFERENCES Locale(CodiceLocale)
);
-- ---------------------------------------------------------------------------------------------------------------
-- 									TABELLE DI APPOGGIO PER ANALYTICS											
-- ----------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------
-- Tabella contenente gli errori (parametrici) registrati e individuati tramite analytic 3
-- --------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS Errori_Produzione;
CREATE TABLE Errori_Produzione(
    FK_CodiceProblematica VARCHAR(50) NOT NULL,
    TipoParametro VARCHAR(50) NOT NULL,
    ParametroRicetta FLOAT NOT NULL,
    ParametroProdotto FLOAT NOT NULL,
    Timestamp_Rilevamento TIMESTAMP NOT NULL,
    
    PRIMARY KEY (FK_CodiceProblematica, ParametroRicetta, ParametroProdotto,Timestamp_Rilevamento)
);

-- --------------------------------------------------------------------------------------------------
-- Tabella contenente le varie relazioni che hanno tra loro gli animali tramite analytic 1 
-- --------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS RelazioniVicinanza;
CREATE TABLE RelazioniVicinanza(
    Animale1 VARCHAR(15) NOT NULL,
    Animale2 VARCHAR(15) NOT NULL,
    Vicinanze INT NOT NULL,
    TimestampRichiesta TIMESTAMP NOT NULL,
    
    PRIMARY KEY (Animale1, Animale2, TimestampRichiesta)
);

-- --------------------------------------------------------------------------------------------------
-- Tabella contenente le zone preferite dagli animali ricavate da analytic 1
-- --------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS ZonePreferite;
CREATE TABLE ZonePreferite(
    Animale VARCHAR(15) NOT NULL,
	Latitudine DECIMAL(10, 7) NOT NULL,
	Longitudine DECIMAL(10, 7) NOT NULL,
    SosteZona INT NOT NULL,
    TimestampGPSAnimale TIMESTAMP NOT NULL,
    TimestampRichiesta TIMESTAMP NOT NULL,

    
    PRIMARY KEY (Animale,TimestampGPSAnimale)
);

-- ------------------------------------------------------------------------------------------------------------
-- Tabella contenente le differenze tra i parametri di processo ideali e reali da analytic 2
-- ------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS IndiciFasi;
CREATE TABLE IndiciFasi(
	NomeProdotto VARCHAR(30) NOT NULL,
	NumeroFase INT NOT NULL,
    DescrizioneFase VARCHAR(100) NOT NULL,
	DeltaMinutiFase FLOAT NOT NULL,
    DeltaMinutiRiposo FLOAT NOT NULL,
    DeltaSalaturaGrammi FLOAT NOT NULL,
    DeltaTemperaturaLatte FLOAT NOT NULL,
    DeltaGiorniStagionatura FLOAT NOT NULL,
    DataRichiesta DATE NOT NULL,
    
    PRIMARY KEY(NumeroFase,NomeProdotto,DataRichiesta)
);
-- ------------------------------------------------------------------------------
-- Tabella contenente valutazioni riguardati le fasi di produzione dei prodotti
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS ResocontoFasi;
CREATE TABLE ResocontoFasi(
	NomeProdotto VARCHAR(30) NOT NULL,
	NumeroFase INT NOT NULL,
    DataRichiesta DATE NOT NULL,
    DescrizioneFase VARCHAR(100) NOT NULL,
	Valutazione ENUM('Perfetta','Buona','Scadente') DEFAULT 'Perfetta',
    
    PRIMARY KEY(NumeroFase,NomeProdotto,DataRichiesta)
);

-- ----------------------------------------------------------------------------------------------------------------
-- 											POPOLAMENTO TABELLE
-- ----------------------------------------------------------------------------------------------------------------

-- ----------------------------
-- Records of UtenteRegistrato
-- ----------------------------
BEGIN;
INSERT INTO	UtenteRegistrato VALUES
('1234567890123456', 'Federico', 'Montini','Via Tosco Romagnola Est', 'NperNedo',current_date(), 'Pira4Ever', 'MNTFRC98E11D433F','3336571876','Come ti chiami?','Nedo','Carta di Identita','AU987654', '2023-09-15', 'Comune Montopoli'),
('1111222233334444', 'Tommaso','Bertini','Via Luigi Salvatori','BeppeSandali',current_date(), 'Ccezionale', 'BRTTMS98U01P046U','3289871234', 'Quale e il nome di tua madre?','Xanto','Carta di Identita','AU123456','2021-10-30','Comune Santa Croce'),
('9999888877776666', 'Emanuele','Tinghi','Via 25 Aprile','Ema0498',current_date(),'Campionedinverno','TNGMNL98H12H876J','3381928374','In quale squadra giochi?','Romaiano','Carta di Identita','AU876543','2022-01-01','Comune Montopoli'),
('3242356723176535', 'Christina', 'Falzone', 'Via Tosco Romagnola Ovest', 'Magikarp', current_date(), 'MiaoBau', 'FLZCRT00P32Z823K','3468673154', 'Quale è il tuo colore preferito', 'Blu', 'Carta di Identita', 'AU986342', '2022-02-10','Comune San Miniato');
COMMIT;

-- ----------------------------
-- Records of UtenteNonRegistrato
-- ----------------------------
BEGIN;
INSERT INTO	UtenteNonRegistrato VALUES
('2222333344445555', 'Gigi', 'Gigini'),
('3333444455556666', 'Fabrizio','Lanzillo'),
('9876543210987654', 'Pablo','Escobar')
;
COMMIT;

-- ----------------------------
-- Records of Prenotazione
-- ----------------------------
BEGIN;
INSERT INTO	Prenotazione VALUES
('PR00001',730,730,4, '2020-02-01','2020-02-08','2020-02-01','9999888877776666'),
('PR00002',120,60,2, '2020-04-21','2020-04-24','2020-01-09','3333444455556666'),
('PR00003',850,850,4, '2020-05-11','2020-05-18','2020-01-30','1111222233334444')
;
COMMIT;

-- ----------------------------
-- Records of Stanza
-- ----------------------------
BEGIN;
INSERT INTO	Stanza VALUES
('ST00001',2,30,'Stanza semplice'),
('ST00005',3,40,'Stanza semplice'),
('ST00002',2,50,'Suite'),
('ST00003',4,85,'Suite'),
('ST00004',2,50,'Suite')
;
COMMIT;

-- ----------------------------
-- Records of RiferitaS
-- ----------------------------
BEGIN;
INSERT INTO	RiferitaS VALUES
('ST00001','PR00002'),
('ST00002','PR00003'),
('ST00003','PR00001'),
('ST00004','PR00003')
;
COMMIT;

-- ----------------------------
-- Records of ServiziAggiuntivi
-- ----------------------------
BEGIN;
INSERT INTO	ServiziAggiuntivi VALUES
('SA00001','Sauna',20),
('SA00002','Bagno Turco',15),
('SA00003','Piscina',10),
('SA00004','Idromassaggio',20)
;
COMMIT;

-- ----------------------------
-- Records of Richiede
-- ----------------------------
BEGIN;
INSERT INTO	Richiede VALUES
('SA00001','PR00001',2),
('SA00003','PR00001',1),
('SA00004','PR00003',1),
('SA00002','PR00003',2)
;
COMMIT;

-- ----------------------------
-- Records of Propone
-- ----------------------------
BEGIN;
INSERT INTO	Propone VALUES
('SA00001','ST00002'),
('SA00002','ST00002'),
('SA00003','ST00002'),
('SA00004','ST00002'),
('SA00001','ST00003'),
('SA00002','ST00003'),
('SA00003','ST00003'),
('SA00004','ST00003'),
('SA00001','ST00004'),
('SA00002','ST00004'),
('SA00003','ST00004'),
('SA00004','ST00004')
;
COMMIT;

-- ----------------------------
-- Records of Pagamento
-- ----------------------------
BEGIN;
INSERT INTO	Pagamento VALUES
('PA00001','Carta di credito','2020-01-09',60,'PR00002','3333444455556666')
;
COMMIT;

-- ----------------------------
-- Records of Escursione
-- ----------------------------
BEGIN;
INSERT INTO	Escursione VALUES
('ES00001','2020-02-01 10:00:00','2020-02-04 16:00:00','PE00008','PR00001')
;
COMMIT;

-- ----------------------------
-- Records of Personale 
-- ----------------------------
BEGIN;
INSERT INTO	Personale VALUES
('Silvia','Milano','Medico','PE00001'),
('Ciro','Lori','Medico','PE00002'),
('Aurora','Rufini','Pulizie','PE00003'),
('Tullio','Pisano','Pulizie','PE00004'),
('Eleonora','Trevisani','Lavoratore Lotto','PE00005'),
('Rodolfo','Trevisano','Lavoratore Lotto','PE00006'),
('Igor','Lucchesi','Lavoratore Lotto','PE00007'),
('Emma','Conti','Guida Escursione','PE00008'),
('Clemente','Conti','Guida Escursione','PE00009')
;
COMMIT;

-- ----------------------------
-- Records of Area
-- ----------------------------
BEGIN;
INSERT INTO	Area VALUES
('Pascolo 1','Pascolo'),
('Pascolo 2','Pascolo'),
('Pascolo 3','Pascolo'),
('Pascolo 4','Pascolo'),
('Laboratorio 1','Laboratorio'),
('Laboratorio 2','Laboratorio'),
('Locale 1','Locale'),
('Locale 2','Locale'),
('Locale 3','Locale')
;
COMMIT;

-- ----------------------------
-- Records of Esplora
-- ----------------------------
BEGIN;
INSERT INTO	Esplora VALUES
('ES00001','Pascolo 1'),
('ES00001','Laboratorio 1'),
('ES00001','Locale 1'),
('ES00001','Locale 2'),
('ES00001','Locale 3')
;
COMMIT;

-- ------------------------------
-- Records of Itinerario
-- ------------------------------
BEGIN;
INSERT INTO Itinerario VALUES
('ES00001','2020-02-25 15:00:00','Locale 1',30),
('ES00001','2020-02-25 15:30:00','Pascolo 1',90),
('ES00001','2020-02-25 17:00:00','Locale 1',10),
('ES00001','2020-02-25 17:10:00','Locale 2',10);
COMMIT;

-- ----------------------------
-- Records of Ordine
-- ----------------------------
BEGIN;
INSERT INTO	Ordine VALUES
('OR00001','2019-11-30 21:58:00','Evaso','NperNedo',20,'2019-12-02','Consegnata','San Romano','San Romano','1234567890123456'),
('OR00002','2020-02-09 10:42:20','Spedito','BeppeSandali',13,'2020-02-10','Spedita','Firenze','Santa Croce','1111222233334444'),
('OR00003','2020-02-10 17:30:00','In processazione','NperNedo',5,'2020-02-12',NULL,'Allevamento T.E.F.','San Romano','1234567890123456'),
('OR00004','2020-02-10 17:30:00','Pendente','NperNedo',22.5,'2020-02-12',NULL,'Allevamento T.E.F.','San Romano','1234567890123456'),
('OR00005','2020-02-10 17:30:00','Pendente','BeppeSandali',5,'2020-02-12',NULL,'Allevamento T.E.F.','Santa Croce','1111222233334444'),
('OR00006','2020-02-11 12:30:00','Spedito','Ema0498',28.55,'2020-02-13','Spedita','Lucca','San Romano','9999888877776666'),
('OR00007','2020-02-11 17:00:00','Evaso','BeppeSandali',28.5,'2020-02-12','Consegnata','Santa Croce','SantaCroce','1111222233334444'),
('OR00008','2020-02-13 11:15:00','Pendente','Ema0498',15,'2020-02-15',NULL,'Allevamento T.E.F.','San Romano','9999888877776666'),
('OR00009','2020-02-15 14:15:00','In processazione','Magikarp',5.7,'2020-02-16',NULL,'Allevamento T.E.F.','San Miniato','3242356723176535'),
('OR00010','2020-02-16 16:00:00','Evaso','NperNedo',10,'2020-02-17','Consegnata','San Romano','San Romano','1234567890123456'),
('OR00011','2020-02-18 11:23:00','Pendente','Ema0498',20,'2020-02-18',NULL,'Allevamento T.E.F.','San Romano','9999888877776666'),
('OR00012','2020-02-15 14:15:00','Pendente','Magikarp',33,'2020-02-16',NULL,'Allevamento T.E.F.','San Miniato','3242356723176535');
COMMIT;

-- ----------------------------
-- Records of Recensione
-- ----------------------------
BEGIN;
INSERT INTO	Recensione VALUES
('PF00002','No',4,'Buona','Buono','Buona',' ')
;
COMMIT;
-- ----------------------------
-- Records of ProdottoAcquistabile
-- ----------------------------
BEGIN;
INSERT INTO	ProdottoAcquistabile VALUES
('Mozzarella Piccola',0.50,0.050),
('Mozzarella Media',0.95,0.100),
('Mozzarella Grande',1.70,0.200),
('Parmigiano Reggiano Piccolo',5,0.250),
('Parmigiano Reggiano Medio',13,0.750),
('Parmigiano Reggiano Grande',22.5,1.500),
('Pecorino Sardo Piccolo',11,0.250),
('Pecorino Sardo Medio',20,0.500),
('Pecorino Sardo Grande',36,1),
('Crescenza Piccola',2.85,0.150),
('Crescenza Media',3.50,0.200),
('Crescenza Grande',4.50,0.300),
('Gorgonzola Piccolo',3.50,0.200),
('Gorgonzola Medio',5,0.300),
('Gorgonzola Grande',7.50,0.500),
('Ricotta Piccola',1.80,0.100),
('Ricotta Media',4,0.250),
('Ricotta Grande',7,0.500)
;
COMMIT;

-- ----------------------------
-- Records of Acquisto
-- ----------------------------
BEGIN;
INSERT INTO	Acquisto VALUES
('Pecorino Sardo Medio','OR00001',1),
('Parmigiano Reggiano Medio','OR00002',1),
('Gorgonzola Medio','OR00003',1),
('Parmigiano Reggiano Grande','OR00004',1),
('Gorgonzola Medio', 'OR00005',1),
('Pecorino Sardo Medio', 'OR00006',1),
('Crescenza Piccola', 'OR00006',3),
('Mozzarella Piccola', 'OR00007',5),
('Parmigiano Reggiano Medio', 'OR00007',2),
('Gorgonzola Medio', 'OR00008',3),
('Crescenza Piccola', '0R00009',1),
('Mozzarella Media', 'OR00009',3),
('Ricotta Media', 'OR00010',1),
('Gorgonzola Medio', 'OR00010',1),
('Parmigiano Reggiano Piccolo', 'OR00011',4),
('Pecorino Sardo Piccolo', 'OR00012',3);
COMMIT;

-- ----------------------------
-- Records of ProdottoFinito
-- ----------------------------
BEGIN;
INSERT INTO	ProdottoFinito VALUES
('PF00001','Pecorino Sardo Medio',0.512,'2020-03-25','2020-01-06','SI0003','LT0001','Pecorino Sardo Medio','SC0001','OR00001'),
('PF00002','Parmigiano Reggiano Grande',1.601,'2020-01-02',NULL,'SI0002','LT0002','Parmigiano Reggiano Grande','SC0001','OR00002'),
('PF00004','Parmigiano Reggiano Grande',1.590,'2020-01-02',NULL,'SI0002','LT0002','Parmigiano Reggiano Grande','SC0004',NULL),
('PF00003','Gorgonzola Medio',0.297,'2020-03-12','2020-02-22','SI0006','LT0003','Gorgonzola Medio','SC0010','OR00003'),
('PF00005','Gorgonzola Medio',0.297,'2020-03-12', NULL,'SI0006','LT0003','Gorgonzola Medio','SC0010',NULL),
('PF00008','Pecorino Sardo Medio',0.5,'2020-08-22', '2020-05-07','S10001','LT0004','Pecorino Sardo Medio',NULL,NULL),
('PF00006','Pecorino Sardo Medio',0.6,'2020-08-22','2020-05-07','S10001','LT0004','Pecorino Sardo Medio',NULL,NULL),
('PF00007','Pecorino Sardo Medio',0.497,'2020-08-22','2020-05-07','S10001','LT0004','Pecorino Sardo Medio',NULL,NULL);
COMMIT;

-- ----------------------------
-- Records of Lotto
-- ----------------------------
BEGIN;
INSERT INTO	Lotto VALUES
('LT0002',1,50,'2020-01-02','2018-04-01'),
('LT0001',1,50,'2020-03-25','2019-10-28'),
('LT0003',2,52,'2020-03-12','2019-12-27')
;
COMMIT;

-- ----------------------------
-- Records of Lavora_L
-- ----------------------------
BEGIN;
INSERT INTO	Lavora_L VALUES
('LT0001','PE00005'),
('LT0001','PE00006'),
('LT0002','PE00006'),
('LT0002','PE00007'),
('LT0003','PE00005'),
('LT0003','PE00007')
;
COMMIT;

-- ----------------------------
-- Records of Ricetta
-- ----------------------------
BEGIN;
INSERT INTO	Ricetta VALUES
('Mozzarella Piccola',0,4,'Non nota',0.5,'Alto','Molle'),
('Parmigiano Reggiano Grande',600,4,'Emilia-Romagna',20,'Basso','Dura'),
('Parmigiano Reggiano Medio',600, 4,'Emilia-Romagna',10,'Basso','Dura'),
('Pecorino Sardo Medio',70,4,'Sardegna',8,'Basso','Dura'),
('Crescenza Piccola',0,4,'Non nota',4,'Alto','Molle'),
('Ricotta Grande',0,4,'Non nota',5.5,'Alto','Molle'),
('Gorgonzola Medio',55,5,'Non nota',10,'Medio','Molle')
;
COMMIT;

-- ----------------------------
-- Records of Fase
-- ----------------------------
BEGIN;	
INSERT INTO	Fase VALUES
('FA00001',1,10,0,0,60,'Prima cottura del latte','Mozzarella Piccola',NULL),
('FA00002',2,15,15,0,20,'Riposo','Mozzarella Piccola',NULL),
('FA00003',3,15,0,0,45,'Seconda cottura del latte','Mozzarella Piccola',NULL),
('FA00004',4,5,0,2,20,'Salatura','Mozzarella Piccola',NULL),

('FA00005',1,10,0,0,60,'Prima cottura del latte','Parmigiano Reggiano Grande',NULL),
('FA00006',2,10,10,0,20,'Riposo','Parmigiano Reggiano Grande',NULL),
('FA00007',3,25,0,0,60,'Seconda cottura del latte','Parmigiano Reggiano Grande',NULL),
('FA00008',4,5,0,40,20,'Salatura','Parmigiano Reggiano Grande',NULL),

('FA00009',1,5,0,0,60,'Prima cottura del latte','Pecorino Sardo Medio',NULL),
('FA00010',2,25,25,0,20,'Riposo','Pecorino Sardo Medio',NULL),
('FA00011',3,15,0,0,50,'Seconda cottura del latte','Pecorino Sardo Medio',NULL),
('FA00012',4,5,0,20,20,'Salatura','Pecorino Sardo Medio',NULL),

('FA00013',1,5,0,0,60,'Prima cottura del latte','Crescenza Piccola',NULL),
('FA00014',2,12,12,0,22,'Riposo','Crescenza Piccola',NULL),
('FA00015',3,5,0,0,45,'Seconda cottura del latte','Crescenza Piccola',NULL),
('FA00016',4,5,0,5,20,'Salatura','Crescenza Piccola',NULL),

('FA00017',1,7,0,0,60,'Prima cottura del latte','Ricotta Grande',NULL),
('FA00018',2,5,5,0,20,'Riposo','Ricotta Grande',NULL),
('FA00019',3,8,0,0,65,'Seconda cottura del latte','Ricotta Grande',NULL),
('FA00020',4,5,0,10,20,'Salatura','Ricotta Grande',NULL),

('FA00021',1,12,0,10,60,'Prima cottura del latte','Gorgonzola Medio',NULL),
('FA00022',2,20,20,0,20,'Riposo','Gorgonzola Medio',NULL),
('FA00023',3,10,0,0,55,'Seconda cottura del latte','Gorgonzola Medio',NULL),
('FA00024',4,5,0,8,20,'Salatura','Gorgonzola Medio',NULL),
('FA00025',5,5,0,0,20,'Aggiunta Muffe','Gorgonzola Medio',NULL),

('FA00026',1,5,0,0,75,'Prima cottura del latte',NULL,'PF00001'),
('FA00027',2,24,24,0,19,'Riposo',NULL,'PF00001'),
('FA00028',3,30,0,0,50,'Seconda cottura del latte',NULL,'PF00001'),
('FA00029',4,5,0,20,20,'Salatura',NULL,'PF00001'),

('FA00030',1,10,0,0,59,'Prima cottura del latte',NULL,'PF00002'),
('FA00031',2,10,10,0,20,'Riposo',NULL,'PF00002'),
('FA00032',3,25,0,0,60,'Seconda cottura del latte',NULL,'PF00002'),
('FA00033',4,5,0,39,20,'Salatura',NULL,'PF00002'),

('FA00034',1,12,0,10,62,'Prima cottura del latte',NULL,'PF00003'),
('FA00035',2,20,20,0,20,'Riposo',NULL,'PF00003'),
('FA00036',3,9,0,0,57,'Seconda cottura del latte',NULL,'PF00003'),
('FA00037',4,5,0,8,20,'Salatura',NULL,'PF00003'),
('FA00038',5,5,0,0,21,'Aggiunta Muffe',NULL,'PF00003'),

('FA00039',1,10,0,0,60,'Prima cottura del latte',NULL,'PF00004'),
('FA00040',2,10,10,0,20,'Riposo',NULL,'PF00004'),
('FA00041',3,25,0,0,60,'Seconda cottura del latte',NULL,'PF00004'),
('FA00042',4,5,0,40,20,'Salatura',NULL,'PF00004')
;
COMMIT;



/* Records of Locale */

BEGIN;
INSERT INTO Locale VALUES 
('LO001', 25, 'Bovino', 1, 'Terra battuta', 'Nord-Est', 'Effettuato', 12, 12, 3),
('LO002', 25, 'Caprino', 2, 'Terra', 'Sud', 'Effettuato',7, 7, 3),
('LO003', 25, 'Ovino', 3, 'Terra battuta', 'Sud-Ovest', 'Effettuato', 7, 7, 3);
COMMIT;

/* Records of Igiene */
BEGIN;
INSERT INTO Igiene VALUES
(CURRENT_TIMESTAMP(), 'LO001', 0, 780000, 202000, 410, 3),
(CURRENT_TIMESTAMP(), 'LO002', 3, 780234, 207000, 417, 2),
(CURRENT_TIMESTAMP(), 'LO003', 1, 748000, 212000, 407, 5);
COMMIT;

/* Records of Allestimento */
BEGIN;
INSERT INTO Allestimento VALUES
('AL001', 'LO001', '2020-02-15 14:00:00', 'Anti-Spreco', 'Mangiatoia'),
('AL002', 'LO002', '2020-02-15 11:00:00', 'Anti-Spreco', 'Mangiatoia'),
('AL003', 'LO003', CURRENT_TIMESTAMP(), 'Automatica', 'Mangiatoia'),
('AL004', 'LO001', CURRENT_TIMESTAMP(), 'Automatica', 'Abbeveratoio'),
('AL005', 'LO002', CURRENT_TIMESTAMP(), 'Automatica', 'Abbeveratoio'),
('AL006', 'LO003', CURRENT_TIMESTAMP(), 'Anti-Spreco', 'Abbeveratoio'),
('AL007', 'LO001', DEFAULT, 'Ecologico', 'Condizionatore'),
('AL008', 'LO002', DEFAULT, 'Automatico', 'Condizionatore'),
('AL009', 'LO003', DEFAULT, 'Automatico', 'Condizionatore'),
('AL010', 'LO001', DEFAULT, 'Automatico', 'Illuminazione'),
('AL011', 'LO002', DEFAULT, 'Automatico', 'Illuminazione'),
('AL012', 'LO003', DEFAULT, 'Automatico', 'Illuminazione');
COMMIT;

/* Records of Stato */
BEGIN;
INSERT INTO Stato VALUES
('AL001', '2020-02-11 10:00:00', 12, 'Livello di Riempimento'),
('AL001', '2020-02-15 14:00:00', 100, 'Livello di Riempimento'),
('AL002', '2020-02-11 10:00:00', 74, 'Livello di Riempimento'),
('AL002','2020-02-15 11:00:00', 100, 'Livello di Riempimento'),
('AL003', '2020-02-11 10:00:00', 74, 'Livello di Riempimento'),
('AL003', CURRENT_TIMESTAMP(), 100, 'Livello di Riempimento'),
('AL004', '2020-02-11 10:00:00', 23, 'Livello di Riempimento'),
('AL004', CURRENT_TIMESTAMP(), 100, 'Livello di Riempimento'),
('AL005', '2020-02-11 10:00:00', 56, 'Livello di Riempimento'),
('AL005', CURRENT_TIMESTAMP(), 100, 'Livello di Riempimento'),
('AL006', '2020-02-11 10:00:00', 15, 'Livello di Riempimento'),
('AL006', CURRENT_TIMESTAMP(), 100, 'Livello di Riempimento'),
('AL007', CURRENT_TIMESTAMP(), 17, 'Temperatura Impostata'),
('AL008', CURRENT_TIMESTAMP(), 15, 'Temperatura Impostata'),
('AL009', CURRENT_TIMESTAMP(), 13, 'Temperatura Impostata'),
('AL010', CURRENT_TIMESTAMP(), 10, 'Intensità Luce'),
('AL011', CURRENT_TIMESTAMP(), 5, 'Intensità Luce'),
('AL012', CURRENT_TIMESTAMP(), 0, 'Intensità Luce'),
('AL001', '2020-02-15 14:00:00', 'FO003', 'Foraggio Contenuto'),
('AL002', '2020-02-15 11:00:00', 'FO001', 'Foraggio Contenuto'),
('AL003', '2020-02-11 8:00:00', 'FO003', 'Foraggio Contenuto'),
('AL004', '2020-02-11 8:00:00', 'Vitamina B', 'Sostanza Disciolta'),
('AL005', '2020-02-11 8:00:00', 'Sali Minerali', 'Sostanza Disciolta'),
('AL006', '2020-02-11 8:00:00', 'Sali Minerali', 'Sostanza Disciolta');
COMMIT;

/* Records of SostanzeAcqua */
BEGIN;
INSERT INTO SostanzeAcqua VALUES
('Vitamina B','Vitamina'),
('Sali Minerali', 'Sale'),
('Calcio', 'Elettrolita'),
('Sodio', 'Elettrolita'),
('Potassio', 'Elettrolita'),
('Cloro', 'Elettrolita'),
('Magnesio', 'Elettrolita');
COMMIT;

/* Records of DisponeSA */
BEGIN;
INSERT INTO DisponeSA VALUES
('Vitamina B', 'L001'),
('Sali Minerali', 'L002'),
('Sali Minerali', 'L003');
COMMIT;

/* Records of Foraggio */
BEGIN;
INSERT INTO Foraggio VALUES
('FO001', 21, 15, 40, 120, 'Insilato'),
('FO002', 5, 35, 30, 180, 'Fresco'),
('FO003', 30, 12, 35, 145, 'Fieno');
COMMIT;

/* Records of DisponeF */
BEGIN;
INSERT INTO DisponeF VALUES
('FO001', 'LO001'),
('FO001', 'LO002'),
('FO001', 'LO003'),
('FO002', 'LO001'),
('FO002', 'LO002'),
('FO003', 'LO002'),
('FO003', 'LO003');
COMMIT;

/* Records of Consumo */
BEGIN;
INSERT INTO Consumo VALUES
('FO001','AL001',150),
('FO001','AL002',120),
('FO001','AL003',120),
('FO002','AL001',210),
('FO002','AL002',180),
('FO002','AL003',0),
('FO003','AL001',0),
('FO003','AL002',90),
('FO003','AL003',120);
COMMIT;

/* Records of Composto */
BEGIN;
INSERT INTO Composto VALUES
('Mela Melinda', 'Frutta'),
('Avena', 'Cereale'),
('Riso', 'Cereale'),
('Farro', 'Cereale'),
('Rapa', 'Verdura'),
('Barbabietola', 'Verdura'),
('Carota', 'Verdura'),
('Fogliame Gelso', 'Fibra'),
('Fogliame Olmo', 'Fibra'),
('Fogliame Pioppo', 'Fibra'),
('Siero di Latte', 'Proteina');
COMMIT;

/* Records of Formato */
BEGIN;
INSERT INTO Formato VALUES
('Mela Melinda', 'FO001', 20),
('Avena', 'FO001', 17),
('Fogliame Gelso', 'FO001', 20),
('Rapa', 'FO001', 40),
('Fogliame Gelso', 'FO002', 15),
('Riso', 'FO002', 35),
('Carota', 'FO002', 35),
('Barbabietola', 'FO003', 20),
('Siero di Latte', 'FO003', 30),
('Mela Melinda', 'FO003', 35);
COMMIT;

/* Records of Animale */
BEGIN;
INSERT INTO Animale VALUES
(10,'Trascurabile','AN0001', 'Maremmana', 'Bovino', 'Bovidae', 'F', '2013-03-21', 1.5, 484, 'Sano', NULL, NULL, 'LO001', NULL, 'AN0003', 'AN0002'),
(10,'Trascurabile','AN0002', 'Maremmana', 'Bovino', 'Bovidae', 'F', '2000-03-21', 1.6, 507, 'Sano', '2004-01-01', '2004-01-03', 'LO001', '184632947028', NULL, NULL),
(10,'Trascurabile','AN0003', 'Maremmana', 'Bovino', 'Bovidae', 'M', '2002-05-13', 1.4, 541, 'Sano', '2004-01-01', '2004-01-03', 'LO001', '184632947028', NULL, NULL),
(10,'Trascurabile','AN0004', 'Maremmana', 'Bovino', 'Bovidae', 'F', '2000-11-01', 1.6, 500, 'Sano', '2004-01-01', '2004-01-03', 'LO001', '184632947028', NULL, NULL),
(10,'Trascurabile','AN0005', 'Maremmana', 'Bovino', 'Bovidae', 'F', '2012-04-5', 1.3, 473, 'Sano', NULL, NULL, 'LO001', NULL, 'AN0003', 'AN0002'),
(10,'Trascurabile','AN0006', 'Maremmana', 'Bovino', 'Bovidae', 'F', '2013-09-11', 1.45, 492, 'Sano', NULL, NULL, 'LO001', NULL, 'AN0003', 'AN0002'),
(10,'Trascurabile','AN0007', 'Maremmana', 'Bovino', 'Bovidae', 'F', '2013-03-21', 1.5, 480, 'Sano', NULL, NULL, 'LO001', NULL, 'AN0003', 'AN0002'),
(10,'Trascurabile','AN0008', 'Maremmana', 'Bovino', 'Bovidae', 'F', '2002-05-17', 1.75, 472, 'Sano', '2006-08-31', '2006-09-02', 'LO001', '28573057201', NULL, NULL),
(10,'Trascurabile','AN0009', 'Maremmana', 'Bovino', 'Bovidae', 'F', '2019-06-04', 1.64, 482, 'Sano', NULL, NULL, 'LO001', NULL, 'AN0008', 'AN0003' ),
(10,'Trascurabile','AN0010', 'Maremmana', 'Bovino', 'Bovidae', 'F', '2018-10-09', 1.59, 490, 'Malato', NULL, NULL, 'LO001', NULL, 'AN0004', 'AN0003' ),
(10,'Trascurabile','AN0011', 'Sarda', 'Ovino', 'Bovidae', 'F', '2002-06-17', 0.63, 39, 'Sano', '2006-08-31', '2006-09-02', 'LO002', '28573057201', NULL, NULL),
(10,'Trascurabile','AN0012', 'Sarda', 'Ovino', 'Bovidae', 'M', '2002-03-19', 0.60, 42, 'Sano', '2006-08-31', '2006-09-02', 'LO002', '28573057201', NULL, NULL),
(10,'Trascurabile','AN0013', 'Massese', 'Ovino', 'Bovidae', 'F', '1998-06-17',0.57, 40, 'Deceduto', '2000-02-24', '2000-02-28', 'LO002', '184632947028', NULL, NULL),
(10,'Trascurabile','AN0014', 'Sarda', 'Ovino', 'Bovidae', 'F', '2015-03-14', 0.51, 39, 'Sano', NULL, NULL, 'LO002', NULL, 'AN0012', 'AN0011'),
(10,'Trascurabile','AN0015', 'Massese', 'Ovino', 'Bovidae', 'F', '2004-08-19', 0.67, 38, 'Sano', '2008-07-23', '2008-07-28', 'LO002', '184632947028', NULL, NULL),
(10,'Trascurabile','AN0016', 'Massese', 'Ovino', 'Bovidae', 'F', '2004-10-28', 0.65, 40, 'Sano', '2008-07-23', '2008-07-28', 'LO002', '184632947028', NULL, NULL),
(10,'Trascurabile','AN0017', 'Sarda', 'Ovino', 'Bovidae', 'F', '2013-06-17', 0.63, 32, 'Sano', '2006-08-31', '2006-09-02', 'LO002', '28573057201', NULL, NULL),
(10,'Trascurabile','AN0018', 'Sarda', 'Ovino', 'Bovidae', 'F', '2016-04-04', 0.57, 35, 'Sano', NULL, NULL, 'LO002', NULL, 'AN0012', 'AN0014'),
(10,'Trascurabile','AN0019', 'Sarda', 'Ovino', 'Bovidae', 'F', '2017-01-11', 0.58, 31, 'Sano', NULL, NULL, 'LO002', NULL, 'AN0012', 'AN0011'),
(10,'Trascurabile','AN0020', 'Sarda', 'Ovino', 'Bovidae', 'F', '2015-12-25', 0.60, 32, 'Sano', NULL, NULL, 'LO002', NULL, 'AN0012', 'AN0011'),
(10,'Trascurabile','AN0021', 'Alpina Comune', 'Caprino', 'Bovidae', 'F', '1998-12-08', 0.56, 43, 'Deceduto', '2000-05-30', '2000-06-04', 'LO003', '184632947028', NULL, NULL),
(10,'Trascurabile','AN0022', 'Alpina Comune', 'Caprino', 'Bovidae', 'M', '2000-02-05', 0.70, 45, 'Sano', '2002-07-15', '2002-07-19', 'LO003', '184632947028', NULL, NULL),
(10,'Trascurabile','AN0023', 'Bionda dell Adamello', 'Caprino', 'Bovidae', 'F', '2003-11-27', 0.61, 37, 'Sano', '2006-01-30', '2000-02-04', 'LO003', '28573057201', NULL, NULL),
(10,'Trascurabile','AN0024', 'Alpina Comune', 'Caprino', 'Bovidae', 'F', '2001-03-24', 0.49, 38, 'Sano', '2003-07-07', '2003-07-10', 'LO003', '28573057201', NULL, NULL),
(10,'Trascurabile','AN0025', 'Alpina Comune', 'Caprino', 'Bovidae', 'F', '2006-04-04', 0.50, 36, 'Sano', NULL, NULL, 'LO003', NULL, 'AN0022','AN0024'),
(10,'Trascurabile','AN0026', 'Alpina Comune', 'Caprino', 'Bovidae', 'F', '1998-12-08', 0.57, 43, 'Sano', NULL, NULL, 'LO003', NULL, 'AN0022', 'AN0024'),
(10,'Trascurabile','AN0027', 'Bionda dell Adamello', 'Caprino', 'Bovidae', 'M', '2000-11-05', 0.56, 42, 'Sano', '2003-03-12','2003-03-14', 'LO003', '28573057201', NULL, NULL),
(10,'Trascurabile','AN0028', 'Bionda dell Adamello', 'Caprino', 'Bovidae', 'F', '2007-07-15', 0.53, 40, 'Sano', NULL, NULL, 'LO003', NULL, 'AN0027', 'AN0023'),
(10,'Trascurabile','AN0029', 'Bionda dell Adamello', 'Caprino', 'Bovidae', 'F', '2008-06-21', 0.49, 38, 'Sano', NULL, NULL, 'LO003', NULL, 'AN0027', 'AN0023'),
(10,'Trascurabile','AN0030', 'Alpina Comune', 'Caprino', 'Bovidae', 'F', '2004-08-08', 0.47, 37, 'Sano', '2008-05-13', '2008-05-20', 'LO003', '184632947028', NULL, NULL);
COMMIT;

/* Records of Lavora_P */
BEGIN;
INSERT INTO Lavora_P VALUES
('PE00003','LO003'),
('PE00004','LO002');
COMMIT;

/* Records of Pascolo */
BEGIN;
INSERT INTO Pascolo VALUES 
('PS001'),
('PS002'),
('PS003'),
('PS004');
COMMIT;

/* Records of Pascola */
BEGIN;
INSERT INTO Pascola VALUES
('PS001','LO001','12:00:00','15:00:00'),
('PS002','LO001','08:00:00','11:00:00'),

('PS001','LO002','08:00:00','10:00:00'),
('PS002','LO002','11:00:00','12:00:00'),
('PS003','LO002','15:00:00','18:00:00'),

('PS003','LO003','08:00:00','11:00:00'),
('PS001','LO003','16:00:00','18:00:00');
COMMIT;

/* Records of Paletto */ 
BEGIN;
INSERT INTO Paletto VALUES
('PA0001'),
('PA0002'),
('PA0003'),
('PA0004'),
('PA0005'),
('PA0006'),
('PA0007'),
('PA0008'),
('PA0009'),
('PA0010'),
('PA0011'),
('PA0012');
COMMIT;

/* Records of Delimita */
BEGIN;
INSERT INTO Delimita VALUES
('PA0001','PS001'),
('PA0002','PS001'),
('PA0003','PS001'),
('PA0004','PS001'),
('PA0005','PS002'),
('PA0006','PS002'),
('PA0001','PS002'),
('PA0002','PS002'),
('PA0007','PS003'),
('PA0008','PS003'),
('PA0003','PS003'),
('PA0004','PS003'),
('PA0009','PS004'),
('PA0010','PS004'),
('PA0005','PS004'),
('PA0006','PS004');
COMMIT;

/* Records of Mungitrice */
BEGIN;
INSERT INTO Mungitrice VALUES
('MU0001','Mungitutto2000','Mark01'),
('MU0002','LatteFresco','FB456'),
('MU0003','LatteFresco','DS4523'),
('MU0004','Mungitutto2000','Mungitrice Carrellata'),
('MU0005','Automatik','Alfa-Laval');
COMMIT;

 /* Records of InfoGPS */
BEGIN;
INSERT INTO InfoGPS VALUES
-- Animale 1 giorno 1
('AN0001','2020-02-25 08:00:00',38.8890100,77.0339900,'LO001'),
('AN0001','2020-02-25 12:00:00',38.8889900,77.0340000,'LO001'),
('AN0001','2020-02-25 12:15:00',38.8895400,77.0308800,'PS001'),
('AN0001','2020-02-25 12:30:00',38.8894900,77.0307300,'PS001'),
('AN0001','2020-02-25 12:45:00',38.8895400,77.0306300,'PS001'),
('AN0001','2020-02-25 13:00:00',38.8894800,77.0304500,'PS001'),
('AN0001','2020-02-25 13:15:00',38.8895800,77.0302700,'PS001'),
('AN0001','2020-02-25 13:30:00',38.8896900,77.0304500,'PS001'),
('AN0001','2020-02-25 13:45:00',38.8896700,77.0307300,'PS001'),
('AN0001','2020-02-25 14:00:00',38.8897000,77.0310000,'PS001'),
('AN0001','2020-02-25 14:15:00',38.8895000,77.0311900,'PS001'),
('AN0001','2020-02-25 14:30:00',38.8894500,77.0311500,'PS001'),
('AN0001','2020-02-25 14:45:00',38.8894700,77.0311800,'PS001'),
('AN0001','2020-02-25 15:00:00',38.8895200,77.0311700,'PS001'),
('AN0001','2020-02-25 15:16:00',38.8894800,77.0323900,'Rientro'),
('AN0001','2020-02-25 18:40:00',38.8890000,77.0340300,'LO001'),

('AN0001','2020-02-25 08:10:00',38.8894700,77.0311800,'PS002'),
('AN0001','2020-02-25 11:14:00',38.8895200,77.0311700,'Rientro'),
-- Animale 1 giorno 2
('AN0001','2020-02-26 08:00:00',38.8890200,77.0340000,'LO001'),
('AN0001','2020-02-26 12:00:00',38.8890000,77.0340100,'LO001'),
('AN0001','2020-02-26 12:15:00',38.8896600,77.0316100,'PS001'),
('AN0001','2020-02-26 12:30:00',38.8896400,77.0316000,'PS001'),
('AN0001','2020-02-26 12:45:00',38.8895100,77.0311700,'PS001'),
('AN0001','2020-02-26 13:00:00',38.8893700,77.0315600,'PS001'),
('AN0001','2020-02-26 13:15:00',38.8893700,77.0313400,'PS001'),
('AN0001','2020-02-26 13:30:00',38.8894700,77.0311600,'PS001'),
('AN0001','2020-02-26 13:45:00',38.8893500,77.0309500,'PS001'),
('AN0001','2020-02-26 14:00:00',38.8893800,77.0307500,'PS001'),
('AN0001','2020-02-26 14:15:00',38.8894200,77.0304100,'PS001'),
('AN0001','2020-02-26 14:30:00',38.8894500,77.0303900,'PS001'),
('AN0001','2020-02-26 14:45:00',38.8894900,77.0303600,'PS001'),
('AN0001','2020-02-26 15:00:00',38.8896000,77.0306300,'PS001'),
('AN0001','2020-02-26 15:16:00',38.8894800,77.0322700,'Rientro'),
('AN0001','2020-02-26 18:40:00',38.8890000,77.0340000,'LO001'),
-- Animale 2 giorno 1
('AN0002','2020-02-25 08:05:00',38.8890200,77.0340000,'LO001'),
('AN0002','2020-02-25 12:05:00',38.8890000,77.0340100,'LO001'),
('AN0002','2020-02-25 12:20:00',38.8895400,77.0305400,'PS001'),
('AN0002','2020-02-25 12:35:00',38.8894100,77.0307300,'PS001'),
('AN0002','2020-02-25 12:50:00',38.8893900,77.0303200,'PS001'),
('AN0002','2020-02-25 13:05:00',38.8896300,77.0303300,'PS001'),
('AN0002','2020-02-25 13:20:00',38.8893000,77.0308800,'PS001'),
('AN0002','2020-02-25 13:35:00',38.8894000,77.0313500,'PS001'),
('AN0002','2020-02-25 13:50:00',38.8894900,77.0315600,'PS001'),
('AN0002','2020-02-25 14:05:00',38.8894700,77.0312200,'PS001'),
('AN0002','2020-02-25 14:20:00',38.8896800,77.0315800,'PS001'),
('AN0002','2020-02-25 14:35:00',38.8896800,77.0315800,'PS001'),
('AN0002','2020-02-25 14:50:00',38.8896300,77.0315600,'PS001'),
('AN0002','2020-02-25 15:05:00',38.8896400,77.0309200,'PS001'),
('AN0002','2020-02-25 15:15:00',38.8894800,77.0323900,'Rientro'),
('AN0002','2020-02-25 18:45:00',38.8890000,77.0340300,'LO001'),
-- Animale 1 giorno 2
('AN0002','2020-02-26 08:05:00',38.8890200,77.0340000,'LO001'),
('AN0002','2020-02-26 12:05:00',38.8890000,77.0340100,'LO001'),
('AN0002','2020-02-26 12:20:00',38.8895100,77.0317000,'PS001'),
('AN0002','2020-02-26 12:35:00',38.8894900,77.0312200,'PS001'),
('AN0002','2020-02-26 12:50:00',38.8896500,77.0306200,'PS001'),
('AN0002','2020-02-26 13:05:00',38.8893500,77.0312900,'PS001'),
('AN0002','2020-02-26 13:20:00',38.8893600,77.0309000,'PS001'),
('AN0002','2020-02-26 13:35:00',38.8893500,77.0304600,'PS001'),
('AN0002','2020-02-26 13:50:00',38.8895300,77.0312400,'PS001'),
('AN0002','2020-02-26 14:05:00',38.8895800,77.0304600,'PS001'),
('AN0002','2020-02-26 14:20:00',38.8895700,77.0304800,'PS001'),
('AN0002','2020-02-26 14:35:00',38.8895800,77.0304800,'PS001'),
('AN0002','2020-02-26 14:50:00',38.8894400,77.0303600,'PS001'),
('AN0002','2020-02-26 15:05:00',38.8896000,77.0305300,'PS001'),
('AN0002','2020-02-26 15:14:00',38.8894800,77.0322700,'Rientro'),
('AN0002','2020-02-26 18:45:00',38.8890000,77.0340000,'LO001'),
-- Animale 5 giorno 1
('AN0005','2020-02-25 08:00:00',38.8890800,77.0339500,'LO001'),
('AN0005','2020-02-25 12:00:00',38.8889700,77.0340400,'LO001'),
('AN0005','2020-02-25 12:10:00',38.8895500,77.0308900,'PS001'),
('AN0005','2020-02-25 12:25:00',38.8895000,77.0307400,'PS001'),
('AN0005','2020-02-25 12:40:00',38.8895500,77.0306600,'PS001'),
('AN0005','2020-02-25 12:55:00',38.8896300,77.0304700,'PS001'),
('AN0005','2020-02-25 13:10:00',38.8894500,77.0306400,'PS001'),
('AN0005','2020-02-25 13:25:00',38.8894800,77.0305300,'PS001'),
('AN0005','2020-02-25 13:40:00',38.8894800,77.0305300,'PS001'),
('AN0005','2020-02-25 13:55:00',38.8894800,77.0305300,'PS001'),
('AN0005','2020-02-25 14:10:00',38.8895100,77.0305000,'PS001'),
('AN0005','2020-02-25 14:25:00',38.8896500,77.0302900,'PS001'),
('AN0005','2020-02-25 14:40:00',38.8897400,77.0302300,'PS001'),
('AN0005','2020-02-25 14:55:00',38.8897400,77.0307200,'PS001'),
('AN0005','2020-02-25 15:10:00',38.8895000,77.0323700,'Rientro'),
('AN0005','2020-02-25 18:40:00',38.8890500,77.0340900,'LO001'),
-- Animale 5 giorno 2
('AN0005','2020-02-26 08:00:00',38.8890800,77.0339500,'LO001'),
('AN0005','2020-02-26 12:00:00',38.8889700,77.0340400,'LO001'),
('AN0005','2020-02-26 12:10:00',38.8896600,77.0311500,'PS001'),
('AN0005','2020-02-26 12:25:00',38.8895400,77.0308800,'PS001'),
('AN0005','2020-02-26 12:40:00',38.8895300,77.0306800,'PS001'),
('AN0005','2020-02-26 12:55:00',38.8894200,77.0304600,'PS001'),
('AN0005','2020-02-26 13:10:00',38.8894200,77.0304600,'PS001'),
('AN0005','2020-02-26 13:25:00',38.8894600,77.0305300,'PS001'),
('AN0005','2020-02-26 13:40:00',38.8895100,77.0303200,'PS001'),
('AN0005','2020-02-26 13:55:00',38.8893600,77.0302600,'PS001'),
('AN0005','2020-02-26 14:10:00',38.8893500,77.0311800,'PS001'),
('AN0005','2020-02-26 14:25:00',38.8893400,77.0316200,'PS001'),
('AN0005','2020-02-26 14:40:00',38.8894000,77.0316400,'PS001'),
('AN0005','2020-02-26 14:55:00',38.8894000,77.0316400,'PS001'),
('AN0005','2020-02-26 15:10:00',38.8895000,77.0323700,'Rientro'),
('AN0005','2020-02-26 18:40:00',38.8890500,77.0340900,'LO001'),
-- Animale 6 giorno 1
('AN0006','2020-02-25 08:00:00',38.8890800,77.0339500,'LO001'),
('AN0006','2020-02-25 12:00:00',38.8889700,77.0340400,'LO001'),
('AN0006','2020-02-25 12:05:00',38.8895200,77.0316300,'PS001'),
('AN0006','2020-02-25 12:20:00',38.8895800,77.0314800,'PS001'),
('AN0006','2020-02-25 12:35:00',38.8895800,77.0314800,'PS001'),
('AN0006','2020-02-25 12:50:00',38.8893800,77.0310400,'PS001'),
('AN0006','2020-02-25 13:05:00',38.8893800,77.0307800,'PS001'),
('AN0006','2020-02-25 13:20:00',38.8894500,77.0303700,'PS001'),
('AN0006','2020-02-25 13:35:00',38.8893800,77.0302000,'PS001'),
('AN0006','2020-02-25 13:50:00',38.8897500,77.0301800,'PS001'),
('AN0006','2020-02-25 14:05:00',38.8897200,77.0303400,'PS001'),
('AN0006','2020-02-25 14:20:00',38.8896300,77.0302300,'PS001'),
('AN0006','2020-02-25 14:35:00',38.8897200,77.0302600,'PS001'),
('AN0006','2020-02-25 14:50:00',38.8897300,77.0307100,'PS001'),
('AN0006','2020-02-25 15:05:00',38.8895000,77.0323700,'Rientro'),
('AN0006','2020-02-25 18:40:00',38.8890500,77.0340900,'LO001'),
-- Animale 6 giorno 2
('AN0006','2020-02-26 08:00:00',38.8890800,77.0339500,'LO001'),
('AN0006','2020-02-26 12:00:00',38.8889700,77.0340400,'LO001'),
('AN0006','2020-02-26 12:05:00',38.8895300,77.0316600,'PS001'),
('AN0006','2020-02-26 12:20:00',38.8896200,77.0310300,'PS001'),
('AN0006','2020-02-26 12:35:00',38.8897100,77.0302200,'PS001'),
('AN0006','2020-02-26 12:50:00',38.8895400,77.0302200,'PS001'),
('AN0006','2020-02-26 13:05:00',38.8894800,77.0302300,'PS001'),
('AN0006','2020-02-26 13:20:00',38.8895100,77.0302900,'PS001'),
('AN0006','2020-02-26 13:35:00',38.8895800,77.0304700,'PS001'),
('AN0006','2020-02-26 13:50:00',38.8895800,77.0304700,'PS001'),
('AN0006','2020-02-26 14:05:00',38.8897000,77.0306100,'PS001'),
('AN0006','2020-02-26 14:20:00',38.8894800,77.0307700,'PS001'),
('AN0006','2020-02-26 14:35:00',38.8893500,77.0309500,'PS001'),
('AN0006','2020-02-26 14:50:00',38.8894500,77.0310700,'PS001'),
('AN0006','2020-02-26 15:05:00',38.8895000,77.0323700,'Rientro'),
('AN0006','2020-02-26 18:40:00',38.8890500,77.0340900,'LO001'),
-- ---------------------------------------------------------------
('AN0003','2019-11-27 08:00:00',43.6903873,10.7601083,'LO001'),
('AN0004','2019-11-27 08:00:00',43.6903878,10.7601083,'LO001'),
('AN0005','2019-11-27 08:00:00',43.6903879,10.7601083,'LO001'),
('AN0006','2019-11-27 08:00:00',43.6903877,10.7601083,'LO001'),
('AN0007','2019-11-27 08:00:00',43.6903869,10.7601083,'LO001'),
('AN0008','2019-11-27 08:00:00',43.6903871,10.7601073,'LO001'),
('AN0009','2019-11-27 08:00:00',43.6903871,10.7601085,'LO001'),
('AN0010','2019-11-27 08:00:00',43.6903871,10.7601089,'LO001'),


('AN0011','2019-11-27 08:00:00',43.6904121,10.7602083,'LO002'),
('AN0011','2019-11-27 12:05:00',43.6904133,10.7602072,'PS001'),
('AN0011','2019-11-27 16:05:00',43.6904123,10.7602081,'LO002'),
('AN0011','2019-11-27 18:00:00',43.6904124,10.7602087,'LO002'),
('AN0012','2019-11-27 08:00:00',43.6904123,10.7602083,'LO002'),
('AN0013','2019-11-27 08:00:00',43.6904124,10.7602083,'LO002'),
('AN0014','2019-11-27 08:00:00',43.6904121,10.7602087,'LO002'),
('AN0015','2019-11-27 08:00:00',43.6904121,10.7602081,'LO002'),
('AN0016','2019-11-27 08:00:00',43.6904121,10.7602089,'LO002'),
('AN0017','2019-11-27 08:00:00',43.6904129,10.7602083,'LO002'),
('AN0018','2019-11-27 08:00:00',43.6904122,10.7602083,'LO002'),
('AN0019','2019-11-27 08:00:00',43.6904126,10.7602083,'LO002'),
('AN0020','2019-11-27 08:00:00',43.6904122,10.7602085,'LO002'),

('AN0021','2019-11-27 08:00:00',43.6903211,10.7601113,'LO003'),
('AN0021','2019-11-27 14:00:00',43.6903209,10.7601116,'LO003'),
('AN0021','2019-11-27 16:00:00',43.6903311,10.7601213,'LO003'),
('AN0021','2019-11-27 19:16:00',43.6903215,10.7601109,'LO003'),
('AN0022','2019-11-27 08:00:00',43.6903215,10.7601119,'LO003'),
('AN0023','2019-11-27 08:00:00',43.6903210,10.7601115,'LO003'),
('AN0024','2019-11-27 08:00:00',43.6903216,10.7601117,'LO003'),
('AN0025','2019-11-27 08:00:00',43.6903214,10.7601118,'LO003'),
('AN0026','2019-11-27 08:00:00',43.6903213,10.7601112,'LO003'),
('AN0027','2019-11-27 08:00:00',43.6903219,10.7601119,'LO003'),
('AN0028','2019-11-27 08:00:00',43.6903211,10.7601114,'LO003'),
('AN0029','2019-11-27 08:00:00',43.6903217,10.7601115,'LO003'),
('AN0030','2019-11-27 08:00:00',43.6903213,10.7601112,'LO003'),

('PA0001','2019-11-27 08:00:00',43.6903305,10.7601205,'PS001'),
('PA0002','2019-11-27 08:00:00',43.6903305,10.7601210,'PS001'),
('PA0003','2019-11-27 08:00:00',43.6903310,10.7601205,'PS001'),
('PA0004','2019-11-27 08:00:00',43.6903310,10.7601210,'PS001'),
('PA0005','2019-11-27 08:00:00',43.6903315,10.7601210,'PS002'),
('PA0006','2019-11-27 08:00:00',43.6903315,10.7601215,'PS002'),
('PA0007','2019-11-27 08:00:00',43.6903300,10.7601205,'PS002'),
('PA0008','2019-11-27 08:00:00',43.6903300,10.7601200,'PS002'),
('PA0009','2019-11-27 08:00:00',43.6903320,10.7601215,'PS003'),
('PA0010','2019-11-27 08:00:00',43.6903320,10.7601220,'PS003'),
('PA0011','2019-11-27 08:00:00',43.6903325,10.7601220,'PS003'),
('PA0012','2019-11-27 08:00:00',43.6903325,10.7601225,'PS003'),

('MU0001','2019-11-27 08:00:00',43.6903871,10.7601083,'LO001'),
('MU0001','2019-11-27 14:00:00',43.6903740,10.7601149,'PS001'),
('MU0002','2019-11-27 08:00:00',43.6904121,10.7602083,'LO002'),
('MU0002','2019-11-27 14:00:00',43.6904133,10.7602072,'LO002'),
('MU0003','2019-11-27 08:00:00',43.6903211,10.7601113,'LO003'),
('MU0003','2019-11-27 14:00:00',43.6903311,10.7601213,'PS002'),
('MU0004','2019-11-27 08:00:00',43.6903217,10.7601115,'LO004'),
('MU0004','2019-11-27 14:00:00',43.6903217,10.7601115,'LO004'),
('MU0005','2019-11-27 08:00:00',43.6903217,10.7601115,'LO003'),
('MU0005','2019-11-27 14:00:00',43.6903217,10.7601115,'LO003');
COMMIT;

/* Records of Gestazione */
BEGIN;
INSERT INTO Gestazione VALUES
('RI0001','2011-08-12 12:00:00','Nessuna Complicanza','Successo','Successo','AN0002', 'AN0003','PE00001','PE00002'),
('RI0002','2011-06-10 13:00:00','Rottura precoce sacco amniotico','Fallita','Successo','AN0002', 'AN0003','PE00001','PE00002'),
('RI0003','2012-08-17 16:00:00','Nessuna Complicanza','Successo','Successo','AN0002', 'AN0003','PE00001','PE00001'),
('RI0004','2014-09-14 12:00:00','Nessuna Complicanza','Successo','Successo','AN0011', 'AN0012','PE00002','PE00002'),
('RI0005','2015-11-01 08:00:00','Nessuna Complicanza','Successo','Successo','AN0014', 'AN0012','PE00001','PE00002'),
('RI0006','2006-12-25 09:00:00','Nessuna Complicanza','Successo','Successo','AN0023', 'AN0027','PE00001','PE00002'),
('RI0007','2008-11-27 09:00:00','Nessuna Complicanza','Successo','Successo','AN0023', 'AN0027','PE00001','PE00002'),
('RI0008','2019-12-31 20:00:00','Nessuna Complicanza','In Corso','Successo','AN0029', 'AN0027','PE00001','PE00001');

/* Records of ControlloMedico */
BEGIN;
INSERT INTO ControlloMedico VALUES
('CO0001','Controllo Gestazione', CURRENT_TIMESTAMP(), NULL, 'Programmato',NULL, 'AN0029', 'RI0008', 'PE00001' ),
('CO0002','Controllo Stato Salute', '2008-06-25 16:00:00', '2008-06-25 18:00:00', 'Eseguito','Positivo', 'AN0003', NULL, 'PE00001' ),
('CO0003','Controllo Stato Salute', CURRENT_TIMESTAMP(), NULL, 'Programmato', NULL, 'AN0010', NULL, 'PE00002' ),
('CO0004','Controllo Stato Salute', '2000-06-17 15:00:00', '2000-06-18 15:00:00', 'Eseguito','Positivo', 'AN0013', NULL, 'PE00002' ),
('CO0005','Controllo Gestazione', '2011-12-20 17:00:00', '2011-12-20 18:00:00', 'Eseguito','Negativo', 'AN0002', 'RI0002', 'PE00001' ),
('CO0006','Controllo Stato salute', '2020-10-02 09:00:00', CURRENT_TIMESTAMP(), 'Eseguito','Negativo', 'AN0014', NULL, 'PE00001' );
COMMIT;

/* Records of Esame */
BEGIN;
INSERT INTO Esame VALUES
('EX0001', 'Emocromo', 'Negativo', 'Emoglobina bassa', '2011-12-21 17:00:00', 'Contaglobuli', 'CO0005'),
('EX0002', 'Calcolo massa grassa', 'Positivo', 'Nella norma', '2011-12-21 17:00:00', NULL, 'CO0005'),
('EX0003', 'Misuramento Febbre', 'Negativo', 'Temperatura 42°', CURRENT_TIMESTAMP(), NULL, 'CO0006'),
('EX0004', 'Emocromo', 'Negativo', 'Emoglobina bassa', '2011-12-21 17:00:00', 'Contaglobuli', 'CO0002'),
('EX0005', 'Calcolo massa grassa', 'Positivo', 'Nella norma', '2011-12-21 17:00:00', NULL, 'CO0002'),
('EX0006', 'Misuramento Febbre', 'Positivo', 'Temperatura 39°', CURRENT_TIMESTAMP(), NULL, 'CO0002');
COMMIT;

/* Records of Cura */
BEGIN;
INSERT INTO Cura VALUES
('CO0005', 'Influenza', '2011-12-21 17:30:00', 7, 'Positivo'),
('CO0006', 'Influenza', CURRENT_TIMESTAMP(), 4, NULL);
COMMIT;

/* Records of Rimedio */
BEGIN;
INSERT INTO Rimedio VALUES
('Antibiotico forte', 'Antibiotico', 3),
('Antibiotico debole', 'Antibiotico', 5),
('Cortisone', 'Ormone', 2),
('Tachipirina', 'Antipiretico', 2),
('Ferro', 'Integratore', 4),
('Gruppo B', 'Vitamina', 5);
COMMIT;

/* Records of Prescrive*/
BEGIN;
INSERT INTO Prescrive VALUES
('Gruppo B','CO0005', 'Assunzione dopo i pasti'),
('Ferro','CO0005', 'Assunzione dopo i pasti'),
('Tachipirina','CO0006', '2 assunzioni/gg, alle 12 e alle 20');
COMMIT;

/* Records of Latte */
BEGIN;
INSERT INTO Latte VALUES
('LA0001', 24,'2020-02-10 08:00:00','SI0001', 'AN0001', 'MU0001'),
('LA0003', 22,'2020-02-10 08:30:00','SI0001', 'AN0002', 'MU0001'),
('LA0005', 19,'2020-02-10 09:00:00','SI0001', 'AN0003', 'MU0001'),
('LA0006', 22,'2020-02-10 09:30:00','SI0001', 'AN0004', 'MU0001'),
('LA0009', 18,'2020-02-10 10:00:00','SI0001', 'AN0006', 'MU0001'),
('LA0011', 20,'2020-02-10 10:30:00','SI0002', 'AN0007', 'MU0001'),
('LA0012', 20,'2020-02-10 11:00:00','SI0001', 'AN0008', 'MU0001'),
('LA0015', 21,'2020-02-11 07:30:00','SI0001', 'AN0010', 'MU0001'),
('LA0002', 26,'2020-02-11 08:00:00','SI0001', 'AN0001', 'MU0001'),
('LA0004', 28,'2020-02-11 08:30:00','SI0002', 'AN0002', 'MU0001'),
('LA0007', 18,'2020-02-11 09:00:00','SI0002', 'AN0004', 'MU0001'),
('LA0008', 23,'2020-02-11 09:00:00','SI0002', 'AN0005', 'MU0001'),
('LA0010', 19,'2020-02-11 09:30:00','SI0002', 'AN0006', 'MU0001'),
('LA0013', 23,'2020-02-11 10:00:00','SI0002', 'AN0008', 'MU0001'),
('LA0014', 21,'2020-02-11 10:30:00','SI0002', 'AN0009', 'MU0001'),

('LA0016', 1.5,'2020-02-10 08:00:00','SI0003', 'AN0011', 'MU0002'),
('LA0019', 1.1,'2020-02-10 08:30:00','SI0003', 'AN0013', 'MU0002'),
('LA0023', 1.2,'2020-02-10 09:00:00','SI0004', 'AN0016', 'MU0002'),
('LA0024', 1.3,'2020-02-10 09:30:00','SI0004', 'AN0016', 'MU0002'),
('LA0029', 1.42,'2020-02-10 10:00:00','SI0004', 'AN0019', 'MU0002'),
('LA0030', 1.22,'2020-02-11 07:30:00','SI0003', 'AN0020', 'MU0002'),
('LA0017', 1.2,'2020-02-11 08:00:00','SI0004', 'AN0011', 'MU0002'),
('LA0018', 1.3,'2020-02-11 08:30:00','SI0004', 'AN0012', 'MU0002'),
('LA0020', 1.2,'2020-02-11 09:00:00','SI0003', 'AN0013', 'MU0002'),
('LA0021', 0.9,'2020-02-11 09:30:00','SI0004', 'AN0014', 'MU0002'),
('LA0025', 1.4,'2020-02-11 10:00:00','SI0004', 'AN0016', 'MU0002'),
('LA0026', 1.4,'2020-02-11 10:30:00','SI0003', 'AN0016', 'MU0002'),
('LA0027', 1.4,'2020-02-11 11:00:00','SI0003', 'AN0017', 'MU0002'),
('LA0028', 1.57,'2020-02-11 11:30:00','SI0003', 'AN0018', 'MU0002'),
('LA0022', 1.5,'2020-02-11 12:00:00','SI0003', 'AN0015', 'MU0002'),

('LA0032', 2.41,'2020-02-10 08:00:00','S0005', 'AN0032', 'M0003'),
('LA0033', 2.35,'2020-02-10 08:30:00','S0006', 'AN0032', 'M0003'),
('LA0034', 2.47,'2020-02-10 09:00:00','S0006', 'AN0033', 'M0003'),
('LA0035', 2.21,'2020-02-10 09:30:00','S0005', 'AN0034', 'M0003'),
('LA0037', 2.56,'2020-02-10 10:00:00','S0005', 'AN0035', 'M0003'),
('LA0039', 2.23,'2020-02-10 10:30:00','S0005', 'AN0036', 'M0003'),
('LA0040', 2.36,'2020-02-10 11:00:00','S0006', 'AN0036', 'M0003'),
('LA0045', 2.52,'2020-02-10 11:30:00','S0005', 'AN0040', 'M0003'),
('LA0031', 2.31,'2020-02-11 08:00:00','S0005', 'AN0031', 'M0003'),
('LA0036', 2.23,'2020-02-11 08:30:00','S0006', 'AN0034', 'M0003'),
('LA0038', 2.62,'2020-02-11 09:00:00','S0005', 'AN0035', 'M0003'),
('LA0041', 2.29,'2020-02-11 09:30:00','S0006', 'AN0036', 'M0003'),
('LA0042', 2.30,'2020-02-11 10:00:00','S0005', 'AN0037', 'M0003'),
('LA0044', 2.45,'2020-02-11 10:30:00','S0006', 'AN0039', 'M0003'),
('LA0043', 2.35,'2020-02-11 11:00:00','S0005', 'AN0038', 'M0003');

COMMIT;

/* Records of Silos */
BEGIN;
INSERT INTO Silos VALUES
('SI0001', 63, 400),
('SI0002', 34, 400),
('SI0003', 52, 400),
('SI0004', 11, 400),
('SI0005', 24, 400),
('SI0006', 49, 400);
COMMIT;

/* Records of Parametri */
BEGIN;
INSERT INTO Parametri VALUES
('LA0001',21, 27, 15, 29, 5, 3),
('LA0002',22, 26, 15, 28, 6, 3),
('LA0003',21, 29, 13, 31, 4, 3),
('LA0004',19, 29, 13, 29, 7, 3),
('LA0005',18 , 27, 18, 31, 3, 3),
('LA0006',25, 23, 15, 29, 5, 3),
('LA0007',21, 23, 19, 29, 5, 3),
('LA0008',21, 27, 15, 26, 5, 6),
('LA0009',21, 22, 18, 29, 7, 3),
('LA0010',20, 27, 16, 29, 5, 3),
('LA0011',21, 27, 12, 26, 4, 8),
('LA0012',24, 24, 15, 29, 5, 3),
('LA0013',19, 27, 17, 29, 5, 3),
('LA0014',21, 26, 16, 29, 5, 3),
('LA0015',11, 37, 15, 29, 5, 3),
('LA0016',12, 27, 24, 29, 5, 3),
('LA0017',14, 26, 15, 37, 5, 3),
('LA0018',21, 17, 15, 29, 15, 3),
('LA0019',21, 19, 15, 29, 5, 11),
('LA0020',31, 27, 5, 29, 5, 3),
('LA0021',21, 25, 17, 29, 5, 3),
('LA0022',21, 27, 7, 29, 5, 11),
('LA0023',21, 27, 15, 29, 5, 3),
('LA0024',21, 32, 15, 19, 10, 3),
('LA0025',21, 27, 15, 29, 5, 3),
('LA0026',18, 27, 15, 29, 8, 3),
('LA0027',21, 34, 15, 15, 5, 10),
('LA0028',26, 22, 13, 29, 7, 3),
('LA0029',26, 22, 17, 29, 5, 1),
('LA0030',9, 33, 21, 29, 5, 3),
('LA0031',21, 27, 15, 29, 5, 3),
('LA0032',22, 27, 15, 28, 5, 3),
('LA0033',21, 25, 15, 29, 7, 3),
('LA0034',19, 27, 15, 29, 5, 3),
('LA0035',21, 26, 15, 28, 6, 4),
('LA0036',21, 27, 15, 29, 5, 3),
('LA0037',22, 26, 16, 28, 5, 3),
('LA0038',21, 27, 11, 29, 5, 7),
('LA0039',23, 27, 13, 28, 5, 4),
('LA0040',25, 23, 15, 29, 5, 3),
('LA0041',21, 27, 20, 24, 5, 3),
('LA0042',21, 17, 15, 29, 15, 3),
('LA0043',11, 37, 15, 19, 15, 3),
('LA0044',31, 27, 10, 24, 5, 3),
('LA0045',23, 27, 13, 29, 5, 3),

('SI0001',19, 25, 16, 32, 5, 3),
('SI0002',21, 27, 15, 29, 5, 3),
('SI0003',23, 25, 15, 23, 8, 6),
('SI0004',25, 23, 15, 29, 5, 3),
('SI0005',30, 17, 16, 28, 5, 3),
('SI0006',21, 21, 15, 25, 5, 13);
COMMIT;

/* Records of Scaffale */
BEGIN;
INSERT INTO Scaffale VALUES
('CA0001', 'SC0001', 100, 48),
('CA0001', 'SC0002', 100, 49),
('CA0002', 'SC0003', 100, 50),
('CA0002', 'SC0004', 100, 50),
('CA0003', 'SC0005', 100, 90),
('CA0003', 'SC0006', 100, 100),
('MA0001', 'SC0007', 100, 58),
('MA0001', 'SC0008', 100, 60),
('MA0002', 'SC0009', 100, 60),
('MA0002', 'SC0010', 100, 59),
('MA0003', 'SC0011', 100, 100),
('MA0003', 'SC0012', 100, 100);
COMMIT;

/* Records of Cantina */
BEGIN;
INSERT INTO Cantina VALUES
('CA0001', 40),
('CA0002', 30),
('CA0003', 30);
COMMIT;

/* Records of Magazzino */
BEGIN;
INSERT INTO Magazzino VALUES
('MA0001', 25),
('MA0002', 30),
('MA0003', 20);
COMMIT;

/* Records of ControlloCantina */
BEGIN;
INSERT INTO ControlloCantina VALUES
('CA0001', '2019-11-27 08:00:00', 12, 30),
('CA0001', '2019-11-27 10:00:00', 15, 27),
('CA0001', '2019-11-27 12:00:00', 17, 26),
('CA0001', '2019-11-27 14:00:00', 17, 26),
('CA0001', '2019-11-27 16:00:00', 15, 28),
('CA0001', '2019-11-27 18:00:00', 11, 31),
('CA0002', '2019-11-27 08:00:00', 10, 33),
('CA0002', '2019-11-27 10:00:00', 9, 29),
('CA0002', '2019-11-27 12:00:00', 12, 29),
('CA0002', '2019-11-27 14:00:00', 13, 25),
('CA0002', '2019-11-27 16:00:00', 13, 28),
('CA0002', '2019-11-27 18:00:00', 10, 33);
COMMIT;

-- -------------------------------------------------
-- TRIGGERS
-- -------------------------------------------------
SET FOREIGN_KEY_CHECKS = 1;
SET GLOBAL AUTOCOMMIT = 1;
SET GLOBAL EVENT_SCHEDULER = 1;
SET GLOBAL log_bin_trust_function_creators = 1;
DELIMITER $$
-- ----------------------------------------
-- Trigger Controllo Data scadenza e data produzione di un prodotto finito
-- ----------------------------------------
DROP TRIGGER IF EXISTS insert_ProdottoFinito$$
CREATE TRIGGER insert_ProdottoFinito
BEFORE INSERT ON ProdottoFinito
FOR EACH ROW
BEGIN
		DECLARE Durata INT;
		SET Durata = DATEDIFF(new.ScadenzaProdotto,(SELECT DataProduzione FROM Lotto WHERE CodiceLotto=new.FK_CodiceLotto_P));
		IF (((SELECT ScadenzaLotto FROM Lotto WHERE CodiceLotto=new.FK_CodiceLotto_P)<>new.ScadenzaProdotto)OR Durata<0 )
        THEN 
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Date Inconsistenti';
	    END IF;
END$$

-- ----------------------------------------
-- Trigger controllo esistenza nome area
-- ----------------------------------------
DROP TRIGGER IF EXISTS insert_Itinerario$$
CREATE TRIGGER insert_Itinerario
BEFORE INSERT ON Itinerario
FOR EACH ROW
BEGIN
	IF (NOT EXISTS (SELECT NomeArea
				   FROM Area
                   WHERE NomeArea = new.NomeArea))
	THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Area non esistente';
	END IF;
END$$

-- ------------------------------------------------------------------------------------------
-- Trigger controllo data per tentativo di reso
-- ------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS Controllo_Reso$$
CREATE TRIGGER Controllo_Reso
BEFORE INSERT ON Recensione
FOR EACH ROW
BEGIN
	DECLARE _DataConsegna DATE;
	SET _DataConsegna = (SELECT Ordine.DataConsegna FROM Ordine WHERE CodiceOrdine = (SELECT FK_CodiceOrdine_P FROM ProdottoFinito WHERE CodiceProdotto = new.FK_CodiceProdotto_R));
	IF (new.Reso ='Si')
    THEN 
		IF ( (_DataConsegna + INTERVAL 2 DAY) < CURRENT_DATE() )
        THEN 
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Reso non più possibile';
		END IF;
	END IF;
END$$
-- ----------------------------------------
-- Trigger Controllo Livello riempimento sia percentuale
-- ----------------------------------------
DROP TRIGGER IF EXISTS insert_Silos$$
CREATE TRIGGER insert_Silos
BEFORE INSERT ON Silos
FOR EACH ROW
BEGIN
	IF ((new.PercLivelloRiempimento<0) OR (new.PercLivelloRiempimento>100))
    THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Il valore riguardante il riempimento non è espresso in percentuale';
    END IF;
END$$
-- ----------------------------------------
-- Trigger Controllo Sesso animale che ha prodotto il latte
-- ----------------------------------------
DROP TRIGGER IF EXISTS insert_Latte$$
CREATE TRIGGER insert_Latte
BEFORE INSERT ON Latte
FOR EACH ROW
BEGIN
	IF ((SELECT Sesso
		 FROM Animale
         WHERE CodiceAnimale=new.FK_CodiceAnimale_L)='M')
	THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'L animale munto non può essere maschio';
	END IF;
END$$
-- --------------------------------------------------
-- Controllo valore degli attributi Percentuali Parametri
-- --------------------------------------------------
DROP TRIGGER IF EXISTS insert_Parametri$$
CREATE TRIGGER insert_Parametri
BEFORE INSERT ON Parametri
FOR EACH ROW
BEGIN
  -- Controllo valore attributi --
  IF (new.ConcAcqua > 100
	OR new.ConcAcqua < 0
	OR new.ConcEnzimi < 0
	OR new.ConcEnzimi > 100
	OR new.ConcProteine < 0
	OR new.ConcProteine > 100
	OR new.ConcLipidi < 0
	OR new.ConcLipidi > 100
	OR new.ConcZuccheri < 0
	OR new.ConcZuccheri > 100
	OR new.ConcMinerali < 0
	OR new.ConcMinerali > 100
    OR new.ConcMinerali+new.ConcZuccheri+new.ConcLipidi+new.ConcProteine+new.ConcEnzimi+new.ConcAcqua <100)
  THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Inserimento Parametro scorretto';
    END IF;
END$$

-- --------------------------------------------------
-- Controllo valore della valutazione animale aggiornata
-- --------------------------------------------------
DROP TRIGGER IF EXISTS update_valutazione$$
CREATE TRIGGER update_valutazione
BEFORE UPDATE ON Animale
FOR EACH ROW
BEGIN
  -- Controllo valore valutazione animale --
  IF (new.Valutazione >10
	 OR new.Valutazione<0)
  THEN 
     SIGNAL SQLSTATE '45000'
     SET MESSAGE_TEXT = 'Inserimento Valutazione scorretta';
  END IF;
END$$

-- ----------------------------------------------
-- Controllo inserimento livello sporcizia
-- ----------------------------------------------
DROP TRIGGER IF EXISTS insert_Igiene$$
CREATE TRIGGER insert_Igiene
BEFORE INSERT ON Igiene
FOR EACH ROW
BEGIN
   -- Controllo valore Livello Sporcizia --
   IF ( new.LivelloSporcizia < 0
	  OR new.LivelloSporcizia >5)
   THEN 
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Inserimento Livello Sporcizia scorretto';
  END IF;
END$$

-- --------------------------------------
-- Controllo Inserimento Gestazione
-- --------------------------------------
DROP TRIGGER IF EXISTS insert_Gestazione$$
CREATE TRIGGER insert_Gestazione
BEFORE INSERT ON Gestazione
FOR EACH ROW
BEGIN
	IF ((SELECT Sesso
		FROM Animale
        WHERE Animale.CodiceAnimale=new.FK_CodiceAnimale_M)='F'
        OR (SELECT Sesso
			FROM Animale
            WHERE Animale.CodiceAnimale=new.FK_CodiceAnimale_F)='M'
		   )
	THEN
	   SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'Inserimento Animali scorretto';
    END IF;
    IF (new.EsitoRiproduzione='Fallita' AND new.StatoGestazione<>'Fallita')
    THEN
	   SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'Inserimento Stati scorretto';
	END IF;
	IF ((SELECT Specie FROM Animale WHERE Animale.CodiceAnimale=new.FK_CodiceAnimale_M)<>(SELECT Specie FROM Animale WHERE Animale.CodiceAnimale=new.FK_CodiceAnimale_F))
    THEN
	   SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'Riproduzione tra specie differenti';
	END IF;
	IF (new.StatoGestazione<>'Fallita' AND new.FK_CodiceMedico_G IS NULL)
    THEN
	   SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'Medico Gestazione non assegnato';
	END IF;
END$$

-- --------------------------------------------
-- Trigger animale
-- --------------------------------------------
DROP TRIGGER IF EXISTS insert_animale$$
CREATE TRIGGER insert_animale
BEFORE INSERT ON Animale
FOR EACH ROW
BEGIN
	IF ((FK_PartitaIVA IS NOT NULL)AND(
			(DataAcquisto IS NULL)
            OR(DataArrivo IS NULL)
            OR(new.DataAcquisto > new.DataArrivo)
            OR(FK_AnimalePadre IS NOT NULL)
            OR(FK_AnimaleMadre IS NOT NULL)
            OR(NOT EXISTS(SELECT * FROM Fornitore WHERE Fornitore.PartitaIVA = new.FK_PartitaIVA))
		)
	)
	THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserimento scorretto animale acquistato';
	END IF;
    
    IF((FK_PartitaIVA IS NULL)AND(
			(FK_AnimalePadre IS NULL)
            OR(FK_AnimaleMadre IS NULL)
            OR(NOT EXISTS(SELECT * FROM Animale WHERE Animale.CodiceAnimale = new.FK_AnimalePadre AND Animale.Sesso = 'M'))
            OR(NOT EXISTS(SELECT * FROM Animale WHERE Animale.CodiceAnimale = new.FK_AnimaleMadre AND Animale.Sesso = 'F'))
        )
	)
    THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Inserimento scorretto animale figlio';
	END IF;
    
    IF NOT(new.Valutazione BETWEEN 0 AND 10 
			AND new.Altezza BETWEEN 0.10 AND 3
            AND new.Peso BETWEEN 0 AND 900
            AND(EXISTS(SELECT * FROM Locale WHERE Locale.CodiceLocale = new.FK_CodiceLocale_A))
		)
		THEN
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Dati non corretti';
	END IF;
END$$

-- ----------------------------------------
-- Trigger servizi aggiuntivi
-- ----------------------------------------
DROP TRIGGER IF EXISTS insert_prenotazioneSA$$
CREATE TRIGGER insert_prenotazioneSA
BEFORE INSERT ON Richiede
FOR EACH ROW
BEGIN
	IF(NOT EXISTS(SELECT * FROM Prenotazione 
					WHERE Prenotazione.CodicePrenotazione = new.FK_CodicePrenotazione_R 
                    AND DATEDIFF(FineSoggiorno,InzioSoggiorno) >= new.GiorniRichiesta
				  )
	   )
		THEN
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Richesta servizi eccedente la durata del soggiorno';
	END IF;
    
	IF(NOT EXISTS(SELECT * FROM Prenotazione P 
							INNER JOIN 
                            RiferitaS RS ON P.CodicePrenotazione = RS.FK_CodicePrenotazione_R 
                            INNER JOIN 
                            Stanza S ON RS.FK_CodiceStanza_R = S.CodiceStanza
					
							WHERE S.TipoStanza = 'Suite'
							AND P.CodicePrenotazione = new.FK_CodicePrenotazione_R
				  )
	   )
	THEN 
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La stanza non e una suite';
        
    END IF;
END$$


-- ----------------------------------------
-- Trigger before prenotazione
-- ----------------------------------------
DROP TRIGGER IF EXISTS insert_Prenotazione$$
CREATE TRIGGER insert_Prenotazione
BEFORE INSERT ON Prenotazione
FOR EACH ROW
BEGIN
	IF(new.FineSoggiorno < new.InizioSoggiorno)
    THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Errore inserimento date';
	END IF;
END$$
	
-- ----------------------------------------
-- Trigger after prenotazione
-- ----------------------------------------
DROP TRIGGER IF EXISTS update_Prenotazione$$
CREATE TRIGGER update_Prenotazione
AFTER INSERT ON Prenotazione
FOR EACH ROW
BEGIN
	DECLARE Durata INT;
    SET Durata = DATEDIFF(new.FineSoggiorno,new.InizioSoggiorno);
    
	UPDATE Prenotazione p
    SET p.CostoTotale = (SELECT SUM(Stanza.CostoGiornaliero * Durata) 
						FROM RiferitaS INNER JOIN Stanza ON RiferitaS.FK_CodiceStanza_R = Stanza.CodiceStanza
                        WHERE RiferitaS.FK_CodicePrenotazione_RS = new.CodicePrenotazione)
	WHERE p.CodicePrenotazione = new.CodicePrenotazione;
END$$
-- ----------------------------------------
-- Trigger Controllo Date di Controllo Medico
-- ----------------------------------------
DROP TRIGGER IF EXISTS insert_ControlloMedico$$
CREATE TRIGGER insert_ControlloMedico
BEFORE UPDATE ON ControlloMedico
FOR EACH ROW
BEGIN
	DECLARE Durata INT;
    SET Durata = TIMESTAMPDIFF(SECOND,new.DataProgrammata,new.DataRealizzazione);
	IF Durata < 0
    THEN 
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Errore inserimento date';    
	END IF;
END$$

-- ----------------------------------------
-- Trigger Controllo Orari di Pascolo
-- ----------------------------------------
DROP TRIGGER IF EXISTS insert_Pascola$$
CREATE TRIGGER insert_Pascola
BEFORE INSERT ON Pascola
FOR EACH ROW
BEGIN
	DECLARE Durata INT;
    SET Durata =TIMESTAMPDIFF(SECOND,new.OraAccesso,new.OraRientro);
	IF ( Durata<0)
	THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserimento Orario scorretto';
    END IF;
END$$

-- -------------------------------------------------------------------------------------------
-- Le escursioni devono essere prenotate con almeno 48 ore di anticipo dalla data effettiva
-- -------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS controllo_guida$$
CREATE TRIGGER controllo_guida
BEFORE INSERT ON Escursione
FOR EACH ROW
BEGIN
	IF( NOT EXISTS( SELECT*
					FROM Professione
                    WHERE new.FK_CodicePrenotazione_E = CodicePersonale
						AND Professione = 'Guida Escursione'
                    ))
		THEN
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Errore, è necessaria una guida per fare una escursione';
	END IF;
END $$

-- ---------------------------------------------------------
-- controllo validità del documento per utente registrato
-- ---------------------------------------------------------
DROP TRIGGER IF EXISTS controllo_documento$$
CREATE TRIGGER controllo_documento
BEFORE INSERT ON UtenteRegistrato
FOR EACH ROW
BEGIN
	IF( new.ScadenzaDocumento < current_date() )
		THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Documento scaduto';
	END IF;
END$$

-- -------------------------------------------------------------------------------------------
-- controllo data di consegna
-- -------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS controllo_consegna$$
CREATE TRIGGER controllo_consegna
BEFORE INSERT ON Ordine
FOR EACH ROW
BEGIN
	IF( new.DataConsegna IS NULL) 
		THEN
			IF( new.DataOrdine > current_date()) THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Errore, non è possibile fare ordini nel futuro';
			END IF;
		ELSE IF( new.DataOrdine > new.DataConsegna ) 
			THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Errore, data consegna non valida';
		END IF;
	END IF;
END$$

-- ----------------------------------------------------------------------
-- EVENT Cancella prodotti scaduti non venduti
-- ----------------------------------------------------------------------
 DROP EVENT IF EXISTS cancella_prodotti_scaduti$$
 CREATE EVENT cancella_prodotti_scaduti
 ON SCHEDULE EVERY 1 MONTH
 STARTS '2020-02-12 17:00:00'
 DO BEGIN
 DELETE FROM ProdottoFinito
 WHERE ((ScadenzaProdotto < current_timestamp()) AND (FK_CodiceOrdine_P IS NULL));
 END$$ 
 
-- ----------------------
-- OPERAZIONE 1: Calcolo del tempo medio di consumo del foraggio 
-- Prova1. INSERT INTO Stato VALUES ('AL001',current_timestamp(),13,'Livello di Riempimento')
-- 		   INSERT INTO Stato VALUES ('AL001',current_timestamp(),0,'Livello di Riempimento')
--         INSERT INTO Stato VALUES ('AL001',current_timestamp(),50,'Livello di Riempimento')
-- -----------------------
-- -------------------------------------
-- Aggiornamento valore UltimoRiempimento
-- -------------------------------------
DROP TRIGGER IF EXISTS update_UltimoRiempimento$$
CREATE TRIGGER update_UltimoRiempimento
AFTER INSERT ON Stato 
FOR EACH ROW
BEGIN
	IF(CAST(new.ValoreCorrente as decimal)> CAST((SELECT ValoreCorrente 
								FROM Stato 
								WHERE Stato.CodiceRiferimento = new.CodiceRiferimento
                                AND Stato.TipoMisura =  'Livello di Riempimento'
								AND Stato.TimestampStato = (SELECT MAX(TimestampStato)
															FROM Stato
															WHERE Stato.TipoMisura =  'Livello di Riempimento'
															AND Stato.CodiceRiferimento = new.CodiceRiferimento
                                                            AND Stato.TimestampStato <> new.TimestampStato
															)
							) as decimal))
				THEN
					UPDATE Allestimento
					SET Allestimento.UltimoRiempimento=new.TimestampStato
					WHERE Allestimento.CodiceAllestimento=new.CodiceRiferimento;
	END IF;
    
    IF((CAST(new.ValoreCorrente as decimal) = 0) AND 'Mangiatoia' = (SELECT Funzione FROM Allestimento WHERE CodiceAllestimento = new.CodiceRiferimento ))
		THEN
			CALL set_tempomedio(new.CodiceRiferimento,new.TimestampStato);
	END IF;
END$$

DROP PROCEDURE IF EXISTS set_tempomedio$$
CREATE PROCEDURE set_tempomedio(IN _codiceRiferimento VARCHAR(15),IN _timestampStato TIMESTAMP)
BEGIN
	DECLARE _nuovoTempo INT DEFAULT 0;
	DECLARE _ultimoRiempimento TIMESTAMP DEFAULT '00-00-0000 00:00:00';
	DECLARE _nuovaMedia FLOAT DEFAULT 0;
    DECLARE _vecchiaMedia FLOAT DEFAULT 0;
    DECLARE _codiceForaggio VARCHAR(15);

	IF(NOT EXISTS(SELECT * FROM Allestimento a WHERE a.CodiceAllestimento = _codiceRiferimento))
		THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'L allestimento non e presente nel database';
	END IF;

	IF(NOT EXISTS(SELECT * FROM Stato s WHERE s.TimestampStato = _timestampStato))
		THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Lo stato non e presente nel database';
	END IF;

	SET _ultimoRiempimento = (SELECT UltimoRiempimento
							  FROM Stato INNER JOIN Allestimento ON CodiceRiferimento = CodiceAllestimento
				              WHERE CodiceRiferimento = _codiceRiferimento
							  AND TimestampStato = _timestampStato
				             );

	SET _nuovoTempo = ABS(TIMESTAMPDIFF(MINUTE,_timestampStato,_ultimoRiempimento));

	SET _codiceForaggio = (SELECT ValoreCorrente
						   FROM Stato
						   WHERE TipoMisura = 'Foraggio Contenuto'
						   AND Stato.CodiceRiferimento = _codiceRiferimento
						   AND Stato.TimestampStato = _ultimoRiempimento
			              );
	SET _vecchiaMedia = (SELECT TempoMedioConsumo 
						FROM Consumo 
						WHERE FK_CodiceForaggio_C = _codiceForaggio
						AND FK_CodiceAllestimento_C = _codiceRiferimento);
			
                 
	IF(_vecchiaMedia = 0)
    THEN
			UPDATE Consumo
            SET Consumo.TempoMedioConsumo = _nuovoTempo
            WHERE FK_CodiceForaggio_C = _codiceForaggio 
            AND FK_CodiceAllestimento_C = _codiceRiferimento;
	ELSE
            UPDATE Consumo
            SET Consumo.TempoMedioConsumo = (_nuovoTempo+9*_vecchiaMedia)/10
            WHERE FK_CodiceForaggio_C = _codiceForaggio 
            AND FK_CodiceAllestimento_C = _codiceRiferimento;
    END IF;
	
END $$


-- --------------------------------------------------------------------------------------
-- OPERAZIONE 2: Controllo Pulizia Locali
-- INSERT INTO Igiene VALUES (CURRENT_TIMESTAMP(),'LO001', 5,770000,205000,500,100); // Esempio con valore critico
-- INSERT INTO Igiene VALUES (CURRENT_TIMESTAMP(),'LO001', 3,755000,205000,500,100); // Esempio con due valori di guardia
-- --------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS insert_operazione_Igiene$$
CREATE TRIGGER insert_operazione_Igiene
AFTER INSERT ON Igiene
FOR EACH ROW
BEGIN
	DECLARE SumValGuardia INT DEFAULT 0;
	-- Livello Critico Livello Sporcizia --
	IF (new.LivelloSporcizia>4)
    THEN UPDATE Locale
		 SET StatoPulizia='Richiesto'
		 WHERE CodiceLocale=new.FK_CodiceLocale_I;
    END IF;
    -- Livello Guardia Livello Sporcizia --
	IF (new.LivelloSporcizia>2 AND new.LivelloSporcizia<4)
    THEN SET SumValGuardia= SumValGuardia+1;
    END IF;
	-- Livello Critico Azoto --
	IF ((New.Azoto<=750000) OR (New.Azoto>=810000 ))
    THEN UPDATE Locale
		 SET StatoPulizia='Richiesto'
		 WHERE CodiceLocale=new.FK_CodiceLocale_I;
    END IF;
	-- Livello Guardia Azoto --
	IF (((New.Azoto>750000)AND(New.Azoto<=760000))OR((New.Azoto>=800000)AND(New.Azoto<810000)))
    THEN SET SumValGuardia= SumValGuardia+1;
    END IF;
	-- Livello Critico Ossigeno --
	IF ((New.Ossigeno<=200000 ) OR (New.Ossigeno>=218000 ))
    THEN UPDATE Locale
		 SET StatoPulizia='Richiesto'
		 WHERE CodiceLocale=new.FK_CodiceLocale_I;
    END IF;
	-- Livello Guardia Ossigeno --
	IF (((New.Ossigeno>200000)AND(New.Ossigeno<=203000))OR((New.Ossigeno>=215000)AND(New.Ossigeno<218000)))
    THEN SET SumValGuardia= SumValGuardia+1;
    END IF;
	-- Livello Critico Metano --
	IF (New.Metano>=200)
    THEN UPDATE Locale
		 SET StatoPulizia='Richiesto'
		 WHERE CodiceLocale=new.FK_CodiceLocale_I;
    END IF;
	-- Livello Guardia Metano --
	IF ((New.Metano<200)AND(New.Metano>=150))
    THEN SET SumValGuardia= SumValGuardia+1;
    END IF;
	-- Livello Critico AnidrideCarbonica --
	IF (New.AnidrideCarbonica>=1000)
    THEN UPDATE Locale
		 SET StatoPulizia='Richiesto'
		 WHERE CodiceLocale=new.FK_CodiceLocale_I;
    END IF;
	-- Livello Guardia Anidride Carbonica --
	IF ((New.AnidrideCarbonica<1000)AND(New.AnidrideCarbonica>=800))
    THEN SET SumValGuardia= SumValGuardia+1;
    END IF;
    -- Controllo somma di valori nel livello di guardia --
    IF (SumValGuardia>=2)
    THEN UPDATE Locale
		 SET StatoPulizia='Richiesto'
		 WHERE CodiceLocale=new.FK_CodiceLocale_I;
    END IF;	

 END$$
 -- --------------------------------------------------------------------------------------
-- OPERAZIONE 3: VALUTAZIONE ANIMALE 
-- PROVA1. CALL valuta_animale('AN0001')
-- PROVA2. CALL valuta_animale('AN0003')
-- --------------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS valuta_animale$$
CREATE PROCEDURE valuta_animale (IN _CodiceAnimale VARCHAR(15))
BEGIN
	DECLARE _Valutazione FLOAT DEFAULT 0;
    
    DECLARE _EsamiTot FLOAT DEFAULT 0;
    DECLARE _EsamiPos FLOAT DEFAULT 0;
    DECLARE _EP FLOAT DEFAULT 0;
    DECLARE _V1 FLOAT DEFAULT 0;
	
    DECLARE _RiproduzioniTot FLOAT DEFAULT 0;
	DECLARE _RiproduzioniPos FLOAT DEFAULT 0;
	DECLARE _RP FLOAT DEFAULT 0;
    DECLARE _V2 FLOAT DEFAULT 0;
	
    DECLARE _GestazioniTot FLOAT DEFAULT 0;
    DECLARE _GestazioniPos FLOAT DEFAULT 0;
    DECLARE _GP FLOAT DEFAULT 0;
    DECLARE _V3 FLOAT DEFAULT 0;
    
	DECLARE _LatteProd FLOAT DEFAULT 0;
    DECLARE _LP FLOAT DEFAULT 0;
    DECLARE _V4 FLOAT DEFAULT 0;
    

	IF(NOT EXISTS(SELECT * FROM Animale WHERE Animale.CodiceAnimale = _CodiceAnimale))
    THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il codice inserito non ha corrispondenze nel database';
	END IF;
           
	-- Inizio i controlli relativi solo agli animali di sesso maschile
	IF('M'=(SELECT Sesso FROM Animale WHERE Animale.CodiceAnimale = _CodiceAnimale))
		THEN    
		-- Conto quanti esami ha fatto in totale l'animale, salvando anche in maniera separata quelli che hanno avuto esito positivo.
			SET _EsamiTot = (SELECT COUNT(CodiceEsame) 
							FROM Animale a INNER JOIN ControlloMedico cm ON a.CodiceAnimale = cm.FK_CodiceAnimale_C
							INNER JOIN Esame e ON cm.CodiceControllo = e.FK_CodiceControllo_E
							WHERE a.CodiceAnimale = _CodiceAnimale
							);
                    
			SET _EsamiPos = (SELECT COUNT(CodiceEsame) 
							FROM Animale a INNER JOIN ControlloMedico cm ON a.CodiceAnimale = cm.FK_CodiceAnimale_C
							INNER JOIN Esame e ON cm.CodiceControllo = e.FK_CodiceControllo_E
							WHERE a.CodiceAnimale = _CodiceAnimale
							AND e.EsitoEsame = 'Positivo'
							);
                    
			IF(_EsamiTot = 0)
				THEN
					SET _EP = 1;
				ELSE
					SET _EP = (_EsamiPos)/(_EsamiTot);
			END IF;
   
		-- Attribuisco poi a _V1 un valore ricavato a partire da _EP.
   
			IF(_EP < 0.25)
				THEN
					SET _V1 = 0;
			END IF;
			IF(_EP >= 0.25 AND _EP < 0.40)
				THEN
					SET _V1 = 1;
			END IF;
			IF(_EP >= 0.40 AND _EP < 0.55)
				THEN
					SET _V1 = 2;
			END IF;
			IF(_EP >= 0.55 AND _EP < 0.70)
				THEN
					SET _V1 = 3;
			END IF;
			IF(_EP >= 0.70 AND _EP < 0.83)
				THEN
					SET _V1 = 4;
			END IF;
			IF(_EP >= 0.83)
				THEN
					SET _V1 = 5;
			END IF;
    
		-- Conto a quante riproduzioni ha partecipato l'animale salvando anche in maniera separata quelle che hanno avuto esito positivo.
			SET _RiproduzioniTot = (SELECT COUNT(CodiceRiproduzione)
									FROM Animale a INNER JOIN Gestazione g ON a.CodiceAnimale = g.FK_CodiceAnimale_M
									WHERE a.CodiceAnimale = _CodiceAnimale
									);
                               
			SET _RiproduzioniPos = (SELECT COUNT(CodiceRiproduzione)
									FROM Animale a INNER JOIN Gestazione g ON a.CodiceAnimale = g.FK_CodiceAnimale_M
									WHERE a.CodiceAnimale = _CodiceAnimale
									AND g.EsitoRiproduzione = 'Successo'
									);
                               
			IF(_RiproduzioniTot = 0)
				THEN
					SET _RP = 1;
				ELSE
					SET _RP = (_RiproduzioniPos)/(_RiproduzioniTot);
			END IF;
        
		-- Attribuisco a _V2 un valore ricavato a partire da _RP
	   
			IF(_RP < 0.20)
				THEN
					SET _V2 = 0;
			END IF;
			IF(_RP >= 0.20 AND _RP < 0.35)
				THEN
					SET _V2 = 1;
			END IF;
			IF(_RP >= 0.35 AND _RP < 0.50)
				THEN
					SET _V2 = 2;
			END IF;
			IF(_RP >= 0.50 AND _RP < 0.60)
				THEN
					SET _V2 = 3;
			END IF;
			IF(_RP >= 0.60 AND _RP < 0.75)
				THEN
					SET _V2 = 4;
			END IF;
			IF(_RP >= 0.75)
				THEN
					SET _V2 = 5;
			END IF;
        
			SET _Valutazione = _V1 + _V2;
        
    END IF; 


	-- Inizio i controlli relativi solo agli animali di sesso femminile
	IF('F'=(SELECT Sesso FROM Animale WHERE Animale.CodiceAnimale = _CodiceAnimale))
		THEN
		-- Conto quanti esami ha fatto in totale l'animale, salvando anche in maniera separata quelli che hanno avuto esito positivo.
			SET _EsamiTot = (SELECT COUNT(CodiceEsame) 
							FROM Animale a INNER JOIN ControlloMedico cm ON a.CodiceAnimale = cm.FK_CodiceAnimale_C
							INNER JOIN Esame e ON cm.CodiceControllo = e.FK_CodiceControllo_E
							WHERE a.CodiceAnimale = _CodiceAnimale
							);
                    
			SET _EsamiPos = (SELECT COUNT(CodiceEsame) 
							FROM Animale a INNER JOIN ControlloMedico cm ON a.CodiceAnimale = cm.FK_CodiceAnimale_C
							INNER JOIN Esame e ON cm.CodiceControllo = e.FK_CodiceControllo_E
							WHERE a.CodiceAnimale = _CodiceAnimale
							AND e.EsitoEsame = 'Positivo'
							);
                    
			IF(_EsamiTot = 0)
				THEN
					SET _EP = 1;
				ELSE
					SET _EP = (_EsamiPos)/(_EsamiTot);
			END IF;
   
		-- Attribuisco poi a _V1 un valore ricavato a partire da _EP.
   
			IF(_EP < 0.25)
				THEN
					SET _V1 = 0;
				END IF;
			IF(_EP >= 0.25 AND _EP < 0.45)
				THEN
					SET _V1 = 1;
			END IF;
			IF(_EP >= 0.45 AND _EP < 0.70)
				THEN
					SET _V1 = 2;
			END IF;
			IF(_EP >= 0.70 AND _EP < 0.83)
				THEN
					SET _V1 = 3;
			END IF;
			IF(_EP >= 0.83)
				THEN
					SET _V1 = 4;
			END IF;
        
        -- Conto quante gestazioni ha avuto in totale l'animale, salvando anche in maniera separata quelle che hanno avuto esito positivo.
			SET _GestazioniTot = (SELECT COUNT(CodiceRiproduzione)
								  FROM Animale a
                                  INNER JOIN Gestazione g ON a.CodiceAnimale = g.FK_CodiceAnimale_F
                                  WHERE a.CodiceAnimale = _CodiceAnimale
                                  AND g.EsitoRiproduzione = 'Positivo'
                                  AND g.StatoGestazione <> 'In Corso'
                                 );
                                 
            SET _GestazioniPos = (SELECT COUNT(CodiceRiproduzione)
								  FROM Animale a
                                  INNER JOIN Gestazione g ON a.CodiceAnimale = g.FK_CodiceAnimale_F
                                  WHERE a.CodiceAnimale = _CodiceAnimale
                                  AND g.EsitoRiproduzione = 'Positivo'
                                  AND g.StatoGestazione = 'Successo'
                                  );
                                  
			IF(_GestazioniTot = 0)
				THEN
                
					SET _GP = 1;
				ELSE
					SET _GP = (_GestazioniPos)/(_GestazioniTot); 
			END IF;
            
		-- Attribuisco poi a _V3 un valore ricavato a partire da _GP.
               
			IF(_GP < 0.60)
				THEN
					SET _V3 = 0;
				END IF;
			IF(_GP >= 0.60 AND _GP < 0.75)
				THEN
					SET _V3 = 1;
			END IF;
			IF(_GP >= 0.75)
				THEN
					SET _V3 = 2;
			END IF;

		-- Conto quanti litri di latte ha prodotto l'animale negli ultimi 6 mesi, confrontando tale valore con valori predefiniti
        
			SET _LatteProd = (SELECT SUM(Quantita)
							  FROM Animale a
                              INNER JOIN Latte l ON a.CodiceAnimale = l.FK_CodiceAnimale_L
                              WHERE a.CodiceAnimale = _CodiceAnimale
                              AND l.DataMungitura + INTERVAL 6 MONTH >= current_date()
							 );
			
            IF('Bovino' = (SELECT Specie FROM Animale a WHERE a.CodiceAnimale = _CodiceAnimale))
				THEN
					SET _LP = (_LatteProd)/(4500);
			END IF;
			
            IF('Caprino' = (SELECT Specie FROM Animale a WHERE a.CodiceAnimale = _CodiceAnimale))
				THEN
					SET _LP = (_LatteProd)/(450);
			END IF;
    
            IF('Ovino' = (SELECT Specie FROM Animale a WHERE a.CodiceAnimale = _CodiceAnimale))
				THEN
					SET _LP = (_LatteProd)/(220);
			END IF;
            
            -- Attribuisco poi a _V4 un valore ricavato a partire da _LP.
            
			IF(_LP < 0.65 OR _LP IS NULL)
				THEN
					SET _V4 = 0;
				END IF;
			IF(_LP >= 0.65 AND _LP < 0.75)
				THEN
					SET _V4 = 1;
			END IF;
			IF(_LP >= 0.75 AND _LP < 1)
				THEN
					SET _V4 = 2;
			END IF;
			IF(_LP >= 1 AND _LP < 1.2)
				THEN
					SET _V4 = 3;
			END IF;
			IF(_LP >= 1.2)
				THEN    
					SET _V4 = 4;
			END IF;
			
            SET _Valutazione = _V1 +_V3 +_V4;
            
            END IF; -- (fine if animali di sesso femminile)

-- Attribuisco all'attributo "Valutazione" dell'animale considerato il valore ricavato
        
        UPDATE Animale
        SET Valutazione = _Valutazione
        WHERE CodiceAnimale = _CodiceAnimale;
END$$

-- ------------------------------------------------------------------------
-- EVENT PER AGGIORNAMENTO SEMESTRALE DELLA VALUTAZIONE DELL'ANIMALE
-- ------------------------------------------------------------------------

DROP EVENT IF EXISTS aggiorna_valutazioneAnimale$$
CREATE EVENT aggiorna_valutazioneAnimale
ON SCHEDULE EVERY 6 MONTH
STARTS '2020-01-01 01:00:00'
DO
BEGIN
	DECLARE finito INT DEFAULT 0;
	DECLARE _codiceAnimale VARCHAR(50);

	-- dichiarazione cursore per selezionare ogni codiceanimale
	DECLARE cerca CURSOR FOR
	SELECT a.CodiceAnimale
	FROM Animale a;

	-- dichiarazione handler per avvertire quando finisce la tabella
	DECLARE CONTINUE HANDLER FOR NOT FOUND 
		SET finito = 1;

	-- apertura del cursore
	OPEN cerca;

	-- seleziona il codiceanimale da animale e lo inserisce in _codiceAnimale

	label: LOOP

	-- prelevamento e controllo dei dati
	FETCH cerca INTO _codiceAnimale;

	IF finito = 1 THEN
	LEAVE label;
	END IF;

	CALL valuta_animale(_codiceAnimale);

	END LOOP;

	CLOSE cerca;

END $$

-- -----------------------------------------------------------------
-- OPERAZIONE 4: CONTROLLO ORDINI CON STATO PENDENTE
-- CALL _SelezionaProdotti ('OR00005')
-- SELECT * FROM ProdottoFinito
-- SELECT * FROM Ordine
-- -----------------------------------------------------------------
DROP EVENT IF EXISTS ControlloOrdini$$
CREATE EVENT ControlloOrdini
 ON SCHEDULE EVERY 1 HOUR
 STARTS '2020-02-12 17:00:00'
 ON COMPLETION PRESERVE
 DO BEGIN 
	DECLARE finito INT DEFAULT 0;
	DECLARE _codiceOrdine VARCHAR(15);
	-- dichiarazione cursore per selezionare ogni CodiceOrdine il cui stato sia 'Pendente'
	DECLARE cerca CURSOR FOR
		SELECT Ordine.CodiceOrdine
		FROM Ordine
		WHERE StatoOrdine='Pendente';
	-- dichiarazione handler per avvertire quando finisce la tabella
	DECLARE CONTINUE HANDLER FOR NOT FOUND 
		SET finito = 1;
	-- apertura del cursore
	OPEN cerca;
	-- seleziona il codiceOrdine da Ordine e la inserisce in _codiceOrdine
	label: LOOP
		FETCH cerca INTO _codiceOrdine;
        IF finito = 1 THEN
			LEAVE label;
		END IF;
        CALL _SelezionaProdotti(_codiceOrdine);
        END LOOP;
	CLOSE Cerca;
END$$

-- Selezione dei nomi dei prodotti ordinati ed eventuale associazione --
DROP PROCEDURE IF EXISTS _SelezionaProdotti$$
CREATE PROCEDURE _SelezionaProdotti(IN Codice_Ordine_Pendente VARCHAR(15))
BEGIN 
	DECLARE finito_ INT DEFAULT 0;
	DECLARE _NomeProdotto VARCHAR(30);
	DECLARE _Quantita INT UNSIGNED;
    DECLARE Failed INT DEFAULT 0;
    DECLARE Non_Trovati BOOL DEFAULT FALSE;
	-- dichiarazione cursore per selezionare ogni Nome Prodotto il cui codiceOrdine associato sia quello in entrata
	DECLARE cerca_1 CURSOR FOR
		SELECT FK_Nome_A,Quantita
		FROM Acquisto
		WHERE  FK_CodiceOrdine_A=Codice_Ordine_Pendente;
	-- dichiarazione cursore per selezionare ogni Nome Prodotto il cui CodiceOrdine associato sia quello in entrata
		DECLARE cerca_2 CURSOR FOR
		SELECT FK_Nome_A,Quantita
		FROM Acquisto
		WHERE  FK_CodiceOrdine_A=Codice_Ordine_Pendente;
	-- dichiarazione handler per avvertire quando finisce la tabella
	DECLARE CONTINUE HANDLER FOR NOT FOUND 
		SET finito_ = 1;
	-- apertura del cursore
	OPEN cerca_1;
	-- seleziona il NomeProdotto e quantita da Acquisto e la inserisce in _NomeProdotto e _Quantita
	label: LOOP
		FETCH cerca_1 INTO _NomeProdotto,_Quantita;
        IF finito_ = 1 THEN
			LEAVE label;
		END IF;
			SET Failed = _ControlloProdotti(_NomeProdotto,_Quantita);
			IF (Failed=1)
			THEN
				SET finito_=1;
				SET Non_Trovati=TRUE;
			END IF;
        END LOOP;
	CLOSE cerca_1;
    -- Inizio secondo ciclo con controllo --
	IF (Non_Trovati=FALSE)
    THEN
	-- apertura del cursore
		SET finito_=0;
		OPEN cerca_2;
		label_2: LOOP
			FETCH cerca_2 INTO _NomeProdotto,_Quantita;
			IF (finito_ = 1)
            THEN
				LEAVE label_2;
			END IF;
			CALL _AssociaProdotti(_NomeProdotto,_Quantita,Codice_Ordine_Pendente);
		END LOOP;
		CLOSE cerca_2;
	END IF;
END$$

-- Controllo esistenza di tutti i prodotti necessari non già venduti --
DROP FUNCTION IF EXISTS _ControlloProdotti$$
CREATE FUNCTION _ControlloProdotti(_NomeProdotto VARCHAR(30),_Quantita INT) RETURNS INT DETERMINISTIC
BEGIN
	DECLARE Ris INT;
	IF ((SELECT COUNT(PF.CodiceProdotto)
		FROM ProdottoFinito AS PF
        WHERE PF.Nome=_NomeProdotto 
			  AND PF.FK_CodiceOrdine_P IS NULL)>=_Quantita)
	THEN 
		SET Ris=0;
		RETURN(Ris);
    ELSE 
		SET Ris =1;
		RETURN(Ris);
	END IF;
END$$

-- Associazione Prodotti all'ordine pendente che stiamo controllando --
DROP PROCEDURE IF EXISTS _AssociaProdotti$$
CREATE PROCEDURE _AssociaProdotti(IN _NomeProdotto_3 VARCHAR(30), IN _Quantita_3 INT UNSIGNED, IN New_Ordine VARCHAR (15))
BEGIN
	DECLARE Count_ INT DEFAULT 0;
    DECLARE _CodiceProdottoScelto VARCHAR (15);
	DECLARE finito_3 INT DEFAULT 0;
	DECLARE _CodiceScaffale VARCHAR(15);
	-- dichiarazione cursore per selezionare ogni CodiceOrdine il cui stato sia 'Pendente', mettendoli in ordine crescente per selezionare quelli che scadono prima --
	DECLARE cerca_3 CURSOR FOR
		SELECT ProdottoFinito.CodiceProdotto
		FROM ProdottoFinito
		WHERE ProdottoFinito.Nome=_NomeProdotto_3 AND ProdottoFinito.FK_CodiceOrdine_P IS NULL
        ORDER BY ProdottoFinito.ScadenzaProdotto ASC;
	-- dichiarazione handler per avvertire quando finisce la tabella
	DECLARE CONTINUE HANDLER FOR NOT FOUND 
		SET finito_3 = 1;
	-- apertura del cursore
	OPEN cerca_3;
	label_3: LOOP
		FETCH cerca_3 INTO _CodiceProdottoScelto;
        IF ((finito_3 = 1) OR (Count_ = _Quantita_3)) THEN
			LEAVE label_3;
		END IF;
        SET _CodiceScaffale = (SELECT FK_CodiceScaffale_P
								  FROM ProdottoFinito
								  WHERE CodiceProdotto = _CodiceProdottoScelto);
	IF EXISTS (SELECT CodiceScaffale FROM Scaffale S INNER JOIN Magazzino M ON S.FK_CodiceStoccaggio_S = M.CodiceMagazzino WHERE CodiceScaffale = _CodiceScaffale)
    THEN
		UPDATE ProdottoFinito
		SET ProdottoFinito.FK_CodiceOrdine_P=New_Ordine, FK_CodiceScaffale_P = NULL
		WHERE ProdottoFinito.CodiceProdotto=_CodiceProdottoScelto;
		SET Count_ = Count_ + 1;
		UPDATE Ordine
		SET Ordine.StatoOrdine='In processazione'
		WHERE CodiceOrdine=New_Ordine;
	END IF;
	END LOOP;
END$$

-- --------------------------------------------------------------------
-- OPERAZIONE 5: CALCOLO PREZZO DI UN ORDINE
-- Prova1. CALL calcolo_prezzo ('OR00004')
-- Prova2. CALL calcolo_prezzo ('OR00003')
-- --------------------------------------------------------------------

DROP PROCEDURE IF EXISTS calcolo_prezzo$$
CREATE PROCEDURE calcolo_prezzo (IN _codiceOrdine VARCHAR(15))
BEGIN

	DECLARE _costoOrdine FLOAT DEFAULT (SELECT Prezzo FROM Ordine WHERE CodiceOrdine = _codiceOrdine);
    
	IF(NOT EXISTS(SELECT * FROM Ordine WHERE CodiceOrdine = _codiceOrdine))
		THEN
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'L ordine non e presente nel database';
	END IF;
    
    IF('Pendente' = (SELECT StatoOrdine FROM Ordine WHERE CodiceOrdine = _codiceOrdine))
		THEN 
			SET _costoOrdine = (SELECT SUM(ac.Quantita*pa.Prezzo)
								FROM Ordine o INNER JOIN Acquisto ac ON o.CodiceOrdine = ac.FK_CodiceOrdine_A
								INNER JOIN prodottoacquistabile pa ON  pa.Nome = ac.FK_Nome_A
								WHERE o.CodiceOrdine = _codiceOrdine
								);
	END IF;
                               
    IF('Pendente' <> (SELECT StatoOrdine FROM Ordine WHERE CodiceOrdine = _codiceOrdine) AND 'Evaso'<> (SELECT StatoOrdine FROM Ordine WHERE CodiceOrdine = _codiceOrdine) AND 'Spedito' <> (SELECT StatoOrdine FROM Ordine WHERE CodiceOrdine = _codiceOrdine))
		THEN 
			SET _costoOrdine = (SELECT SUM(ROUND((pf.Peso*(pa.Prezzo/pa.PesoKg)),2))
							    FROM Ordine o INNER JOIN Acquisto a ON o.CodiceOrdine = a.FK_CodiceOrdine_A 
								INNER JOIN prodottoacquistabile pa ON pa.Nome=a.FK_Nome_A
								INNER JOIN prodottofinito pf ON o.CodiceOrdine = pf.FK_CodiceOrdine_P
								AND pf.FK_NomeRicetta_P = pa.Nome
								AND CodiceOrdine = _codiceOrdine
                               );
			IF(_costoOrdine IS NULL)
				THEN
					SET _costoOrdine = 0;
			END IF;
	END IF;
    
    UPDATE Ordine
    SET Ordine.Prezzo = _costoOrdine
    WHERE Ordine.CodiceOrdine = _codiceOrdine;
END $$

-- ------------------------------------------------------------------
-- trigger per settare il prezzo dell'ordine
-- ------------------------------------------------------------------
DROP TRIGGER IF EXISTS set_prezzo$$
CREATE TRIGGER set_prezzo
AFTER INSERT ON Ordine
FOR EACH ROW
BEGIN
	CALL calcolo_prezzo(new.CodiceOrdine);
END$$

-- ------------------------------------------------------------------
-- event per aggiornare il prezzo dell'ordine
-- ------------------------------------------------------------------

DROP EVENT IF EXISTS aggiorna_prezzoOrdine$$
CREATE EVENT aggiorna_prezzoOrdine
ON SCHEDULE EVERY 12 HOUR
STARTS '2020-01-01 01:00:00'
DO
BEGIN
	DECLARE finito INT DEFAULT 0;
	DECLARE _codiceOrdine VARCHAR(50);

	-- dichiarazione cursore per selezionare ogni CodiceOrdine
	DECLARE cerca CURSOR FOR
	SELECT o.CodiceOrdine
	FROM Ordine o
    WHERE o.StatoOrdine = 'Pendente'
    OR o.StatoOrdine = 'In Processazione';

	-- dichiarazione handler per avvertire quando finisce la tabella
	DECLARE CONTINUE HANDLER FOR NOT FOUND 
		SET finito = 1;

	-- apertura del cursore
	OPEN cerca;

	-- seleziona il codiceanimale da animale e lo inserisce in _codiceAnimale

	label: LOOP

	-- prelevamento e controllo dei dati
	FETCH cerca INTO _codiceOrdine;

	IF finito = 1 THEN
		LEAVE label;
	END IF;

	CALL calcolo_prezzo(_codiceOrdine);

	END LOOP;

	CLOSE cerca;
END$$

-- -----------------------------------------------------------------------
-- OPERAZIONE 6: ANALISI RITARDI
-- Prova1. CALL valuta_ritardi('AN0001')
-- Prova1. CALL valuta_ritardi('AN0002')
-- -------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS valuta_ritardi$$
CREATE PROCEDURE valuta_ritardi (IN _CodiceAnimale VARCHAR(15))
BEGIN

	DECLARE _numRitardi INT DEFAULT 2;
    DECLARE _freqRitardi ENUM('Trascurabile','Significativa','Critica') DEFAULT 'Trascurabile';
    
	IF (NOT EXISTS (SELECT * FROM Animale WHERE Animale.CodiceAnimale = _CodiceAnimale))
		THEN
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'L animale non e presente nel database';
	END IF;
    
    SET _numRitardi = (SELECT COUNT(i.TimestampGPS)
						FROM Animale a 
								INNER JOIN Locale l ON (a.FK_CodiceLocale_A = l.CodiceLocale)
								INNER JOIN Pascola p ON (p.FK_CodiceLocale_P = l.CodiceLocale)
								INNER JOIN InfoGPS i ON (i.CodiceGPS = a.CodiceAnimale)
						WHERE a.CodiceAnimale = _CodiceAnimale
								AND i.Zona = 'Rientro'
								AND DATE(i.TimestampGPS) + INTERVAL 7 DAY >= CURRENT_DATE()
								AND p.OraRientro + INTERVAL 15 MINUTE<= TIME(i.TimestampGPS) 
								AND TIME(i.TimestampGPS) < p.OraRientro + INTERVAL 60 MINUTE
								AND TIME(i.TimestampGPS) > p.OraRientro
					  );
                      
	IF(_numRitardi >= 0 AND _numRitardi <= 1)
		THEN SET _freqRitardi = 'Trascurabile';
	END IF;
    
    IF(_numRitardi >= 2 AND _numRitardi <= 4)
		THEN SET _freqRitardi = 'Significativa';
	END IF;
    
    IF(_numRitardi >= 5 AND _numRitardi <= 7)
		THEN SET _freqRitardi = 'Critica';
	END IF;

	UPDATE Animale
	SET Animale.FreqRitardi = _freqRitardi
	WHERE Animale.CodiceAnimale = _CodiceAnimale;
END $$

-- ------------------------------------------------------------------------
-- EVENT PER AGGIORNAMENTO SETTIMANALE DELL'ANALISI DEI RITARDI
-- ------------------------------------------------------------------------

DROP EVENT IF EXISTS aggiorna_valutazioneRitardi$$
CREATE EVENT aggiorna_valutazioneRitardi
ON SCHEDULE EVERY 7 DAY
STARTS '2020-01-01 01:00:00'
DO
BEGIN
	DECLARE finito INT DEFAULT 0;
	DECLARE _codiceAnimale VARCHAR(50);

	-- dichiarazione cursore per selezionare ogni animale
	DECLARE cerca CURSOR FOR
	SELECT a.CodiceAnimale
	FROM Animale a;

	-- dichiarazione handler per avvertire quando finisce la tabella
	DECLARE CONTINUE HANDLER FOR NOT FOUND 
		SET finito = 1;

	-- apertura del cursore
	OPEN cerca;

	-- seleziona il codice animale da animale e la inserisce in _codiceAnimale

	label: LOOP

	-- prelevamento e controllo dei dati
	FETCH cerca INTO _codiceAnimale;

	IF finito = 1 THEN
	LEAVE label;
	END IF;

	CALL valuta_ritardi(_codiceAnimale);

	END LOOP;

	CLOSE cerca;

END $$

-- ---------------------------------------------------------------------
-- OPERAZIONE 7: inserimento del latte nel silos
-- INSERT INTO Latte VALUES  ('LA0050', 50, '2020-02-11 11:30:00', NULL, 'AN0004', 'MU0004'); COMMIT;
-- INSERT INTO Parametri VALUES ('LA0050', 15, 30, 15, 5, 25, 10); COMMIT;
-- ---------------------------------------------------------------------
DROP TRIGGER IF EXISTS scelta_del_silos$$
CREATE TRIGGER scelta_del_silos
AFTER INSERT ON Parametri
FOR EACH ROW
BEGIN 
	DECLARE _lEnzimi FLOAT DEFAULT 0;
	DECLARE _lAcqua FLOAT DEFAULT 0;
	DECLARE _lProteine FLOAT DEFAULT 0;
	DECLARE _lLipidi FLOAT DEFAULT 0;
	DECLARE _lZuccheri FLOAT DEFAULT 0;
	DECLARE _lMinerali FLOAT DEFAULT 0;
    DECLARE _quantita FLOAT DEFAULT 0;
    
    DECLARE _tolleranza FLOAT DEFAULT 0;
    DECLARE _silosD VARCHAR(15);
    
    -- mi ricavo il latte tramite i suoi parametri
    SET _lEnzimi = (SELECT P.ConcEnzimi
					FROM Parametri P INNER JOIN Latte L ON P.CodiceParametri = L.CodiceLatte
                    WHERE L.CodiceLatte = new.CodiceParametri
                    );
	
    SET _lAcqua = (SELECT P.ConcAcqua
					FROM Parametri P INNER JOIN Latte L ON P.CodiceParametri = L.CodiceLatte
					WHERE L.CodiceLatte = new.CodiceParametri
					);   
                
	SET _lProteine = (SELECT P.ConcProteine
						FROM Parametri P INNER JOIN Latte L ON P.CodiceParametri = L.CodiceLatte
						WHERE L.CodiceLatte = new.CodiceParametri
						);
                    
	SET _lLipidi = (SELECT P.ConcLipidi
					FROM Parametri P INNER JOIN Latte L ON P.CodiceParametri = L.CodiceLatte
                    WHERE L.CodiceLatte = new.CodiceParametri
                    );
                    
	SET _lZuccheri = (SELECT P.ConcZuccheri
						FROM Parametri P INNER JOIN Latte L ON P.CodiceParametri = L.CodiceLatte
						WHERE L.CodiceLatte = new.CodiceParametri
						);
                    
	SET _lMinerali = (SELECT P.ConcMinerali
						FROM Parametri P INNER JOIN Latte L ON P.CodiceParametri = L.CodiceLatte
						WHERE L.CodiceLatte = new.CodiceParametri
						);
	
    SET _quantita = (SELECT Quantita FROM Latte WHERE CodiceLatte = new.CodiceParametri);
    
    -- controllo se i silos sono tutti pieni
    IF( NOT EXISTS(SELECT*
					FROM Silos
                    WHERE (PercLivelloRiempimento/100)*Capacita + _quantita <= Capacita))
		THEN 
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Tutti i silos sono pieni';
	END IF;
    
    -- scelgo il silos con i parametri più simili a quelli del latte
    SET _tolleranza = (SELECT MIN(POW((_lEnzimi - P.ConcEnzimi),2) + POW((_lAcqua - P.ConcAcqua),2) + POW((_lProteine - P.ConcProteine),2) +POW((_lLipidi - P.ConcLipidi),2) + POW((_lZuccheri - P.ConcZuccheri),2) + POW((_lMinerali - P.ConcMinerali),2))
						FROM Silos S INNER JOIN Parametri P ON S.CodiceSilos = P.CodiceParametri
						 WHERE (S.PercLivelloRiempimento/100)*S.Capacita + _quantita <= S.Capacita);
	
    SET _silosD = (SELECT CodiceSilos
					FROM Silos S INNER JOIN Parametri P ON S.CodiceSilos = P.CodiceParametri
                    WHERE POW((_lEnzimi - P.ConcEnzimi),2) + POW((_lAcqua - P.ConcAcqua),2) + POW((_lProteine - P.ConcProteine),2) +POW((_lLipidi - P.ConcLipidi),2) + POW((_lZuccheri - P.ConcZuccheri),2) + POW((_lMinerali - P.ConcMinerali),2)= _tolleranza
                    );

	UPDATE Latte
    SET FK_CodiceSilos_L = _silosD
    WHERE CodiceLatte = new.CodiceParametri;
    
    UPDATE Silos
    SET PercLivelloRiempimento = (((PercLivelloRiempimento/100)*Capacita + _quantita)/Capacita)*100
    WHERE CodiceSilos = _silosD;

END $$

-- ----------------------------------------------------------------------------
-- OPERAZIONE 8: inserimento di un lotto di prodotti finiti sugli scaffali
-- ------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS inserimentoSuScaffale$$
CREATE TRIGGER inserimentoSuScaffale
AFTER INSERT ON Lotto
FOR EACH ROW
BEGIN
	DECLARE _scaffaleDest VARCHAR(15);
    DECLARE _tempoStagionatura INT;
    DECLARE _pesoProdotto FLOAT;
    
    DECLARE finito INT DEFAULT 0;
    
    
	DECLARE _codiceProdotto VARCHAR(50);
    
	-- dichiarazione cursore per selezionare ogni codiceprodotto
	DECLARE cerca CURSOR FOR
	SELECT CodiceProdotto
	FROM ProdottoFinito
    WHERE FK_CodiceLotto_P = new.CodiceLotto;

	-- dichiarazione handler per avvertire quando finisce la tabella
	DECLARE CONTINUE HANDLER FOR NOT FOUND 
		SET finito = 1;
	
    SET _tempoStagionatura = (SELECT DISTINCT R.GiorniStagionatura
								FROM ProdottoFinito P INNER JOIN Ricetta R ON P.FK_NomeRicetta_P = R.NomeRicetta
								WHERE P.FK_CodiceLotto_P = new.CodiceLotto
							 );
                                
	-- apertura del cursore
	OPEN cerca;

	label: LOOP

	-- prelevamento e controllo dei dati
	FETCH cerca INTO _codiceProdotto;

	IF finito = 1 THEN
	LEAVE label;
	END IF;
    
    SET _pesoProdotto = (SELECT Peso
						 FROM ProdottoFinito
						 WHERE CodiceProdotto = _codiceProdotto
						);
	/*	inserisco un prodotto. Se è il primo prodotto del lotto, lo assegno ad uno scaffale libero. 
		se c'è gia un prodotto del solito lotto guardo se quello scaffale non è pieno. se non è pieno aggiungo il prodotto li accanto, 
		altrimenti lo metto nello scaffale successivo */

	IF(_tempoStagionatura > 0) THEN
    
		IF(NOT EXISTS( SELECT S.CodiceScaffale
						FROM Scaffale S INNER JOIN Cantina C ON S.FK_CodiceStoccaggio_S = C.CodiceCantina
                        WHERE S.CapacitaResidua > 50
						))
           THEN
				SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Gli scaffali della cantina sono tutti pieni';
		END IF;
        
        -- Controllo se ci sono gia altri prodotti del lotto inseriti nella cantina
		IF( NOT EXISTS( SELECT S.CodiceScaffale
						FROM ProdottoFinito P INNER JOIN Scaffale S ON P.FK_CodiceScaffale_P = S.CodiceScaffale INNER JOIN Magazzino M ON S.FK_CodiceStoccaggio_S = M.CodiceMagazzino
                        WHERE P.FK_CodiceLotto_P = new.CodiceLotto AND (S.CapacitaResidua/100)*S.CapacitaTot >= _pesoProdotto
                        ))
		THEN
			SET _scaffaleDest = ( SELECT MAX(S.CodiceScaffale) 
									FROM Scaffale S INNER JOIN Cantina C ON S.FK_CodiceStoccaggio_S = C.CodiceCantina
									WHERE S.CapacitaResidua >= 50
								); 
		ELSE 
			SET _scaffaleDest = ( SELECT MIN(S.CodiceScaffale)
									FROM ProdottoFinito P INNER JOIN Scaffale S ON P.FK_CodiceScaffale_P = S.CodiceScaffale INNER JOIN Cantina C ON S.FK_CodiceStoccaggio_S = C.CodiceCantina
                                    WHERE P.FK_CodiceLotto_P = new.CodiceLotto AND (S.CapacitaResidua/100)*S.CapacitaTot >= _pesoProdotto
								);
		END IF;
        
		-- Controllo se ci sono gia altri prodotti del lotto inseriti nel magazzino    
    ELSE -- (_tempostagionatura = 0) 
		IF(NOT EXISTS( SELECT S.CodiceScaffale
						FROM Scaffale S INNER JOIN Magazzino M ON S.FK_CodiceStoccaggio_S = M.CodiceMagazzino
                        WHERE S.CapacitaResidua > 50
						))
           THEN
				SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Gli scaffali del magazzino sono tutti pieni';
		END IF;
        
		IF( NOT EXISTS( SELECT S.CodiceScaffale
						FROM ProdottoFinito P INNER JOIN Scaffale S ON P.FK_CodiceScaffale_P = S.CodiceScaffale INNER JOIN Magazzino M ON S.FK_CodiceStoccaggio_S = M.CodiceMagazzino
                        WHERE P.FK_CodiceLotto_P = new.CodiceLotto AND (S.CapacitaResidua/100)*S.CapacitaTot >= _pesoProdotto
                        ))
		THEN
			SET _scaffaleDest = ( SELECT MAX(S.CodiceScaffale) 
									FROM Scaffale S INNER JOIN Magazzino M ON S.FK_CodiceStoccaggio_S = M.CodiceMagazzino
									WHERE S.CapacitaResidua >= 50
								); 
		ELSE 
			SET _scaffaleDest = ( SELECT MIN(S.CodiceScaffale)
									FROM ProdottoFinito P INNER JOIN Scaffale S ON P.FK_CodiceScaffale_P = S.CodiceScaffale INNER JOIN Magazzino M ON S.FK_CodiceStoccaggio_S = M.Magazzino
                                    WHERE P.FK_CodiceLotto_P = new.CodiceLotto AND (S.CapacitaResidua/100)*S.CapacitaTot >= _pesoProdotto
								);
		END IF;
	END IF; 
        
	UPDATE ProdottoFinito
	SET FK_CodiceScaffale_P = _scaffaleDest
	WHERE CodiceProdotto = _codiceProdotto;
    
    UPDATE Scaffale
    SET CapacitaResidua = (((CapacitaResidua/100)*CapacitaTot - _pesoProdotto)/CapacitaTot)*100
    WHERE CodiceScaffale = _scaffaleDest;
	
              		
    
	END LOOP;

	CLOSE cerca;

END $$

-- -----------------------------------------------------------------
-- Analytic 1: per vicinanza animali
-- CALL secondoCiclo('AN0001', 'LO001') Risultati ad animale 2 e 5  (Parte 1)
-- CALL ricavaSoste('AN0001') 4 soste (Parte 2)
-- -----------------------------------------------------------------

/*EVENT PER CALCOLO VICINANZA*/

DROP EVENT IF EXISTS analytics_vicinanza$$
CREATE EVENT analytics_vicinanza
ON SCHEDULE EVERY 7 DAY
STARTS '2020-01-01 01:00:00'
DO
BEGIN
	DECLARE finitoEst INT DEFAULT 0;
    DECLARE LocaleEst VARCHAR(50);
	DECLARE CodiceAnimaleEst VARCHAR(50);

	-- dichiarazione cursore per selezionare ogni codiceanimale
	DECLARE cercaEst CURSOR FOR
	SELECT a.CodiceAnimale, a.FK_CodiceLocale_A
	FROM Animale a;


	DECLARE CONTINUE HANDLER FOR NOT FOUND 
		SET finitoEst = 1;


	OPEN cercaEst;

	labelEst: LOOP
		FETCH cercaEst INTO CodiceAnimaleEst, LocaleEst;
		IF finitoEst = 1 THEN
			LEAVE labelEst;
		END IF;
        
		CALL ricavaSoste(CodiceAnimaleEst);
		CALL secondoCiclo(CodiceAnimaleEst,LocaleEst);

	END LOOP;

	CLOSE cercaEst;
END $$


/*PROCEDURE PER TROVARE L ALTRO ANIMALE E AGGIORNARE LA TABELLA DI APPOGGIO RELAZIONI VICINANZA*/
DROP PROCEDURE IF EXISTS secondoCiclo$$
CREATE PROCEDURE secondoCiclo(IN _CodiceAnimaleEst VARCHAR(50), IN LocaleEst VARCHAR(50))
BEGIN
    DECLARE finitoInt INT DEFAULT 0;
    DECLARE LocaleInt VARCHAR(50);
    DECLARE CodiceAnimaleInt VARCHAR(50);
    DECLARE _Vicinanze INT DEFAULT 0;

	-- dichiarazione cursore per selezionare ogni codiceanimale
	DECLARE cercaInt CURSOR FOR
	SELECT a.CodiceAnimale
	FROM Animale a
    WHERE a.FK_CodiceLocale_A = LocaleEst
    AND a.CodiceAnimale > _CodiceAnimaleEst; -- Per evitare di controllare due volte la stessa coppia di animali


	DECLARE CONTINUE HANDLER FOR NOT FOUND 
		SET finitoInt = 1;


	OPEN cercaInt;

	labelInt: LOOP
		FETCH cercaInt INTO CodiceAnimaleInt;
		IF finitoInt = 1 THEN
			LEAVE labelInt;
		END IF;

		SET _Vicinanze = calcolaVicinanze(_CodiceAnimaleEst, CodiceAnimaleInt);
        
		IF(NOT EXISTS(SELECT * FROM RelazioniVicinanza WHERE (Animale1 = _CodiceAnimaleEst AND Animale2 = CodiceanimaleInt) OR (Animale1 = CodiceanimaleInt AND Animale2 = _CodiceAnimaleEst)))
					THEN
						INSERT INTO RelazioniVicinanza VALUES(_CodiceAnimaleEst, CodiceAnimaleInt, _Vicinanze, current_timestamp()); 
						COMMIT;
		ELSE
			UPDATE RelazioniVicinanza rv
            SET rv.Vicinanze = _Vicinanze
            WHERE (rv.Animale1 = _CodiceAnimaleEst AND rv.Animale2 = CodiceanimaleInt) OR (rv.Animale1 = CodiceanimaleInt AND rv.Animale2 = _CodiceAnimaleEst);
		END IF;
        
	END LOOP;

	CLOSE cercaInt;
END $$


DROP FUNCTION IF EXISTS calcolaVicinanze$$
CREATE FUNCTION calcolaVicinanze(_CodiceAnimaleEst_2 VARCHAR(50),CodiceAnimaleInt VARCHAR(50)) RETURNS INT DETERMINISTIC
BEGIN
	DECLARE _conta INT UNSIGNED DEFAULT 0;
    
    SET _conta =(SELECT COUNT(gps1.CodiceGPS)  
				FROM (INFOGPS gps1 INNER JOIN Animale a1 ON gps1.CodiceGPS = a1.CodiceAnimale) INNER JOIN (INFOGPS gps2 INNER JOIN Animale a2 ON gps2.CodiceGPS = a2.CodiceAnimale)
				WHERE a1.CodiceAnimale = _CodiceAnimaleEst_2
				AND a2.CodiceAnimale = CodiceAnimaleInt
				AND ABS(TIMESTAMPDIFF(MINUTE, gps1.TimestampGPS, gps2.TimestampGPS)) <= 5
				AND gps1.Zona = gps2.Zona
				AND EXISTS (SELECT CodicePascolo FROM Pascolo WHERE CodicePascolo=gps1.Zona)
				AND SQRT(POW(gps1.Latitudine-gps2.Latitudine, 2)-POW(gps1.Longitudine-gps2.Longitudine, 2)) <= 0.00005
                AND gps1.TimestampGPS + INTERVAL 7 DAY >= current_timestamp());
	RETURN(_conta);
END $$

-- -----------------------------------------------------------------
-- Analytics 1: per luoghi preferito animale
-- -----------------------------------------------------------------

/*View contentente l'insieme dei luoghi visitati (singolarmente) da ogni animale più di una volta*/
CREATE OR REPLACE VIEW LuoghiPreferiti
AS
	SELECT A1.CodiceAnimale as Animale, I1.TimestampGPS as DataGps, count(I2.TimestampGPS) as conta, I1.Latitudine as Latitudine, I1.Longitudine as Longitudine
	FROM (Animale A1 INNER JOIN InfoGPS I1 ON A1.CodiceAnimale = I1.CodiceGPS) 
    INNER JOIN (Animale A2 INNER JOIN InfoGPS I2 ON A2.CodiceAnimale = I2.CodiceGPS) 
    ON A1.CodiceAnimale = A2.CodiceAnimale
	WHERE TIMESTAMPDIFF(MINUTE,I1.TimestampGPS,I2.TimestampGPS) > 0 
	AND SQRT(POW(I1.Latitudine-I2.Latitudine, 2)-POW(I1.Longitudine-I2.Longitudine, 2)) <= 0.00005
	AND I1.Zona = I2.Zona
	AND EXISTS (SELECT CodicePascolo FROM Pascolo WHERE CodicePascolo=I1.Zona)
	group by(I1.TimestampGPS)
$$

DROP PROCEDURE IF EXISTS ricavaSoste$$
CREATE PROCEDURE ricavaSoste(IN _CodiceAnimale VARCHAR(15))
BEGIN
	DECLARE _SosteZona INT DEFAULT 0;
    DECLARE _Latitudine DECIMAL(10, 7) DEFAULT 0;
    DECLARE _Longitudine DECIMAL(10, 7) DEFAULT 0;
    DECLARE _TimestampGPSAnimale TIMESTAMP DEFAULT '0000-00-00 00:00:00';
    
    SET _SosteZona = (SELECT conta
						FROM LuoghiPreferiti lp1 
                        INNER JOIN(
							SELECT MAX(lp2.conta) as MassimaConta, lp2.Animale
							FROM LuoghiPreferiti lp2
                            WHERE lp2.DataGps + INTERVAL 7 DAY >= current_date()
							GROUP BY lp2.Animale
						)as A ON A.animale = lp1.Animale
						WHERE lp1.conta = A.MassimaConta
						AND lp1.Animale = _CodiceAnimale
						AND DataGps = (SELECT MAX(DataGps) FROM LuoghiPreferiti lp3 
										WHERE lp3.Animale = _CodiceAnimale 
                                        AND lp3.conta = A.MassimaConta
                                        AND lp3.DataGps + INTERVAL 7 DAY >= current_date()
                                        )                    );
                    
	SET _Latitudine = (SELECT Latitudine
						FROM LuoghiPreferiti lp1 
                        INNER JOIN(
							SELECT MAX(lp2.conta) as MassimaConta, lp2.Animale
							FROM LuoghiPreferiti lp2
                            WHERE lp2.DataGps + INTERVAL 7 DAY >= current_date()
							GROUP BY lp2.Animale
						)as A ON A.animale = lp1.Animale
						WHERE lp1.conta = A.MassimaConta
						AND lp1.Animale = _CodiceAnimale
						AND DataGps = (SELECT MAX(DataGps) FROM LuoghiPreferiti lp3 
										WHERE lp3.Animale = _CodiceAnimale 
                                        AND lp3.conta = A.MassimaConta
                                        AND lp3.DataGps + INTERVAL 7 DAY >= current_date()
                                        )					);
		
    SET _Longitudine = (SELECT Longitudine
						FROM LuoghiPreferiti lp1 
                        INNER JOIN(
							SELECT MAX(lp2.conta) as MassimaConta, lp2.Animale
							FROM LuoghiPreferiti lp2
                            WHERE lp2.DataGps + INTERVAL 7 DAY >= current_date()
							GROUP BY lp2.Animale
						)as A ON A.animale = lp1.Animale
						WHERE lp1.conta = A.MassimaConta
						AND lp1.Animale = _CodiceAnimale
						AND DataGps = (SELECT MAX(DataGps) FROM LuoghiPreferiti lp3 
										WHERE lp3.Animale = _CodiceAnimale 
                                        AND lp3.conta = A.MassimaConta
                                        AND lp3.DataGps + INTERVAL 7 DAY >= current_date()
                                        )					);
                    
    SET _TimestampGPSAnimale = (SELECT DataGPS
						FROM LuoghiPreferiti lp1 
                        INNER JOIN(
							SELECT MAX(lp2.conta) as MassimaConta, lp2.Animale
							FROM LuoghiPreferiti lp2
                            WHERE lp2.DataGps + INTERVAL 7 DAY >= current_date()
							GROUP BY lp2.Animale
						)as A ON A.animale = lp1.Animale
						WHERE lp1.conta = A.MassimaConta
						AND lp1.Animale = _CodiceAnimale
						AND DataGps = (SELECT MAX(DataGps) FROM LuoghiPreferiti lp3 
										WHERE lp3.Animale = _CodiceAnimale 
                                        AND lp3.conta = A.MassimaConta
                                        AND lp3.DataGps + INTERVAL 7 DAY >= current_date()
                                        )
					);
    IF(NOT EXISTS(SELECT * FROM ZonePreferite zp WHERE zp.Animale = _CodiceAnimale AND zp.TimestampGPSAnimale = TimestampGPSAnimale))
		THEN
			INSERT INTO ZonePreferite VALUES(_CodiceAnimale,_Latitudine,_Longitudine,_SosteZona,_TimestampGPSAnimale,current_timestamp());
	END IF;
END $$



-- ----------------------------------------------------------------------------------------------------------------------
-- ANALYTIC 2:  Controllo qualità di processo 
-- PROVA CALL ValutazioneQualitaProcesso('Gorgonzola Medio')
-- ----------------------------------------------------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS ValutazioneQualitaProcesso$$
CREATE PROCEDURE ValutazioneQualitaProcesso (IN Nome_Prodotto VARCHAR(30))
BEGIN
	
    DECLARE _temporichiesta DATE DEFAULT current_date();
    DECLARE _durataideale INT DEFAULT 0;
    DECLARE _duratamedia INT DEFAULT 0;
    DECLARE _nUltima INT DEFAULT 0;
    DECLARE _tempostag INT DEFAULT 0;
    
	IF NOT EXISTS (SELECT * FROM ProdottoAcquistabile WHERE Nome = Nome_Prodotto)
    THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Errore, prodotto non esistente';
	END IF;
    
	IF NOT EXISTS (SELECT * FROM ProdottoFinito WHERE Nome = Nome_Prodotto)
    THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Errore, prodotto non prodotto';
	END IF;
    
    IF(EXISTS(SELECT * FROM IndiciFasi rs WHERE rs.NomeProdotto = Nome_Prodotto AND rs.DataRichiesta = CURDATE()))
    THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il dato cercato relativo alla data odierna è già presente nella tabella IndiciFasi';
	END IF;
    
	DROP TEMPORARY TABLE IF EXISTS DiffFasi;
	CREATE TEMPORARY TABLE DiffFasi
	SELECT T1.NomeProdotto, T1.NumFase1 as NumFase, T2.Descrizione as DescrizioneFase ,(T1.Mf- T2.Minutifase) as DeltaMinutiFase, (T1.Mr-T2.MinutiRiposo) as DeltaMinutiRiposo, (T1.Sg-T2.SalaturaGrammi) as DeltaSalaturaGrammi, (T1.Tl-T2.TemperaturaLatte) as DeltaTemperaturaLatte
	FROM(
		SELECT NumFase as NumFase1, pf.Nome as NomeProdotto, avg(MinutiFase) as Mf, avg(MinutiRiposo) as Mr, avg(SalaturaGrammi) as Sg, avg(TemperaturaLatte) as Tl
		FROM Fase f INNER JOIN ProdottoFinito pf ON f.FK_CodiceProdotto_F = pf.CodiceProdotto
		WHERE pf.Nome = Nome_Prodotto
		GROUP BY (NumFase)
		) as T1
		INNER JOIN
		(
		SELECT NumFase as NumFase2, MinutiFase,MinutiRiposo, SalaturaGrammi, TemperaturaLatte, Descrizione
		FROM Fase fa
		WHERE fa.FK_NomeRicetta_F = Nome_Prodotto
		) as T2
		ON T1.NumFase1 = T2.NumFase2
	GROUP BY(T1.NumFase1);

	ALTER TABLE DiffFasi
	ADD TempoStagionatura INT DEFAULT 0;
    ALTER TABLE DiffFasi
    ADD DataRichiesta TIMESTAMP DEFAULT CURRENT_TIMESTAMP();
    
    SET _durataideale = (SELECT GiorniStagionatura FROM Ricetta WHERE NomeRicetta = Nome_Prodotto);
    
    SET _duratamedia = (SELECT AVG(DATEDIFF(pf.DataFineStagionatura,l.DataProduzione))
						FROM Lotto l INNER JOIN ProdottoFinito pf ON pf.FK_CodiceLotto_P = l.CodiceLotto
						WHERE pf.DataFineStagionatura IS NOT NULL
						AND pf.Nome = Nome_Prodotto);
	
	IF(_duratamedia IS NULL)
    THEN
		SET _tempostag = 0;
    ELSE
		SET _tempostag = _durataideale - _duratamedia;
	END IF;
                        
    SET _nUltima = (SELECT COUNT(NumFase)+1 FROM Fase WHERE Fase.FK_NomeRicetta_F = Nome_Prodotto);
    
	
    
    INSERT INTO IndiciFasi
    SELECT * FROM DiffFasi;
    
    INSERT INTO IndiciFasi VALUES (Nome_Prodotto ,_nUltima, 'Stagionatura',0,0,0,0,_tempostag, _temporichiesta);
END$$

DROP TRIGGER IF EXISTS AggiornaValutazioneFase$$
CREATE TRIGGER AggiornaValutazioneFase
AFTER INSERT ON IndiciFasi
FOR EACH ROW
BEGIN
    DECLARE _indice INT DEFAULT 0;
    DECLARE _Valutazione ENUM ('Scadente','Buona','Perfetta') DEFAULT 'Perfetta';
	IF(new.DeltaGiorniStagionatura IS NOT NULL)
		THEN
			SET _indice = (ABS(new.DeltaMinutiFase)+ABS(new.DeltaMinutiRiposo)+ABS(new.DeltaSalaturaGrammi)+ABS(new.DeltaTemperaturaLatte)+ABS(new.DeltaGiorniStagionatura));
    ELSE
			SET _indice = (ABS(new.DeltaMinutiFase)+ABS(new.DeltaMinutiRiposo)+ABS(new.DeltaSalaturaGrammi)+ABS(new.DeltaTemperaturaLatte));
    END IF;
    
    IF(_indice >= 0 AND _indice <= 1)
		THEN
			SET _Valutazione = 'Perfetta';
	END IF;
    IF(_indice >=2 AND _indice <= 5)
		THEN 
			SET _Valutazione = 'Buona';
	END IF;
    IF(_indice >= 6)
		THEN
			SET _Valutazione =  'Scadente';
	END IF;
    
    INSERT INTO ResocontoFasi VALUES(new.NomeProdotto, new.NumeroFase, new.DataRichiesta, new.DescrizioneFase, _Valutazione);
END$$

-- --------------------------------------------------------------------------------------------------
-- ANALYTIC 3: Tracciabilità di filiera
-- INSERT INTO Recensione VALUES
-- ('PF00003','No',1,'Buona','Buono','Buona',' '),
-- ('PF00001','No',4,'Scadente', 'Buono', 'Buona', ' ');
-- --------------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS Tracciabilita_Filiera$$
CREATE TRIGGER Tracciabilita_Filiera
AFTER INSERT ON Recensione
FOR EACH ROW
BEGIN
	DECLARE _ProdottoFinito VARCHAR(50);
    DECLARE _Ricetta VARCHAR(50);
    
    IF((new.Reso='Si') OR (new.GradimentoGenerale<=2) OR (new.Conservazione='Scadente') OR (new.Gusto='Scadente') OR (new.QualitaPercepita='Pessima'))
    THEN 
		SET _ProdottoFinito = new.FK_CodiceProdotto_R;
		SET _Ricetta = (SELECT FK_NomeRicetta_P
							   FROM ProdottoFinito
							   WHERE CodiceProdotto=new.FK_CodiceProdotto_R);
		CALL Rilevato_Problema(_ProdottoFinito, _Ricetta);
	END IF;
END$$


-- Procedura che accede a Fase e Compara ad ogni fase ideale quella effettiva relativa al codice del prodotto arrivato in entrata --
DROP PROCEDURE IF EXISTS Rilevato_Problema$$
CREATE PROCEDURE Rilevato_Problema (IN _ProdottoFinito_1 VARCHAR(50), IN _Ricetta_1 VARCHAR (50))
BEGIN
	DECLARE finito INT DEFAULT 0;
	DECLARE _codiceFaseProdotto VARCHAR(50);
    DECLARE _NumFase INT;
    DECLARE _MinutiFaseProdotto INT;
    DECLARE _MinutiRiposoProdotto INT;
    DECLARE _SalaturaGrammiProdotto FLOAT;
    DECLARE _TemperaturaLatteProdotto FLOAT;
	DECLARE _GiorniStagionatura INT;
    DECLARE _GiorniEffettiviStagionatura INT;

	-- dichiarazione cursore per selezionare ogni CodiceFase relativo al prodotto incriminato
	DECLARE cerca CURSOR FOR
	SELECT f.CodiceFase,f.NumFase
	FROM Fase f
    WHERE FK_CodiceProdotto_F=_ProdottoFinito_1
    ORDER BY NumFase;
	-- dichiarazione handler per avvertire quando finisce la tabella
	DECLARE CONTINUE HANDLER FOR NOT FOUND 
		SET finito = 1;
	-- apertura del cursore
	OPEN cerca;

	-- seleziona il codice animale da animale e la inserisce in _codiceAnimale

	label: LOOP

	-- prelevamento e controllo dei dati
	FETCH cerca INTO _codiceFaseProdotto,_NumFase;

	IF finito = 1 THEN
		LEAVE label;
	END IF;
	
    SET _MinutiFaseProdotto =(SELECT MinutiFase
							  FROM Fase
                              WHERE CodiceFase = _codiceFaseProdotto);
	
    SET _MinutiRiposoProdotto=(SELECT MinutiRiposo
							   FROM Fase
                               WHERE CodiceFase = _codiceFaseProdotto);
	
	SET _SalaturaGrammiProdotto=(SELECT SalaturaGrammi
								 FROM Fase
								 WHERE CodiceFase = _codiceFaseProdotto);
								
	SET _TemperaturaLatteProdotto=(SELECT TemperaturaLatte
								   FROM Fase
								   WHERE CodiceFase = _codiceFaseProdotto);
                                   
	CALL ControlloFase ( _Ricetta_1,_NumFase, _MinutiFaseProdotto, _MinutiRiposoProdotto,_SalaturaGrammiProdotto,_TemperaturaLatteProdotto, _codiceFaseProdotto);
    
	END LOOP;

	CLOSE cerca;
    
        
	SET _GiorniStagionatura = (SELECT GiorniStagionatura
							   FROM Ricetta 
							   WHERE NomeRicetta = _Ricetta_1);
    IF (_GiorniStagionatura>0)
    THEN
		SET _GiorniEffettiviStagionatura = ABS(DATEDIFF((SELECT DataProduzione
														 FROM Lotto
                                                         WHERE CodiceLotto = (SELECT FK_CodiceLotto_P
																			  FROM ProdottoFinito
																			  WHERE CodiceProdotto= _ProdottoFinito_1)),(SELECT DataFineStagionatura
																														 FROM ProdottoFinito
                                                                                                                         WHERE CodiceProdotto = _ProdottoFinito_1)));
		IF ((_GiorniEffettiviStagionatura IS NOT NULL) AND (_GiorniEffettiviStagionatura<>_GiorniStagionatura))
			THEN
			INSERT INTO Errori_Produzione VALUES
             (_ProdottoFinito_1,'Tempo di stagionatura scorretto', _GiorniStagionatura, _GiorniEffettiviStagionatura, CURRENT_TIMESTAMP());
        END IF;
    END IF;

END$$

DROP PROCEDURE IF EXISTS ControlloFase$$
CREATE PROCEDURE ControlloFase (IN _Ricetta_1 VARCHAR(50),IN _NumFase INT,IN _MinutiFaseProdotto INT,IN _MinutiRiposoProdotto INT,IN _SalaturaGrammiProdotto FLOAT,IN _TemperaturaLatteProdotto FLOAT,IN _codiceFaseProdotto_1 VARCHAR(50))
BEGIN
        DECLARE _MinutiFaseRicetta INT;
        DECLARE _MinutiRiposoRicetta INT;
        DECLARE _SalaturaGrammiRicetta FLOAT;
        DECLARE _TemperaturaLatteRicetta FLOAT;
        
		SET _MinutiFaseRicetta =(SELECT MinutiFase
							     FROM Fase
								 WHERE FK_NomeRicetta_F = _Ricetta_1
								 AND NumFase = _NumFase);
	
		SET _MinutiRiposoRicetta=(SELECT MinutiRiposo
							      FROM Fase
								  WHERE FK_NomeRicetta_F = _Ricetta_1
								  AND NumFase = _NumFase);
	
		SET _SalaturaGrammiRicetta=(SELECT SalaturaGrammi
								   FROM Fase
								   WHERE FK_NomeRicetta_F = _Ricetta_1
                                   AND NumFase = _NumFase);
								
		SET _TemperaturaLatteRicetta=(SELECT TemperaturaLatte
								      FROM Fase
								      WHERE FK_NomeRicetta_F = _Ricetta_1
                                      AND NumFase = _NumFase);
                                      
		IF ((ABS(_SalaturaGrammiRicetta-_SalaturaGrammiProdotto))>10)
        THEN 
			INSERT INTO Errori_Produzione VALUES
            (_codiceFaseProdotto_1, 'Parametro Salatura',_SalaturaGrammiRicetta,_SalaturaGrammiProdotto,CURRENT_TIMESTAMP());
        END IF;           
        
		IF ((ABS(_TemperaturaLatteRicetta-_TemperaturaLatteProdotto))>10)
        THEN 
			INSERT INTO Errori_Produzione VALUES
            (_codiceFaseProdotto_1,'Parametro Temperatura Latte', _TemperaturaLatteRicetta,_TemperaturaLatteProdotto,CURRENT_TIMESTAMP());
        END IF;
		
		IF ((ABS(_MinutiRiposoRicetta-_MinutiRiposoProdotto))>5)
        THEN 
			INSERT INTO Errori_Produzione VALUES
            (_codiceFaseProdotto_1,'Parametro Minuti Riposo',_MinutiRiposoRicetta,_MinutiRiposoProdotto, CURRENT_TIMESTAMP());
        END IF;                              
		
		IF ((ABS(_MinutiFaseRicetta-_MinutiFaseProdotto))>5)
        THEN 
			INSERT INTO Errori_Produzione VALUES
            (_codiceFaseProdotto_1,'Parametro Minuti Fase', _MinutiFaseRicetta,_MinutiFaseProdotto, CURRENT_TIMESTAMP());
        END IF;          
END$$

-- -------------------------------------------------- 
-- ANALYTICS 4: Analisi delle vendite
-- --------------------------------------------------

DROP PROCEDURE IF EXISTS promozioni_prodotti$$
CREATE PROCEDURE promozioni_prodotti()
BEGIN
	DECLARE _prodottomigliore VARCHAR(30);
    DECLARE _totProdottiVenduti INT;

	DROP TABLE IF EXISTS _prodotti;
	CREATE TABLE _prodotti(
	NomeProdotto VARCHAR(30) NOT NULL, 
	PrezzoOriginaleProdotto FLOAT, 
	Quantita INT, 
	ProdottoAssociato VARCHAR(30), 
	PrezzoProdottoAssociato FLOAT, 
	ScontoProdotto INT DEFAULT 0, 
	PrezzoPromozione FLOAT, 
	PRIMARY KEY(NomeProdotto)
	);

	INSERT INTO _prodotti (NomeProdotto, Quantita, PrezzoOriginaleProdotto)
	SELECT * 
	FROM(SELECT P.Nome, SUM(A.Quantita), P.Prezzo
		FROM (Acquisto A RIGHT OUTER JOIN ProdottoAcquistabile P ON A.FK_Nome_A = P.Nome LEFT OUTER JOIN Ordine O ON A.FK_CodiceOrdine_A = O.CodiceOrdine) 
        WHERE O.DataOrdine + INTERVAL 30 DAY >= current_date()
		GROUP BY P.Nome) AS p; 
			
	UPDATE _prodotti
	SET Quantita = 0
	WHERE Quantita is null;


	SET _totProdottiVenduti = (SELECT SUM(Quantita)
								FROM _prodotti
								);

	SET _prodottomigliore = (SELECT NomeProdotto
							FROM _prodotti
							WHERE Quantita = (SELECT MAX(Quantita)
												FROM _prodotti
											) 
								AND PrezzoOriginaleProdotto = (SELECT MAX(PrezzoOriginaleProdotto)
														FROM _prodotti
														WHERE Quantita = (SELECT MAX(Quantita)
																			FROM _prodotti
																		 )
																)
							);
																							
	UPDATE _prodotti
	SET ProdottoAssociato = _prodottomigliore, ScontoProdotto = 50
	WHERE Quantita <= 4/100 * _totProdottiVenduti;

	UPDATE _prodotti
	SET ScontoProdotto = 40, PrezzoPromozione = PrezzoOriginaleProdotto - PrezzoOriginaleProdotto*40/100
	WHERE Quantita > 4/100 * _totProdottiVenduti AND Quantita <= 10/100 * _totProdottiVenduti;  

	UPDATE _prodotti
	SET PrezzoProdottoAssociato = (SELECT Prezzo
									FROM ProdottoAcquistabile 
									WHERE Nome = ProdottoAssociato
									);
	UPDATE _prodotti
	SET PrezzoPromozione = (PrezzoOriginaleProdotto - PrezzoOriginaleProdotto*(ScontoProdotto/100) + PrezzoProdottoAssociato)
	WHERE Quantita <= 4/100 * _totProdottiVenduti;
                                
END $$

DROP EVENT IF EXISTS analisiVendite$$
CREATE EVENT analisiVendite
ON SCHEDULE EVERY 1 MONTH
STARTS '2020-02-28 10:30:00'
DO
BEGIN 
	CALL promozioni_prodotti();

END $$