#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <winsock2.h>
#include <process.h>
#include <time.h>
#pragma comment(lib,"ws2_32.lib")
#define BUFSIZE 1024 // 클라이언트로 부터 받은 메세지를 저장할 버퍼사이즈를 정의 한다..
#define NAMESIZE 20
#define ROOMCNT 11
typedef struct CLIENT{
	char message[BUFSIZE];//메세지
	char name[NAMESIZE];//대화명
	int flag;
	int roomnum;
}client;
typedef struct USERINFO{
	char name[NAMESIZE];//대화명
	int number;
	int roomnum;//입장한 방번호
}userinfo;
typedef struct ROOMINFO{
	char roomname[100];
	int roomclient;//대화방의 접속자수
}roominfo;
void everyone(unsigned clntSock,client user);
void self(unsigned clntSock,client user);
unsigned int WINAPI ClientConn (void *arg); // 쓰레드 생성시 호출할 함수 선언..
int SendMSG (client user, int clntNumber, unsigned clntSock);// 메세지를 보낼때 호출하는 함수 선언..
int clntNumber; //현재 접속자수

SOCKET clntSocks[10]; // 접속한 클라이언트의 파일 디스크립터를 저장할 배열 선언..
HANDLE hMutex; // Mutex 생성시 리턴되는 핸들의 저장할 변수 선언.. 쓰레드들에 의해서 공유되어야 하므로(쓰레드 동기화를 위해서) 전역변수로 선언되어 있다.


client user;
roominfo rinfo[10];
userinfo uinfo[10];
//char namelist[10][20];//접속자 id
int main ()
{
	
	WSADATA wsaData; // WSADATA 변수 선언..
	SOCKET servSock; // servSock의 핸들을 저장.. (리턴값 저장)..
	SOCKET clntSock; // clntSock의 핸들을 저장.. (리턴값 저장)..
	
	SOCKADDR_IN servAddr; // 서버의 주소정보를 나타내는 변수생성..
	SOCKADDR_IN clntAddr; // 클라이언트의 주소정보를 내타내는 변수생성..
	int clntAddrSize; // 클라이언트의 주소정보를 저장할 변수..
	
	HANDLE hThread; // 쓰레드 생성시 리턴하는 핸들의 저장할 변수 선언..
	DWORD dwThreadID; // 쓰레드 생성시 만들어지는 고유한 쓰레드ID를 저장할 변수를 선언한다..
	
	// 서버에서 사용할 PORT 를 입력받는다..
	char PORT[6];
	//strcpy(PORT,"5001");
		printf("사용할 Port Number 를 입력 해 주세요.: ");
		fgets(PORT, 6, stdin);
	
	
	if (WSAStartup(MAKEWORD(2,2), &wsaData)!=0){ // 라이브러리를 초기화하는 작업..
		printf ("WSAStartup Error!!\n"); // 에러 발생시 처리..
		exit(1);}
	
	hMutex = CreateMutex(NULL, FALSE, NULL); // 쓰레드를 동기화 해주기 위해 Mutex 생성.. 현재까지 소유자가 없음
	if(hMutex == NULL){ // 에러 발생시 에러 처리..
		printf ("CreateMutex Error!!\n");
		exit(1);}
	
	servSock = socket (PF_INET, SOCK_STREAM, 0); // IPv4프로토콜에 적합하고 SOCK_STREAM을 데이타 전송타입으로 하는 소켓을 생성..
	if(servSock == INVALID_SOCKET){ // 소켓 생성시 에러발생하면 INVALID_SOCKET을 리턴함으로 이를 변수와 비교하여 에러 처리..
		printf ("Socket Error!!\n");
		exit(1);}
	
	memset(&servAddr, 0, sizeof(servAddr)); // servAddr을 0으로 초기화한다..
	servAddr.sin_family=AF_INET; // IPv4프로토콜로 설정..
	servAddr.sin_addr.s_addr=htonl(INADDR_ANY); // 서버의 IP주소를 자동으로 찾아서 할당
	servAddr.sin_port=htons(atoi(PORT)); // 포트 변환..
	
	if (bind(servSock, (SOCKADDR*) &servAddr, sizeof(servAddr))==SOCKET_ERROR){ // 소켓에 주소를 할당한다.. 이때 에러나면 에러 차리한다..
		printf ("Bind Error!!\n");
		exit(1);}
	
	if (listen(servSock, 5)==SOCKET_ERROR){ // 클라이언트의 연결을 받아들이고 클라이언트를 대기상태로 둔다..
		printf ("Listen Error!!\n");
		exit(1);}
	
	while(1){
		clntAddrSize=sizeof(clntAddr); // 클라이언트의 주소정보의 길이를 저장..
		clntSock=accept(servSock, (SOCKADDR*)&clntAddr, &clntAddrSize); // 대기하는 클라이언트의 연결을 수락한다..
		if(clntSock==INVALID_SOCKET){ // 클라이언트와 연결시 소켓생성에서 에러발생 처리..
			printf ("Accept Error!!\n");
			exit(1);}
		
		// 연결된 클라이언트를 접속한 클라이언트의 배열에 삽입하는 과정으로 이는 한번에 하나의 클라이언트만이 수행해야한다.
		// 따라서 Critical section으로 뮤텍스를 이용해 동기화한다..
		WaitForSingleObject(hMutex, INFINITE); // Critical section을 사용하고 있는 쓰레드가 있는지 검사해서 있으면 대기..
		clntSocks[clntNumber]=clntSock; // 연결된 클라이언트를 clntSocks 배열에 저장한다..
		
		ReleaseMutex(hMutex); // 다른 쓰레드의 진입을 허용한다..
		
		// 새로운 클라이언트가 들어왔을때 이를 서버에 알려준다..
		
		recv(clntSock,(char*)&user,sizeof(user),0);
		printf(" 새로운 클라이언트가 (대화명 : %s, IP : %s) 연결되었습니다.\n",user.name, inet_ntoa(clntAddr.sin_addr));
		strcpy(uinfo[clntNumber++].name,user.name);
		
		// ClientConn 함수를 호출하는 쓰레드 생성 ..
		hThread = (HANDLE)_beginthreadex(NULL, 0, ClientConn, (void*)clntSock, 0, (unsigned *)&dwThreadID);
		if(hThread == 0 ){ // 쓰레드 생성시 오류가 발생하면 에러 처리..
			printf ("Thread Error!!\n");
			exit(1);}
	}
	WSACleanup(); // 할당받은 리소스 해제..
	return 0;
}

