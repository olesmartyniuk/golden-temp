unit uStudentsAddGroupForm;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Menus,
  ImgList,
  StdCtrls,
  ComCtrls,
  ExtCtrls,
  Generics.Collections,
  uInterfaces,
  uRemotable,
  uMainUnit;

type
  TFormAddStudent = class(TForm)
    PanelMain: TPanel;
    ListView: TListView;
    ImageList: TImageList;
    PanelInfo: TPanel;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    PanelBottom: TPanel;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    ButtonNewStudent: TButton;
    procedure FormShow(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure ListViewSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure ListViewDblClick(Sender: TObject);
    procedure ButtonNewStudentClick(Sender: TObject);
    private
      procedure PrintStudentsList;
    public
      Host, Login, Password: WideString;
      StudentsList: TList<TStudent>;
      Group: WideString;
      Groups: TList<TGroup>;
  end;

implementation

uses
  uFactories,
  uStudentForm,
  uUtils;

{$R *.DFM}

procedure TFormAddStudent.ButtonNewStudentClick(Sender: TObject);
var
  form: TStudentForm;
  i: Integer;
  student: TStudent;
begin
  form := TStudentForm.Create(Self);
  try
    form.Host := Host;
    form.Login := Login;
    form.Password := Password;
    for i := 0 to Groups.Count - 1 do
      form.Groups.Add(Groups.Items[i].name);
    form.ComboBoxGroups.Enabled := False;
    student := TStudent.Create;
    if form.ShowModal = mrOk then
    begin
      StudentsList.Add(student);
      PrintStudentsList;
    end;
  finally
    form.Free;
  end;
end;

procedure TFormAddStudent.ButtonOKClick(Sender: TObject);
var
  i: Integer;
  student: TStudent;
  splash: ISplash;
begin
  if not Assigned(ListView.Selected) then
  begin
    ModalResult := mrNone;
    Exit;
  end;
  splash := Dialog.NewSplash(Self);
  splash.ShowSplash('Додавання студентів до групи...');
  try
    try
      for i := 0 to ListView.Items.Count - 1 do
      begin
        if not ListView.Items[i].Selected then
          Continue;
        student := StudentsList.Items[Integer(ListView.Items[i].Data)];
        student.Group.Name := Group;
        Remotable.Administrator.StudentEdit(AdministratorMainForm.Account, student);
        ModalResult := mrOk;
      end;
    except
      on E: ERemotableError do
      begin
        ModalResult := mrCancel;
        ShowWarningMessage(E.Message);
      end;
    end;
  finally
    splash.HideSplash;
  end;
end;

procedure TFormAddStudent.ListViewDblClick(Sender: TObject);
begin
  ButtonOKClick(Sender);
end;

procedure TFormAddStudent.ListViewSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  ButtonOK.Enabled := Assigned(ListView.Selected);
end;

procedure TFormAddStudent.N1Click(Sender: TObject);
begin
  ListView.SelectAll;
end;

procedure TFormAddStudent.PrintStudentsList;
var
  i: Integer;
  student: TStudent;
begin
  ListView.Clear;
  if not Assigned(StudentsList) then
    Exit;
  for i := 0 to StudentsList.Count - 1 do
  begin
    student := StudentsList.Items[i];
    if student.Group.Name = '' then
      with ListView.Items.Add do
      begin
        ImageIndex := 0;
        Data := Pointer(i);
        Caption := student.Surname + ' ' + student.Name;
        SubItems.Add(student.Login);
      end;
  end;
  if ListView.Items.Count = 0 then
  begin
    PanelInfo.Caption := 'Не знайдено студентів, що не входять у групи';
    ListView.Enabled := False;
  end
  else
  begin
    PanelInfo.Caption := 'Для групового виділення використовуйте затиснуті клавіші Ctrl або Shift';
    ListView.Enabled := True;
  end;
end;

procedure TFormAddStudent.FormShow(Sender: TObject);
begin
  Caption := 'Додати до групи ' + Group;
  PrintStudentsList;
end;

end.
