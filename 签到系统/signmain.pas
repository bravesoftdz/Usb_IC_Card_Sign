unit signmain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, superobject, StrUtils, ExtCtrls, Rc4_Unit, InputBox,
  jpeg, IDHttp;

type
  TForm1 = class(TForm)
    Panel2: TPanel;
    sign_card_label: TLabel;
    sign_card: TEdit;
    sign_name_label: TLabel;
    sign_name: TEdit;
    sign_job: TEdit;
    sign_job_label: TLabel;
    sign_phone: TEdit;
    sign_phone_label: TLabel;
    sign_store_label: TLabel;
    sign_store: TEdit;
    sign_company_label: TLabel;
    sign_company: TEdit;
    sign_store_address_label: TLabel;
    sign_store_address: TEdit;
    Image1: TImage;
    error: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  TMyThread = class(TThread)
  private
     { Private declarations }
  protected
    procedure Execute; override; {执行}
    procedure Run; {声明多一个过程，把功能代码写在这里再给Execute调用}
  end;

var
  Form1: TForm1; icdev: longint; st, sector, block, loadmode: smallint; snr: longint; nkey, wdata, sendblock: pchar;
  status: array[0..18] of Char;
  databuff: array[0..15] of Char;
  red_buff: array[0..17] of Char;
  ack: array[0..255] of Char;
  HttpClient: TIdHttp; ParamList: TStringList;
  equipment: string;
  {a example for your to try using .dll. add_s return i+1}
function add_s(i: smallint): smallint; stdcall;
far; external 'mwrf32.dll' name 'add_s';
  {comm function.}
