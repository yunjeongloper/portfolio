#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <winsock2.h>
#include <process.h>
#include <time.h>
#pragma comment(lib,"ws2_32.lib")
#define BUFSIZE 1024 // Ŭ���̾�Ʈ�� ���� ���� �޼����� ������ ���ۻ���� ���� �Ѵ�..
#define NAMESIZE 20
#define ROOMCNT 11
typedef struct CLIENT{
	char message[BUFSIZE];//�޼���
	char name[NAMESIZE];//��ȭ��
	int flag;
	int roomnum;
}client;
typedef struct USERINFO{
	char name[NAMESIZE];//��ȭ��
	int number;
	int roomnum;//������ ���ȣ
}userinfo;
typedef struct ROOMINFO{
	char roomname[100];
	int roomclient;//��ȭ���� �����ڼ�
}roominfo;
void everyone(unsigned clntSock,client user);
void self(unsigned clntSock,client user);
unsigned int WINAPI ClientConn (void *arg); // ������ ������ ȣ���� �Լ� ����..
int SendMSG (client user, int clntNumber, unsigned clntSock);// �޼����� ������ ȣ���ϴ� �Լ� ����..
int clntNumber; //���� �����ڼ�

SOCKET clntSocks[10]; // ������ Ŭ���̾�Ʈ�� ���� ��ũ���͸� ������ �迭 ����..
HANDLE hMutex; // Mutex ������ ���ϵǴ� �ڵ��� ������ ���� ����.. ������鿡 ���ؼ� �����Ǿ�� �ϹǷ�(������ ����ȭ�� ���ؼ�) ���������� ����Ǿ� �ִ�.


client user;
roominfo rinfo[10];
userinfo uinfo[10];
//char namelist[10][20];//������ id
int main ()
{
	
	WSADATA wsaData; // WSADATA ���� ����..
	SOCKET servSock; // servSock�� �ڵ��� ����.. (���ϰ� ����)..
	SOCKET clntSock; // clntSock�� �ڵ��� ����.. (���ϰ� ����)..
	
	SOCKADDR_IN servAddr; // ������ �ּ������� ��Ÿ���� ��������..
	SOCKADDR_IN clntAddr; // Ŭ���̾�Ʈ�� �ּ������� ��Ÿ���� ��������..
	int clntAddrSize; // Ŭ���̾�Ʈ�� �ּ������� ������ ����..
	
	HANDLE hThread; // ������ ������ �����ϴ� �ڵ��� ������ ���� ����..
	DWORD dwThreadID; // ������ ������ ��������� ������ ������ID�� ������ ������ �����Ѵ�..
	
	// �������� ����� PORT �� �Է¹޴´�..
	char PORT[6];
	//strcpy(PORT,"5001");
		printf("����� Port Number �� �Է� �� �ּ���.: ");
		fgets(PORT, 6, stdin);
	
	
	if (WSAStartup(MAKEWORD(2,2), &wsaData)!=0){ // ���̺귯���� �ʱ�ȭ�ϴ� �۾�..
		printf ("WSAStartup Error!!\n"); // ���� �߻��� ó��..
		exit(1);}
	
	hMutex = CreateMutex(NULL, FALSE, NULL); // �����带 ����ȭ ���ֱ� ���� Mutex ����.. ������� �����ڰ� ����
	if(hMutex == NULL){ // ���� �߻��� ���� ó��..
		printf ("CreateMutex Error!!\n");
		exit(1);}
	
	servSock = socket (PF_INET, SOCK_STREAM, 0); // IPv4�������ݿ� �����ϰ� SOCK_STREAM�� ����Ÿ ����Ÿ������ �ϴ� ������ ����..
	if(servSock == INVALID_SOCKET){ // ���� ������ �����߻��ϸ� INVALID_SOCKET�� ���������� �̸� ������ ���Ͽ� ���� ó��..
		printf ("Socket Error!!\n");
		exit(1);}
	
	memset(&servAddr, 0, sizeof(servAddr)); // servAddr�� 0���� �ʱ�ȭ�Ѵ�..
	servAddr.sin_family=AF_INET; // IPv4�������ݷ� ����..
	servAddr.sin_addr.s_addr=htonl(INADDR_ANY); // ������ IP�ּҸ� �ڵ����� ã�Ƽ� �Ҵ�
	servAddr.sin_port=htons(atoi(PORT)); // ��Ʈ ��ȯ..
	
	if (bind(servSock, (SOCKADDR*) &servAddr, sizeof(servAddr))==SOCKET_ERROR){ // ���Ͽ� �ּҸ� �Ҵ��Ѵ�.. �̶� �������� ���� �����Ѵ�..
		printf ("Bind Error!!\n");
		exit(1);}
	
	if (listen(servSock, 5)==SOCKET_ERROR){ // Ŭ���̾�Ʈ�� ������ �޾Ƶ��̰� Ŭ���̾�Ʈ�� �����·� �д�..
		printf ("Listen Error!!\n");
		exit(1);}
	
	while(1){
		clntAddrSize=sizeof(clntAddr); // Ŭ���̾�Ʈ�� �ּ������� ���̸� ����..
		clntSock=accept(servSock, (SOCKADDR*)&clntAddr, &clntAddrSize); // ����ϴ� Ŭ���̾�Ʈ�� ������ �����Ѵ�..
		if(clntSock==INVALID_SOCKET){ // Ŭ���̾�Ʈ�� ����� ���ϻ������� �����߻� ó��..
			printf ("Accept Error!!\n");
			exit(1);}
		
		// ����� Ŭ���̾�Ʈ�� ������ Ŭ���̾�Ʈ�� �迭�� �����ϴ� �������� �̴� �ѹ��� �ϳ��� Ŭ���̾�Ʈ���� �����ؾ��Ѵ�.
		// ���� Critical section���� ���ؽ��� �̿��� ����ȭ�Ѵ�..
		WaitForSingleObject(hMutex, INFINITE); // Critical section�� ����ϰ� �ִ� �����尡 �ִ��� �˻��ؼ� ������ ���..
		clntSocks[clntNumber]=clntSock; // ����� Ŭ���̾�Ʈ�� clntSocks �迭�� �����Ѵ�..
		
		ReleaseMutex(hMutex); // �ٸ� �������� ������ ����Ѵ�..
		
		// ���ο� Ŭ���̾�Ʈ�� �������� �̸� ������ �˷��ش�..
		
		recv(clntSock,(char*)&user,sizeof(user),0);
		printf(" ���ο� Ŭ���̾�Ʈ�� (��ȭ�� : %s, IP : %s) ����Ǿ����ϴ�.\n",user.name, inet_ntoa(clntAddr.sin_addr));
		strcpy(uinfo[clntNumber++].name,user.name);
		
		// ClientConn �Լ��� ȣ���ϴ� ������ ���� ..
		hThread = (HANDLE)_beginthreadex(NULL, 0, ClientConn, (void*)clntSock, 0, (unsigned *)&dwThreadID);
		if(hThread == 0 ){ // ������ ������ ������ �߻��ϸ� ���� ó��..
			printf ("Thread Error!!\n");
			exit(1);}
	}
	WSACleanup(); // �Ҵ���� ���ҽ� ����..
	return 0;
}

