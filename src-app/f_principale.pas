unit f_principale;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.TabControl,
  System.ImageList,
  FMX.ImgList,
  FMX.StdCtrls,
  FMX.Controls.Presentation,
  FMX.Layouts,
  System.Sensors,
  System.Sensors.Components,
  System.Net.URLClient,
  System.Net.HttpClient,
  System.Net.HttpClientComponent;

type
  TForm1 = class(TForm)
    TabControl1: TTabControl;
    tabMain: TTabItem;
    tabAPropos: TTabItem;
    ImageList1: TImageList;
    btnBack: TButton;
    btnAPropos: TButton;
    lblTitre: TLabel;
    btnDemandeFeuRouge: TButton;
    StyleBook1: TStyleBook;
    ScrollBox1: TScrollBox;
    ScrollBox2: TScrollBox;
    LocationSensor1: TLocationSensor;
    lblMessage: TLabel;
    Glyph1: TGlyph;
    lblAProposWtctsURL: TLabel;
    lblAProposEditeur: TLabel;
    lblAProposEditeurURL: TLabel;
    lblAProposDeveloppeur: TLabel;
    lblAProposGraphiste: TLabel;
    lblAProposBlaBla: TLabel;
    lblAProposCopyright: TLabel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnAProposClick(Sender: TObject);
    procedure btnDemandeFeuRougeClick(Sender: TObject);
    procedure LocationSensor1LocationChanged(Sender: TObject;
      const OldLocation, NewLocation: TLocationCoord2D);
    procedure lblAProposEditeurURLClick(Sender: TObject);
    procedure LocationSensor1SensorChoosing(Sender: TObject;
      const Sensors: TSensorArray; var ChoseSensorIndex: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    { Déclarations privées }
    procedure affiche_message(texte: string);
    procedure BoutonAppuye;
    procedure BoutonNonAppuye;
    procedure SendGPSToWebServer(Latitude, Longitude: Double);
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  System.Permissions,
  FMX.DialogService,
  u_md5,
  u_urlOpen;

{$IFDEF RELEASE}
{$I '..\_PRIVATE\Web_API_Hash_Prod.inc.pas'}
{$ELSE}
{$I 'Web_API_Hash_Dev.inc.pas'}
{$ENDIF}

procedure TForm1.affiche_message(texte: string);
begin
  tthread.Synchronize(nil,
    procedure
    begin
      lblMessage.Text := texte;
      Timer1.enabled := not texte.IsEmpty;
    end);
end;

procedure TForm1.BoutonAppuye;
begin
  btnDemandeFeuRouge.ImageIndex := 3;
  btnDemandeFeuRouge.enabled := false;
end;

procedure TForm1.BoutonNonAppuye;
begin
  btnDemandeFeuRouge.ImageIndex := 2;
  btnDemandeFeuRouge.enabled := true;
end;

procedure TForm1.btnAProposClick(Sender: TObject);
begin
  btnAPropos.Visible := false;
  TabControl1.SetActiveTabWithTransition(tabAPropos, TTabTransition.Slide,
    TTabTransitionDirection.Normal);
  btnBack.Visible := true;
end;

procedure TForm1.btnBackClick(Sender: TObject);
begin
  btnBack.Visible := false;
  TabControl1.SetActiveTabWithTransition(tabMain, TTabTransition.Slide,
    TTabTransitionDirection.Reversed);
  btnAPropos.Visible := true;
end;

procedure TForm1.btnDemandeFeuRougeClick(Sender: TObject);
begin
  BoutonAppuye;

  PermissionsService.RequestPermissions
    (['android.permission.ACCESS_FINE_LOCATION'],
    procedure(const APermissions: TClassicStringDynArray;
      const AGrantResults: TClassicPermissionStatusDynArray)
    begin
      if (Length(AGrantResults) = 1) and
        (AGrantResults[0] = TPermissionStatus.Granted) then
      begin
        LocationSensor1.Active := true;
        affiche_message('Recherche de votre position.');
      end
      else
      begin
        BoutonNonAppuye;
        TDialogService.ShowMessage('Location permission not granted');
      end;
    end);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  // initialisation générale
  TabControl1.ActiveTab := tabMain;
  btnBack.Visible := false;
  btnAPropos.Visible := true;
  // initialisation écran accueil
  affiche_message('');
  BoutonNonAppuye;
  // initialisation écran A Propos
  lblAProposWtctsURL.Text := 'https://wtcts.olfsoftware.fr';
  lblAProposEditeur.Text := 'Cette application vous est proposée par :' +
    sLineBreak + 'Olf Software';
  lblAProposEditeurURL.Text := 'https://olfsoftware.fr';
  lblAProposDeveloppeur.Text := 'Développement :' + sLineBreak +
    'Patrick Prémartin';
  lblAProposGraphiste.Text := 'Graphismes :' + sLineBreak + 'thesquid.ink' +
    sLineBreak + 'Kolopach / fotolia.com';
  lblAProposBlaBla.Text :=
    'WtCtS n''est destiné qu''à un usage piéton. Quand vous conduisez, laissez votre téléphone coupé !'
    + sLineBreak + sLineBreak +
    'Faites attention aux pickpockets et voleurs à la tire. Ce serait dommage de vous faire voler '
    + 'ce smartphone juste pour traverser la route plus vite, non ?' +
    sLineBreak + sLineBreak +
    'Cette application ne fonctionne qu''avec des feux rouges compatibles. Privilégiez toujours le '
    + 'bouton d''appel présent sur le feu rouge s''il existe.' + sLineBreak +
    sLineBreak +
    'Pour votre sécurité, ne traversez que lorsque c''est à vous de traverser et vérifiez toujours '
    + 'que les véhicules sont bien à l''arrêt ou ont l''intention de vous laisser passer.'
    + sLineBreak + sLineBreak +
    'Cette application nous transmet vos coordonnées GPS. Nous ne récupérons que les informations de '
    + 'latitude et longitude. Nous ne stockons aucune donnée personnelle et ne faisons pas de suivi de '
    + 'vos mouvements. Avec nous votre vie privée reste votre vie privée !';
  lblAProposCopyright.Text := '(c) 2016 Olf Software';
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
Shift: TShiftState);
begin
  if (Key = vkHardwareBack) then
  begin // touche Android "back"
    if (btnBack.Visible) then
      btnBackClick(Sender);
    Key := 0;
    KeyChar := #0;
  end
  else if (Key = vkMenu) then
  begin // touche Android "menu"
  end;