// 클라이언트의 접속과 연결 종료를 파악하고, 클라이언트간의 메세지 전송을  담당하는 함수..
unsigned int WINAPI ClientConn (void *arg)
{
	SOCKET clntSock = (SOCKET)arg;
	int strLen = 0, i, end; // 수신된 바이트를 저장한다..
	int frag;
	char message[BUFSIZE]={0}; // 클라이언트로 부터 받은 메세지를 저장할 버퍼를 생성..
	
	
	while(1){
		frag=0;
		fflush(stdin);
		recv(clntSock,(char *)&user,sizeof(user),0);
		
		for(i=0; i<clntNumber; i++)//namelist에 user.name이 있나 확인
		{
			if(!strcmp(uinfo[i].name,user.name))
				frag=1;
		}
		if(frag==0)//없을경우 
		{
			for(i=0; i<clntNumber; i++)
			{
				if (clntSock == clntSocks[i]){
					memset(uinfo[i].name,0,20);
					strcpy(uinfo[i].name,user.name);
				}
			}
		}
		
		end=SendMSG(user,clntNumber, clntSock); // 받은 메세지를 사용할 SendMSG 함수 호출..
		if (end == 1 ) break;
	} // 클라이언트가 종료하고자 할때 while 루프를 빠져나온다..
	
	// 연결을 종료한 클라이언트를 접속한 클라이언트의 배열에서 빼고 그뒤에 있는 클라이언트들을 앞으로 당긴다..
	// 이는 한번에 하나의 클라이언트만이 접근할 수 있는 영역이다. 따라서 뮤텍스를 이용해 동기화한다.. (Critical section)
	WaitForSingleObject(hMutex, INFINITE); // Critical section을 사용하고 있는 쓰레드가 있는지 검사해서 있으면 대기..
	for ( i = 0 ; i<clntNumber; i++){ 
		if (clntSock == clntSocks[i]){
			for ( ; i<clntNumber-1; i++){ // 접속한 클라이언트 재배열..
				clntSocks[i] = clntSocks[i+1];
				strcpy(uinfo[i].name,uinfo[i+1].name);
				
			}
			break;
		}
	}
	clntNumber--; // 접속한 클라이언트 수 재정의..
	ReleaseMutex(hMutex); // 다른 쓰레드의 진입을 허용한다..
	Sleep(2000);
	closesocket(clntSock); // 연결이 종료된 클라이언트의 소켓을 닫는다.. 
	char dab ;
	if (clntNumber == 0) { // 서버에 접속한 클라이언트가 없을때 서버를 종료할지 다른 클라이언트를 기다릴지 정한다..
		while(1){ // 혹 다른 문자 입력시 계속 질문한다..
			printf ("모든 클라이언트가 접속을 종료했습니다.\n서버를 종료하시겠습니까 ? ( y/n )");
			fflush( stdin ); // 한문자를 받고 개행문자를 예약해 버리면 다음에 두번 출력됨으로 이를 방지해준다..
			dab=getchar(); // 한문자를 받는다..
			if (dab=='y') exit(0); // y 라면 프로그램 종료한다..
			if (dab=='n') break; // n 이라면 다른 클라이언트의 입력을 기다린다..
			if (dab!='y'&&dab!='n') printf (" y or n 만 입력해 주세요 !!\n"); // 다른 문자 입력시 출력한다..
		}
	}
	return 0;
}