// Ŭ���̾�Ʈ�� ���Ӱ� ���� ���Ḧ �ľ��ϰ�, Ŭ���̾�Ʈ���� �޼��� ������  ����ϴ� �Լ�..
unsigned int WINAPI ClientConn (void *arg)
{
	SOCKET clntSock = (SOCKET)arg;
	int strLen = 0, i, end; // ���ŵ� ����Ʈ�� �����Ѵ�..
	int frag;
	char message[BUFSIZE]={0}; // Ŭ���̾�Ʈ�� ���� ���� �޼����� ������ ���۸� ����..
	
	
	while(1){
		frag=0;
		fflush(stdin);
		recv(clntSock,(char *)&user,sizeof(user),0);
		
		for(i=0; i<clntNumber; i++)//namelist�� user.name�� �ֳ� Ȯ��
		{
			if(!strcmp(uinfo[i].name,user.name))
				frag=1;
		}
		if(frag==0)//������� 
		{
			for(i=0; i<clntNumber; i++)
			{
				if (clntSock == clntSocks[i]){
					memset(uinfo[i].name,0,20);
					strcpy(uinfo[i].name,user.name);
				}
			}
		}
		
		end=SendMSG(user,clntNumber, clntSock); // ���� �޼����� ����� SendMSG �Լ� ȣ��..
		if (end == 1 ) break;
	} // Ŭ���̾�Ʈ�� �����ϰ��� �Ҷ� while ������ �������´�..
	
	// ������ ������ Ŭ���̾�Ʈ�� ������ Ŭ���̾�Ʈ�� �迭���� ���� �׵ڿ� �ִ� Ŭ���̾�Ʈ���� ������ ����..
	// �̴� �ѹ��� �ϳ��� Ŭ���̾�Ʈ���� ������ �� �ִ� �����̴�. ���� ���ؽ��� �̿��� ����ȭ�Ѵ�.. (Critical section)
	WaitForSingleObject(hMutex, INFINITE); // Critical section�� ����ϰ� �ִ� �����尡 �ִ��� �˻��ؼ� ������ ���..
	for ( i = 0 ; i<clntNumber; i++){ 
		if (clntSock == clntSocks[i]){
			for ( ; i<clntNumber-1; i++){ // ������ Ŭ���̾�Ʈ ��迭..
				clntSocks[i] = clntSocks[i+1];
				strcpy(uinfo[i].name,uinfo[i+1].name);
				
			}
			break;
		}
	}
	clntNumber--; // ������ Ŭ���̾�Ʈ �� ������..
	ReleaseMutex(hMutex); // �ٸ� �������� ������ ����Ѵ�..
	Sleep(2000);
	closesocket(clntSock); // ������ ����� Ŭ���̾�Ʈ�� ������ �ݴ´�.. 
	char dab ;
	if (clntNumber == 0) { // ������ ������ Ŭ���̾�Ʈ�� ������ ������ �������� �ٸ� Ŭ���̾�Ʈ�� ��ٸ��� ���Ѵ�..
		while(1){ // Ȥ �ٸ� ���� �Է½� ��� �����Ѵ�..
			printf ("��� Ŭ���̾�Ʈ�� ������ �����߽��ϴ�.\n������ �����Ͻðڽ��ϱ� ? ( y/n )");
			fflush( stdin ); // �ѹ��ڸ� �ް� ���๮�ڸ� ������ ������ ������ �ι� ��µ����� �̸� �������ش�..
			dab=getchar(); // �ѹ��ڸ� �޴´�..
			if (dab=='y') exit(0); // y ��� ���α׷� �����Ѵ�..
			if (dab=='n') break; // n �̶�� �ٸ� Ŭ���̾�Ʈ�� �Է��� ��ٸ���..
			if (dab!='y'&&dab!='n') printf (" y or n �� �Է��� �ּ��� !!\n"); // �ٸ� ���� �Է½� ����Ѵ�..
		}
	}
	return 0;
}