end;

procedure TForm1.lblAProposEditeurURLClick(Sender: TObject);
begin
  url_Open_In_Browser(TLabel(Sender).Text);
end;

procedure TForm1.LocationSensor1LocationChanged(Sender: TObject;
const OldLocation, NewLocation: TLocationCoord2D);
begin
  affiche_message('Position géographique calculée.');
  tthread.Synchronize(nil,
    procedure
    begin
      LocationSensor1.Active := false;
      SendGPSToWebServer(NewLocation.Latitude, NewLocation.Longitude);
    end);
end;

procedure TForm1.LocationSensor1SensorChoosing(Sender: TObject;
const Sensors: TSensorArray; var ChoseSensorIndex: Integer);
begin
  if (Length(Sensors) < 1) then
  begin
    affiche_message('GPS indisponible.');
    tthread.Synchronize(nil,
      procedure
      begin
        BoutonNonAppuye;
      end);
  end;
end;

procedure TForm1.SendGPSToWebServer(Latitude, Longitude: Double);
begin
  tthread.CreateAnonymousThread(
    procedure
    var
      Server: THTTPClient;
      HTTPResponse: IHTTPResponse;
    begin
      Server := THTTPClient.Create;
      try
        try
          HTTPResponse :=
            Server.Get
            ('https://api.wtcts.olfsoftware.fr/appel-201607.php?latitude=' +
            Latitude.ToString + '&longitude=' + Longitude.ToString + '&verif=' +
            md5(Latitude.ToString + Longitude.ToString + CWebAPIHash));
        except

        end;
        if assigned(HTTPResponse) and (HTTPResponse.StatusCode = 200) and
          (HTTPResponse.ContentAsString(tencoding.UTF8) = 'OK') then
          affiche_message('Demande transmise.' + sLineBreak +
            'Attendez votre tour pour traverser.')
        else
          affiche_message
            ('Erreur d''appel du serveur. Attendez votre tour pour traverser.');
      finally
        Server.Free;
        tthread.ForceQueue(nil,
          procedure
          begin
            BoutonNonAppuye;
          end);
      end;
    end).Start;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  affiche_message('');
end;

end.