function rf_init(port: smallint; baud: longint): longint; stdcall;
far; external 'mwrf32.dll' name 'rf_init';
function rf_exit(icdev: longint): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_exit';
function rf_encrypt(key: pchar; ptrsource: pchar; msglen: smallint; ptrdest: pchar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_encrypt';
function rf_decrypt(key: pchar; ptrsource: pchar; msglen: smallint; ptrdest: pchar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_decrypt';
  //
function rf_card(icdev: longint; mode: smallint; snr: pChar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_card';
function rf_load_key(icdev: longint; mode, secnr: smallint; nkey: pchar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_load_key';
function rf_load_key_hex(icdev: longint; mode, secnr: smallint; nkey: pchar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_load_key_hex';
function rf_authentication(icdev: longint; mode, secnr: smallint): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_authentication';
  //
function rf_read(icdev: longint; adr: smallint; data: pchar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_read';
function rf_read_hex(icdev: longint; adr: smallint; data: pchar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_read_hex';
function rf_write(icdev: longint; adr: smallint; data: pchar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_write';
function rf_write_hex(icdev: longint; adr: smallint; data: pchar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_write_hex';
function rf_halt(icdev: longint): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_halt';
function rf_reset(icdev: longint; msec: smallint): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_reset';
  //M1 CARD
function rf_initval(icdev: longint; adr: smallint; value: longint): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_initval';
function rf_readval(icdev: longint; adr: smallint; value: pchar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_readval';
function rf_increment(icdev: longint; adr: smallint; value: longint): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_increment';
function rf_decrement(icdev: longint; adr: smallint; value: longint): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_decrement';
function rf_restore(icdev: longint; adr: smallint): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_restore';
function rf_transfer(icdev: longint; adr: smallint): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_transfer';
function rf_check_write(icdev, snr: longint; adr, authmode: smallint; data: pchar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_check_write';
function rf_check_writehex(icdev, snr: longint; adr, authmode: smallint; data: pchar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_check_writehex';

    //M1 CARD HIGH FUNCTION
function rf_HL_initval(icdev: longint; mode: smallint; secnr: smallint; value: longint; snr: pchar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_HL_initval';
function rf_HL_increment(icdev: longint; mode: smallint; secnr: smallint; value, snr: longint; svalue, ssnr: pchar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_HL_increment';
function rf_HL_decrement(icdev: longint; mode: smallint; secnr: smallint; value: longint; snr: longint; svalue, ssnr: pchar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_HL_decrement';
function rf_HL_write(icdev: longint; mode, adr: smallint; ssnr, sdata: pchar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_HL_write';
function rf_HL_read(icdev: longint; mode, adr: smallint; snr: longint; sdata, ssnr: pchar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_HL_read';
function rf_changeb3(Adr: pchar; keyA: pchar; B0: pchar; B1: pchar; B2: pchar; B3: pchar; Bk: pchar; KeyB: pchar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_changeb3';
  //DEVICE
function rf_get_status(icdev: longint; status: pchar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_get_status';
function rf_beep(icdev: longint; time: smallint): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_beep';
function rf_ctl_mode(icdev: longint; ctlmode: smallint): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_ctl_mode';
function rf_disp_mode(icdev: longint; mode: smallint): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_disp_mode';
function rf_disp8(icdev: longint; len: longint; disp: pchar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_disp8';
function rf_disp(icdev: longint; pt_mode: smallint; disp: longint): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_disp';
function rf_srd_snr(icdev: longint; length: smallint; data: pchar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_srd_snr';
  //
function rf_settimehex(icdev: longint; dis_time: pchar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_settimehex';
function rf_gettimehex(icdev: longint; dis_time: pchar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_gettimehex';
function rf_swr_eeprom(icdev: longint; offset, len: smallint; data: pchar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_swr_eeprom';
function rf_srd_eeprom(icdev: longint; offset, len: smallint; data: pchar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_srd_eeprom';
  //ML CARD
function rf_authentication_2(icdev: longint; mode, keyNum, secnr: smallint): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_authentication_2';
function rf_initval_ml(icdev: longint; value: longint): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_initval_ml';
function rf_readval_ml(icdev: longint; rvalue: pchar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_readval_ml';
function rf_decrement_transfer(icdev: longint; adr: smallint; value: longint): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_decrement_transfer';
function rf_sam_rst(icdev: longint; baud: smallint; samack: pChar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_sam_rst';
function rf_sam_trn(icdev: longint; samblock, recv: pChar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_sam_trn';
function rf_sam_off(icdev: longint): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_sam_off';
function rf_cpu_rst(icdev: longint; baud: smallint; cpuack: pChar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_cpu_rst';
function rf_cpu_trn(icdev: longint; cpublock, recv: pChar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_cpu_trn';
function rf_pro_rst(icdev: longint; _Data: pChar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_pro_rst';
function rf_pro_trn(icdev: longint; problock, recv: pChar): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_pro_trn';
function rf_pro_halt(icdev: longint): smallint; stdcall;
far; external 'mwrf32.dll' name 'rf_pro_halt';
function hex_a(hex, a: pChar; length: smallint): smallint; stdcall;
far; external 'mwrf32.dll' name 'hex_a';
function a_hex(a, hex: pChar; length: smallint): smallint; stdcall;
far; external 'mwrf32.dll' name 'a_hex';
implementation

{$R *.dfm}

var MyThread: TMyThread;

procedure TMyThread.Execute;
begin
  { Place thread code here }
  FreeOnTerminate := True; {加上这句线程用完了会自动注释}
  Run;
end;

procedure TMyThread.Run;
var
  vJson, vItem: ISuperObject; str, msg: string;
  imagestream: TMemoryStream;
  jpg: TJpegImage;
begin
  while true do
  try
    Sleep(100);
    st := rf_card(icdev, 1, @snr);
    st := rf_authentication(icdev, loadmode, sector);
    if st = 0 then
    begin
      Form1.error.Caption := '数据传输中...';
      try
        st := rf_read(icdev, block, @databuff);
        HttpClient := TIdHTTP.Create(nil);
        ParamList := TStringList.Create;
        ParamList.Add('item_no=2');
        ParamList.Add('sign_card=' + databuff);
        ParamList.Add('sign_equipment=' + equipment);
        ParamList.Add('sign_equipment_id=' + red_buff);
        str := Utf8ToAnsi(HttpClient.Post('http://web.amyun.cn/api/sign/card', ParamList));
        vJson := SO(str);
        if StrToInt(vJson['code'].AsString) = 1 then
        begin
          vItem := vJson['datas'];
          Form1.sign_card.Text := databuff;
          Form1.sign_card.Text := vItem['sign_card'].AsString;
          Form1.sign_name.Text := vItem['sign_name'].AsString;
          Form1.sign_job.Text := vItem['sign_job'].AsString;
          Form1.sign_phone.Text := vItem['sign_phone'].AsString;
          Form1.sign_store.Text := vItem['sign_store'].AsString;
          Form1.sign_company.Text := vItem['sign_company'].AsString;
          Form1.sign_store_address.Text := vItem['sign_store_address'].AsString;
          try
            imagestream := TMemoryStream.Create();
            jpg := TJpegImage.Create; //vItem['headimgurl'].AsString
            HttpClient.Get('http://web.amyun.cn/static/images/pass/' + AnsiToUtf8(vItem['sign_name'].AsString) + '.jpg', imagestream);
            imagestream.Position := 0;
            jpg.LoadFromStream(imagestream);
            Form1.Image1.Picture.Assign(jpg);
          except
            Form1.Image1.Picture.Assign(nil);
          end;
          st := rf_beep(icdev, 10);
          Form1.error.Caption := '签卡成功！';
          Sleep(1000);
          Form1.error.Caption := '';
        end;
        if vJson['code'].AsString = '0' then
        begin
          case StrToInt(vJson['msg'].AsString) of
            0: msg := '服务器繁忙！';
            210: msg := '签到未开启或已结束！';
            211: msg := '已经消费过了！';
            213: msg := '机器卡无效！';
          else msg := '系统异常错误！error:' + vJson['msg'].AsString;
          end;
          if vJson['msg'].AsString = '211' then
          begin
            vItem := vJson['datas'];
            Form1.sign_card.Text := databuff;
            Form1.sign_card.Text := vItem['sign_no'].AsString;
            Form1.sign_name.Text := vItem['sign_name'].AsString;
            Form1.sign_job.Text := vItem['sign_job'].AsString;
            Form1.sign_phone.Text := vItem['sign_phone'].AsString;
            Form1.sign_store.Text := vItem['sign_store'].AsString;
            Form1.sign_company.Text := vItem['sign_company'].AsString;
            Form1.sign_store_address.Text := vItem['sign_store_address'].AsString;
            try
              imagestream := TMemoryStream.Create();
              jpg := TJpegImage.Create; //vItem['headimgurl'].AsString
              HttpClient.Get('http://web.amyun.cn/static/images/pass/' + AnsiToUtf8(vItem['sign_name'].AsString) + '.jpg', imagestream);
              imagestream.Position := 0;
              jpg.LoadFromStream(imagestream);
              Form1.Image1.Picture.Assign(jpg);
            except
              Form1.Image1.Picture.Assign(nil);
            end;
            st := rf_beep(icdev, 10);
          end;
          Form1.error.Caption := msg;
          Sleep(1000);
          Form1.error.Caption := '';
        end;
      except
        Form1.error.Caption := '网络超时或者系统错误，请检查网络！';
        Sleep(1000);
        Form1.error.Caption := '';
      end;
    end;
  except
    Form1.error.Caption := '艾美e族签到设备异常，请重新连接！';
    Sleep(1000);
    Form1.error.Caption := '';
  end;
end;

(*
 * 启动初始化
 *
 * @date  2016/12/14
 * @author cnbbx
 * @param TObject Sender
 * @version 1.0
 * @return string
 *)

procedure TForm1.FormCreate(Sender: TObject);
begin
  icdev := rf_init(0, 115200);
  snr := 0;
  sector := 1;
  block := 4;
  loadmode := 0;
  nkey := '00049BE2CD22';
  st := rf_load_key_hex(icdev, loadmode, sector, nkey);
  st := rf_srd_snr(icdev, 16, @red_buff);
  if st <> 0 then
  begin
    ShowMessage('找不到艾美e族签到设备！');
    ExitProcess(0); Application.Terminate;
  end;
  equipment := InputBoxEx('艾美e族实体会员卡签到系统', '签到机器编码：　　', '1');
  MyThread := TMyThread.Create(False);
end;

end.

