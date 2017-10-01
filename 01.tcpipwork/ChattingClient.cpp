#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <winsock2.h>
#include <process.h>
#include <time.h>
#include <windows.h>
#pragma comment(lib,"ws2_32.lib")
#define BUFSIZE 1024 // 서버에 보낼 메세지를 저장할 버퍼의 사이즈를 정의 한다..
#define NAMESIZE 20

typedef struct CLIENT{
	char message[BUFSIZE];
	char name[NAMESIZE];
	int flag;
	int roomnum;
}client;
client user;
int room;
unsigned int WINAPI SendMSG (void *arg); // 입력한 메세지를 처리하는 함수를 선언한다..
unsigned int WINAPI RecvMSG (void *arg); // 서버에서 받은 메세지를 처리하는 함수를 선언한다..
void admittance(SOCKET sock);
char name[NAMESIZE]={0};
char message[BUFSIZE]={0}; // 서버에 보낼 메세지를 저장할 배열 선언..
char username[NAMESIZE]={0};//대화명 
int main ()
{
	WSADATA wsaData; // WSADATA 변수 선언..
	SOCKET sock; // sock 핸들 저장..(소켓 생성후 리턴값저장)..
	SOCKADDR_IN servAddr; // 서버의 IP 주소 정보 저장할 변수..
	
	HANDLE hThread1, hThread2; // 쓰레드 생성시 리턴하는 핸들을 저장할 변수 선언..
	DWORD dwThreadID1, dwThreadID2; // 쓰레드 고유의 ID를 저장할 변수 선언..
	
	// 접속할 서버의 IP 를 입력받는다..
	char IP[20];
	//strcpy(IP,"127.0.0.1");
	printf("Input Server's IP : ");
	fgets(IP, 20, stdin);
	
	// 접속할 서버의 PORT 를 입력받는다..
	char PORT[6];
	//strcpy(PORT,"5001");
	printf("접속할 Server's Port Number : ");
	fgets(PORT, 6, stdin);
	
	
	
	
	if (WSAStartup(MAKEWORD(2,2), &wsaData)!=0) {// 라이브러리 초기화작업..
		printf ("WSAStartup error!!\n");
		exit(1);}
	
	sock=socket(PF_INET, SOCK_STREAM, 0); // IPv4프로토콜에 적합하고 SOCK_STREAM을 데이타 전송타입으로 하는 소켓을 생성.. 
	if (sock == INVALID_SOCKET){ // 소켓 생성시 에러발생하면 INVALID_SOCKET을 리턴함으로 이를 변수와 비교하여 에러 처리..
		printf ("Socket Error!!\n");
		exit(1);}
	
	memset(&servAddr, 0, sizeof(servAddr)); // servAddr을 0으로 초기화한다..
	servAddr.sin_family=AF_INET; // IPv4프로토콜로 설정..
	servAddr.sin_addr.s_addr=inet_addr(IP); // 인자로 받은 IP 변환..
	servAddr.sin_port=htons(atoi(PORT)); // 포트 변환..
	
	if (connect(sock, (SOCKADDR*)&servAddr, sizeof(servAddr))==SOCKET_ERROR){ // 서버로 연결 요청을 하고 에러 발생시 처리..
		printf ("Connect Error!!\n");
		exit(1);
	}
	
	
	printf("대화명을 입력해주세요 : ");
	gets(user.name);
	strcpy(username,user.name);
	
	
	//user.flag=7;
	send(sock,(char *)&user,sizeof(user),0);
	hThread1 = (HANDLE)_beginthreadex(NULL, 0, SendMSG, (void*)sock, 0, (unsigned *)&dwThreadID1); // SendMSG 함수 호출하는 쓰레드 생성..
	hThread2 = (HANDLE)_beginthreadex(NULL, 0, RecvMSG, (void*)sock, 0, (unsigned *)&dwThreadID2); // RecvMSG 함수 호출하는 쓰레드 생성..
	
	if (hThread1==0 || hThread2==0){ // 쓰레드 생성시 오류 발생하면 오류 처리..
		printf ("Thread Error!!\n");
		exit(1);}
	
	WaitForSingleObject(hThread1, INFINITE); // hThread1 작업이 끝날때 까지 대기한다..
	WaitForSingleObject(hThread2, INFINITE); // hThread2 작업이 끝날때 까지 대기한다.. 
	closesocket(sock); // 소켓을 닫는다..
	return 0;
}
void admittance(SOCKET sock)
{
	int choice;

		fflush(stdin);

		printf("\n1. 방생성\n2. 방리스트 보기\n3. 방 입장\n4. 종료\n도움말=/h\n입력 : ");
		scanf("%d",&choice);
		switch(choice)
		{
		case 1:
			fflush(stdin);
			printf("\n방 제목을 입력해 주세요 : ");
			scanf("%s",user.message);
			user.flag=5;
			room++;
			send(sock,(char *)&user,sizeof(user),0);
		
			printf("[%s]대화방에 입장하셨습니다\n",user.message);
			break;
		case 2:
			strcpy(user.message,"/r");
			send(sock,(char *)&user,sizeof(user),0);
			break;
		case 3:
			fflush(stdin);
			printf("\n입장할 방 번호를 입력해주세요 : ");
			scanf("%d",&user.roomnum);
			user.flag=6;
			room++;
			send(sock,(char *)&user,sizeof(user),0);
			fflush(stdin);
			break;
	
		case 4:
			strcpy(user.message,"/q");
			send(sock,(char *)&user,sizeof(user),0);
			printf("서버와의 연결을 종료합니다.!!\n프로그램을 이용해주셔서 감사합니다.!!\n");
				Sleep(1000);
				closesocket(sock);
				exit(0);
			break;
			}

	
}
unsigned int WINAPI SendMSG (void *arg) // 메세지를 보내는 함수..
{
	char name[20]={0};
	char changename[20]={0};
	char msg[50]="님이 대화명을 바꾸셨습니다 ->";
	SOCKET sock = (SOCKET)arg;
	

	while(1){
		
		while(!room){
			admittance(sock);
			Sleep(300);
			}
		user.flag=0;
		fgets(user.message, BUFSIZE, stdin); // 메세지를 받아서 버퍼에 저장..
		if(strstr(user.message,"/c"))
		{
			
			memset(changename,0,20);
			strcpy(changename,user.name);//이전에 있던 대화명 저장
			memset(name,0,sizeof(name));
			printf("새로운 대화명을 입력해주세요 : ");
			gets(name);//새로운 대화명 입력받음
			
			strcpy(user.message,msg);
			strcat(user.message,name);
			strcat(user.message,"\n");
			strcpy(user.name,username);
			send(sock,(char *)&user,sizeof(user),0);
			strcpy(username,name);
			
		}
		else{
			strcpy(user.name,username);
			send(sock,(char *)&user,sizeof(user),0);
			if (!strcmp(user.message,"/e\n")){
				room--;
			}
			if (!strcmp(user.message,"/q\n"))
			{ // 만약 메세지가 q라면 종료한다..
				printf("서버와의 연결을 종료합니다.!!\n프로그램을 이용해주셔서 감사합니다.!!\n");
				Sleep(1000);
				closesocket(sock);
				exit(0);
			}
		}
	}
}

unsigned int WINAPI RecvMSG (void *arg) // 메세지를 받는 함수..
{
	SOCKET sock = (SOCKET)arg;;
	while(1){
		recv(sock,(char *)&user,sizeof(user),0);
		if(user.flag==1)
		{
			printf("[%s] 님이 접속하셨습니다.\n",user.name);
		}
		else if(user.flag==2)
		{
			printf("현재 접속자 : %s\n",user.message);
		}
		else if(user.flag==3)
		{
			printf("[%s] 님이 종료하셨습니다.\n",user.name);
		}
		else if(user.flag==4)
		{
			printf("\t\t***현재 개설된 방 목록***\n%s",user.message);
		}
		else if(user.flag==7)
		{
			printf("[%s] 님이 퇴장하셨습니다.\n",user.name);
		}
		else if(user.flag==8)
		{
			printf("%s",user.message);
			
		}
		else if(user.flag==9)
		{
			printf("%s",user.message);
			room--;
		}
		else if(user.flag==10)
		{
			printf("[%s]대화방에 입장하셨습니다\n",user.message);
		}

		else{
			printf("[%s] : ",user.name);
			printf("%s",user.message); // 메세지를 출력한다...
		}	
	}
}