// 각 클라이언트로 부터 받은 메세지를 각 클라이언트에게 보낸다..
int SendMSG (client user, int clntNumber, unsigned clntSock)
{
	int i,j,flag=0;
	
	char endname[NAMESIZE]={0};
	char helpmsg[]="/c - 대화명 변경\n/l - 현재 접속자 리스트\n/r - 개설된 방 리스트\n/q - 종료\n/e - 대화방 퇴장\n";
	char list[200]={0};
	// 메세지를 전송하는 것도 한번에 하나의 클라이언트만이 수행해야 한다..
	// 따라서 이는 Critical section 이고 뮤텍스를 이용해 동기화한다..
	if(user.flag==5)//방생성
	{
		for(j=1; j<ROOMCNT; j++)
		{
			if(rinfo[j].roomclient==0)
			{
			strcpy(rinfo[j].roomname,user.message);//대화방 이름 저장
				rinfo[j].roomclient++;//대화방의 접속자수 추가
				break;
			}
		}
		for(i=0; i<clntNumber; i++){
			if(clntSocks[i]==clntSock ){
				uinfo[i].roomnum=j;//접속자정보에 방번호 입력
				return 0;
			}
		}
	}
	if(user.flag==6)//방 입장
	{
		for(i=0; i<clntNumber; i++){
			if(clntSocks[i]==clntSock ){
				if(rinfo[user.roomnum].roomclient<1||rinfo[user.roomnum].roomclient>10)
				{
					strcpy(user.message,"개설된 방이 없습니다!\n");
					user.flag=9;
					send(clntSocks[i], (char*)&user, sizeof(user), 0);
					
					return 0;
				}
				rinfo[user.roomnum].roomclient++; //방인원 정보에 인원 추가
				uinfo[i].roomnum=user.roomnum;//접속자정보에 사용자가 입력한 방번호 입력
				 
				for(i=0; i<clntNumber; i++){ // 모든 클라이언트에게 메세지를 보낸다..
					if(clntSocks[i]==clntSock)
						break;
				}
				for(j=0; j<clntNumber; j++){
					if(uinfo[i].roomnum==uinfo[j].roomnum && clntSocks[i]!=clntSocks[j]){
						WaitForSingleObject(hMutex, INFINITE);
						strcpy(user.message,"님이 접속하셨습니다.\n");
						user.flag=1;
						send(clntSocks[j], (char*)&user, sizeof(user), 0);
						ReleaseMutex(hMutex);
					}
				}
				strcpy(user.message,rinfo[user.roomnum].roomname);
				user.flag=10;
				self(clntSock,user);
			
				 // 다른 쓰레드의 진입을 허용한다..
				return 0;
			}
			
		}
	}
	
	
	if (strstr(user.message,"/l"))
	{
		
		for(i=0; i<clntNumber; i++){
			if(clntSocks[i]==clntSock ){
			
				for(j=0; j<clntNumber; j++){
					if(uinfo[i].roomnum==uinfo[j].roomnum){
						strcat(list,"[");
						strcat(list,uinfo[j].name);
						strcat(list,"] ");
					}
				}
				strcat(list,"\n");
				strcpy(user.message,list);
				user.flag=2;
				self(clntSock,user);
			}
		}
		return 0;
	}
	if (strstr(user.message,"/r"))
	{
		
		for(i=0; i<clntNumber; i++){
			if(clntSocks[i]==clntSock)
				break;
		}
		
		
		memset(user.message,0,BUFSIZE);
		for(j=1; j<ROOMCNT; j++){
			if(rinfo[j].roomclient){
			sprintf(list, "%d. ",j);
			strcat(list,rinfo[j].roomname);
			strcat(list,"\n");
			strcat(user.message,list);
			}
		}
		
		user.flag=4;
		self(clntSock,user);
		return 0;
	}
	
	
	if(strstr(user.message,"/h"))
	{
		strcpy(user.message,helpmsg);
		user.flag=8;
		self(clntSock,user);
		return 0;
	}

	if (strstr(user.message,"/e")){ // 만약 메세지가 q라면 종료한다..
		user.flag=7;
		everyone(clntSock,user);
		for(i=0; i<clntNumber; i++){
			if(clntSocks[i]==clntSock){
				

				rinfo[uinfo[i].roomnum].roomclient--;
				uinfo[i].roomnum=0;
				if(rinfo[i].roomclient==0)
				{
					//strcpy(rinfo[i].roomname,0);
					memset(rinfo[i].roomname,0,20);
				}
			
			}
			
		}	
		return 0;
	}
	
	
	if (strstr(user.message,"/q")){ // 만약 메세지가 q라면 종료한다..
		printf(" 클라이언트가 (대화명 : %s) 접속을 종료하였습니다.\n",user.name);
		user.flag=3;
		everyone(clntSock,user);
		
		for(i=0; i<clntNumber; i++){
			if(clntSocks[i]==clntSock){
				

				rinfo[uinfo[i].roomnum].roomclient--;
				uinfo[i].roomnum=0;
				if(rinfo[i].roomclient==0)
				{
					//strcpy(rinfo[i].roomname,0);
					memset(rinfo[i].roomname,0,20);
				}
			
			}
			
		}	
		return 1;
	}
	/*
	WaitForSingleObject(hMutex, INFINITE); 
	for(j=0; j<clntNumber; j++){ 
		if(clntSocks[j]==clntSock)
			break;
	}
	
	for(i=0; i<clntNumber; i++){ // 모든 클라이언트에게 메세지를 보낸다..
		if(clntSocks[i]!=clntSock && uinfo[j].roomnum==uinfo[i].roomnum){
				user.flag=0;
				send(clntSocks[i],(char *)&user, sizeof(user),0);
			}
		
		}
	}
	ReleaseMutex(hMutex); // 다른 쓰레드의 진입을 허용한다..
*/
	everyone(clntSock,user);
	return 0;


}
void self(unsigned clntSock,client user)
{
	int i;
	for(i=0; i<clntNumber; i++){
		if(clntSocks[i]==clntSock){
			WaitForSingleObject(hMutex, INFINITE);
			send(clntSocks[i],(char *)&user, sizeof(user),0);
			ReleaseMutex(hMutex);
		}
	}
}
void everyone(unsigned clntSock,client user)
{
	int i,j;
	for(j=0; j<clntNumber; j++){ 
		if(clntSocks[j]==clntSock)
			break;
	}
	
	for(i=0; i<clntNumber; i++){ // 모든 클라이언트에게 메세지를 보낸다..
		if(clntSocks[i]!=clntSock && uinfo[j].roomnum==uinfo[i].roomnum){
			WaitForSingleObject(hMutex, INFINITE);
			send(clntSocks[i],(char *)&user, sizeof(user),0);
			ReleaseMutex(hMutex);
		}
	}
}