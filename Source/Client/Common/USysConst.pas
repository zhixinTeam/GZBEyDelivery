{*******************************************************************************
  ����: dmzn@ylsoft.com 2007-10-09
  ����: ��Ŀͨ�ó�,�������嵥Ԫ
*******************************************************************************}
unit USysConst;

interface

uses
  SysUtils, Classes, ComCtrls;

const
  cSBar_Date            = 0;                         //�����������
  cSBar_Time            = 1;                         //ʱ���������
  cSBar_User            = 2;                         //�û��������
  cRecMenuMax           = 5;                         //���ʹ�õ����������Ŀ��

  cPercent              = 100;                       //�ٷֱ�
  cThousand             = 1000;                      //ǧ�ֱ�

const
  {*Frame ID*}
  cFI_FrameSysLog       = $0001;                     //ϵͳ��־
  cFI_FrameViewLog      = $0002;                     //������־
  cFI_FrameAuthorize    = $0003;                     //��ȫ��Ȩ

  cFI_FrameProvider     = $0010;                     //��Ӧ
  cFI_FrameProvideLog   = $0011;                     //��Ӧ��־
  cFI_FrameMaterails    = $0012;                     //ԭ����

  cFI_FrameViewBill     = $0020;                     //�������
  cFI_FrameMakeCard     = $0021;                     //���������
  cFI_FrameTrucks       = $0022;                     //��������

  cFI_FrameBillPick     = $0050;                     //���������
  cFI_FrameBillPost     = $0051;                     //���������(ȷ��)
  cFI_FrameBillTiaoZ    = $0052;                     //���������

  cFI_FramePoundQuery   = $0060;                     //���ز�ѯ
  cFI_FramePoundManual  = $0061;                     //�ֶ�����
  cFI_FrameDispatchQuery= $0062;                     //�������Ȳ�ѯ
  cFI_FrameTruckQuery   = $0063;                     //���복����ѯ
  cFI_FrameZTDispatch   = $0064;                     //ջ̨�Ŷӳ�������
  cFI_FrameSaleDetailQuery =$0065;                   //������ѯ
                                                          
  {*From ID*}
  cFI_FormMemo          = $1000;                     //��ע����
  cFI_FormBackup        = $1001;                     //���ݱ���
  cFI_FormRestore       = $1002;                     //���ݻָ�
  cFI_FormIncInfo       = $1003;                     //��˾��Ϣ
  cFI_FormChangePwd     = $1005;                     //�޸�����

  cFI_FormOptions       = $1006;                     //�����趨
  cFI_FormAuthorize     = $1007;                     //��ȫ��Ȩ
  cFI_FormTruckIn       = $1008;                     //��������
  cFI_FormTruckOut      = $1009;                     //��������
  cFI_FormZTLine        = $1010;                     //װ���߹���
  cFI_FormGetTruck      = $1011;                     //ѡ���ƺ�
  cFI_FormLadDai        = $1012;                     //��������
  cFI_FormLadSan        = $1013;                     //��������
  cFI_FormNewBill       = $1014;                     //��������
  cFI_FormNewXSBill     = $1015;                     //��ȡ���۶���
  cFI_FormMakeCard      = $1016;                     //�����ſ�
  cFI_FormBillTiaoz     = $1017;                     //����������
  cFI_FrameQSapLog      = $1018;                     //�ӿڴ�������

  cFI_FormTrucks        = $1030;                     //��������
  cFI_FormMakeRFIDCard  = $1031;                     //��ȡ����

  cFI_FormChangeTunnel  = $1040;                     //ѡ��ͨ��

  cFI_FormProvider      = $1051;                     //��Ӧ��
  cFI_FormMaterails     = $1052;                     //ԭ����

  {*Command*}
  cCmd_RefreshData      = $0002;                     //ˢ������
  cCmd_ViewSysLog       = $0003;                     //ϵͳ��־

  cCmd_ModalResult      = $1001;                     //Modal����
  cCmd_FormClose        = $1002;                     //�رմ���
  cCmd_AddData          = $1003;                     //�������
  cCmd_EditData         = $1005;                     //�޸�����
  cCmd_ViewData         = $1006;                     //�鿴����

type
  TSysParam = record
    FProgID     : string;                            //�����ʶ
    FAppTitle   : string;                            //�����������ʾ
    FMainTitle  : string;                            //���������
    FHintText   : string;                            //��ʾ�ı�
    FCopyRight  : string;                            //��������ʾ����
    FSysLangID  : string;                            //ϵͳ���Ա�ʶ

    FUserID     : string;                            //�û���ʶ
    FUserName   : string;                            //��ǰ�û�
    FUserPwd    : string;                            //�û�����
    FGroupID    : string;                            //������
    FIsAdmin    : Boolean;                           //�Ƿ����Ա
    FIsNormal   : Boolean;                           //�ʻ��Ƿ�����

    FRecMenuMax : integer;                           //����������
    FIconFile   : string;                            //ͼ�������ļ�
    FUsesBackDB : Boolean;                           //ʹ�ñ��ݿ�

    FLocalIP    : string;                            //����IP
    FLocalMAC   : string;                            //����MAC
    FLocalName  : string;                            //��������
    FHardMonURL : string;                            //Ӳ���ػ�
    FFactNum    : string;                            //�������
    FSerialID   : string;                            //���Ա��

    FPoundDaiZ  : Double;
    FPoundDaiZ_1: Double;                            //��װ�����
    FPoundDaiF  : Double;
    FPoundDaiF_1: Double;                            //��װ�����
    FDaiPercent : Boolean;                           //����������ƫ��
    FDaiWCStop  : Boolean;                           //�������װƫ��
    FPoundSanZ  : Double;                            //ɢװ�����
    FPoundSanF  : Double;                            //ɢװ�����
    FSanZStop   : Boolean;                           //ɢװ��������
    FPicBase    : Integer;                           //ͼƬ����
    FPicPath    : string;                            //ͼƬĿ¼
  end;
  //ϵͳ����

  TModuleItemType = (mtFrame, mtForm);
  //ģ������

  PMenuModuleItem = ^TMenuModuleItem;
  TMenuModuleItem = record
    FMenuID: string;                                 //�˵�����
    FModule: integer;                                //ģ���ʶ
    FItemType: TModuleItemType;                      //ģ������
  end;

//------------------------------------------------------------------------------
var
  gPath: string;                                     //��������·��
  gSysParam:TSysParam;                               //���򻷾�����
  gStatusBar: TStatusBar;                            //ȫ��ʹ��״̬��
  gMenuModule: TList = nil;                          //�˵�ģ��ӳ���

//------------------------------------------------------------------------------
ResourceString
  sProgID             = 'DMZN';                      //Ĭ�ϱ�ʶ
  sAppTitle           = 'DMZN';                      //�������
  sMainCaption        = 'DMZN';                      //�����ڱ���

  sHint               = '��ʾ';                      //�Ի������
  sWarn               = '����';                      //==
  sAsk                = 'ѯ��';                      //ѯ�ʶԻ���
  sError              = 'δ֪����';                  //����Ի���

  sDate               = '����:��%s��';               //����������
  sTime               = 'ʱ��:��%s��';               //������ʱ��
  sUser               = '�û�:��%s��';               //�������û�

  sLogDir             = 'Logs\';                     //��־Ŀ¼
  sLogExt             = '.log';                      //��־��չ��
  sLogField           = #9;                          //��¼�ָ���

  sImageDir           = 'Images\';                   //ͼƬĿ¼
  sReportDir          = 'Report\';                   //����Ŀ¼
  sBackupDir          = 'Backup\';                   //����Ŀ¼
  sBackupFile         = 'Bacup.idx';                 //��������

  sConfigFile         = 'Config.Ini';                //�������ļ�
  sConfigSec          = 'Config';                    //������С��
  sVerifyCode         = ';Verify:';                  //У������

  sFormConfig         = 'FormInfo.ini';              //��������
  sSetupSec           = 'Setup';                     //����С��
  sDBConfig           = 'DBConn.ini';                //��������
  sDBConfig_bk        = 'isbk';                      //���ݿ�

  sExportExt          = '.txt';                      //����Ĭ����չ��
  sExportFilter       = '�ı�(*.txt)|*.txt|�����ļ�(*.*)|*.*';
                                                     //������������ 

  sInvalidConfig      = '�����ļ���Ч���Ѿ���';    //�����ļ���Ч
  sCloseQuery         = 'ȷ��Ҫ�˳�������?';         //�������˳�

implementation

//------------------------------------------------------------------------------
//Desc: ��Ӳ˵�ģ��ӳ����
procedure AddMenuModuleItem(const nMenu: string; const nModule: Integer;
 const nType: TModuleItemType = mtFrame);
var nItem: PMenuModuleItem;
begin
  New(nItem);
  gMenuModule.Add(nItem);

  nItem.FMenuID := nMenu;
  nItem.FModule := nModule;
  nItem.FItemType := nType;
end;

//Desc: �˵�ģ��ӳ���
procedure InitMenuModuleList;
begin
  gMenuModule := TList.Create;

  AddMenuModuleItem('MAIN_A01', cFI_FormIncInfo, mtForm);
  AddMenuModuleItem('MAIN_A02', cFI_FrameSysLog);
  AddMenuModuleItem('MAIN_A03', cFI_FormBackup, mtForm);
  AddMenuModuleItem('MAIN_A04', cFI_FormRestore, mtForm);
  AddMenuModuleItem('MAIN_A05', cFI_FormChangePwd, mtForm);
  AddMenuModuleItem('MAIN_A06', cFI_FormOptions,mtForm);
  AddMenuModuleItem('MAIN_A07', cFI_FrameAuthorize);

  AddMenuModuleItem('MAIN_B01', cFI_FormNewBill,mtForm);
  AddMenuModuleItem('MAIN_B02', cFI_FrameViewBill);
  AddMenuModuleItem('MAIN_B03', cFI_FrameBillPick);
  AddMenuModuleItem('MAIN_B04', cFI_FrameBillPost);
  AddMenuModuleItem('MAIN_B05', cFI_FrameBillTiaoZ);
  AddMenuModuleItem('MAIN_B06', cFI_FrameMakeCard);
  AddMenuModuleItem('MAIN_B07', cFI_FrameTrucks);

  AddMenuModuleItem('MAIN_C01', cFI_FramePoundManual);
  AddMenuModuleItem('MAIN_C02', cFI_FramePoundQuery);
  AddMenuModuleItem('MAIN_C03', cFI_FrameMaterails);
  AddMenuModuleItem('MAIN_C04', cFI_FrameProvider);

  AddMenuModuleItem('MAIN_D01', cFI_FormLadDai,mtForm);
  AddMenuModuleItem('MAIN_D02', cFI_FrameZTDispatch);

  AddMenuModuleItem('MAIN_E01',cFI_FormLadSan,mtForm);
  AddMenuModuleItem('MAIN_E03',cFI_FramePoundManual);

  AddMenuModuleItem('MAIN_F01', cFI_FormTruckIn,mtForm);
  AddMenuModuleItem('MAIN_F02', cFI_FormTruckOut,mtForm);
  AddMenuModuleItem('MAIN_F03', cFI_FrameTruckQuery);

  AddMenuModuleItem('MAIN_G01', cFI_FrameTruckQuery);
  AddMenuModuleItem('MAIN_G02', cFI_FrameDispatchQuery);
  AddMenuModuleItem('MAIN_G03', cFI_FrameSaleDetailQuery);
  AddMenuModuleItem('MAIN_G04', cFI_FrameQSapLog);
end;

//Desc: ����ģ���б�
procedure ClearMenuModuleList;
var nIdx: integer;
begin
  for nIdx:=gMenuModule.Count - 1 downto 0 do
  begin
    Dispose(PMenuModuleItem(gMenuModule[nIdx]));
    gMenuModule.Delete(nIdx);
  end;

  FreeAndNil(gMenuModule);
end;

initialization
  InitMenuModuleList;
finalization
  ClearMenuModuleList;
end.