// �� Ŭ���̾�Ʈ�� ���� ���� �޼����� �� Ŭ���̾�Ʈ���� ������..
int SendMSG (client user, int clntNumber, unsigned clntSock)
{
	int i,j,flag=0;
	
	char endname[NAMESIZE]={0};
	char helpmsg[]="/c - ��ȭ�� ����\n/l - ���� ������ ����Ʈ\n/r - ������ �� ����Ʈ\n/q - ����\n/e - ��ȭ�� ����\n";
	char list[200]={0};
	// �޼����� �����ϴ� �͵� �ѹ��� �ϳ��� Ŭ���̾�Ʈ���� �����ؾ� �Ѵ�..
	// ���� �̴� Critical section �̰� ���ؽ��� �̿��� ����ȭ�Ѵ�..
	if(user.flag==5)//�����
	{
		for(j=1; j<ROOMCNT; j++)
		{
			if(rinfo[j].roomclient==0)
			{
			strcpy(rinfo[j].roomname,user.message);//��ȭ�� �̸� ����
				rinfo[j].roomclient++;//��ȭ���� �����ڼ� �߰�
				break;
			}
		}
		for(i=0; i<clntNumber; i++){
			if(clntSocks[i]==clntSock ){
				uinfo[i].roomnum=j;//������������ ���ȣ �Է�
				return 0;
			}
		}
	}
	if(user.flag==6)//�� ����
	{
		for(i=0; i<clntNumber; i++){
			if(clntSocks[i]==clntSock ){
				if(rinfo[user.roomnum].roomclient<1||rinfo[user.roomnum].roomclient>10)
				{
					strcpy(user.message,"������ ���� �����ϴ�!\n");
					user.flag=9;
					send(clntSocks[i], (char*)&user, sizeof(user), 0);
					
					return 0;
				}
				rinfo[user.roomnum].roomclient++; //���ο� ������ �ο� �߰�
				uinfo[i].roomnum=user.roomnum;//������������ ����ڰ� �Է��� ���ȣ �Է�
				 
				for(i=0; i<clntNumber; i++){ // ��� Ŭ���̾�Ʈ���� �޼����� ������..
					if(clntSocks[i]==clntSock)
						break;
				}
				for(j=0; j<clntNumber; j++){
					if(uinfo[i].roomnum==uinfo[j].roomnum && clntSocks[i]!=clntSocks[j]){
						WaitForSingleObject(hMutex, INFINITE);
						strcpy(user.message,"���� �����ϼ̽��ϴ�.\n");
						user.flag=1;
						send(clntSocks[j], (char*)&user, sizeof(user), 0);
						ReleaseMutex(hMutex);
					}
				}
				strcpy(user.message,rinfo[user.roomnum].roomname);
				user.flag=10;
				self(clntSock,user);
			
				 // �ٸ� �������� ������ ����Ѵ�..
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

	if (strstr(user.message,"/e")){ // ���� �޼����� q��� �����Ѵ�..
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
	
	
	if (strstr(user.message,"/q")){ // ���� �޼����� q��� �����Ѵ�..
		printf(" Ŭ���̾�Ʈ�� (��ȭ�� : %s) ������ �����Ͽ����ϴ�.\n",user.name);
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
	
	for(i=0; i<clntNumber; i++){ // ��� Ŭ���̾�Ʈ���� �޼����� ������..
		if(clntSocks[i]!=clntSock && uinfo[j].roomnum==uinfo[i].roomnum){
				user.flag=0;
				send(clntSocks[i],(char *)&user, sizeof(user),0);
			}
		
		}
	}
	ReleaseMutex(hMutex); // �ٸ� �������� ������ ����Ѵ�..
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
	
	for(i=0; i<clntNumber; i++){ // ��� Ŭ���̾�Ʈ���� �޼����� ������..
		if(clntSocks[i]!=clntSock && uinfo[j].roomnum==uinfo[i].roomnum){
			WaitForSingleObject(hMutex, INFINITE);
			send(clntSocks[i],(char *)&user, sizeof(user),0);
			ReleaseMutex(hMutex);
		}
	}
}