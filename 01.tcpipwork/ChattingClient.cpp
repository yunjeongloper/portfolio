#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <winsock2.h>
#include <process.h>
#include <time.h>
#include <windows.h>
#pragma comment(lib,"ws2_32.lib")
#define BUFSIZE 1024 // ������ ���� �޼����� ������ ������ ����� ���� �Ѵ�..
#define NAMESIZE 20

typedef struct CLIENT{
	char message[BUFSIZE];
	char name[NAMESIZE];
	int flag;
	int roomnum;
}client;
client user;
int room;
unsigned int WINAPI SendMSG (void *arg); // �Է��� �޼����� ó���ϴ� �Լ��� �����Ѵ�..
unsigned int WINAPI RecvMSG (void *arg); // �������� ���� �޼����� ó���ϴ� �Լ��� �����Ѵ�..
void admittance(SOCKET sock);
char name[NAMESIZE]={0};
char message[BUFSIZE]={0}; // ������ ���� �޼����� ������ �迭 ����..
char username[NAMESIZE]={0};//��ȭ�� 
int main ()
{
	WSADATA wsaData; // WSADATA ���� ����..
	SOCKET sock; // sock �ڵ� ����..(���� ������ ���ϰ�����)..
	SOCKADDR_IN servAddr; // ������ IP �ּ� ���� ������ ����..
	
	HANDLE hThread1, hThread2; // ������ ������ �����ϴ� �ڵ��� ������ ���� ����..
	DWORD dwThreadID1, dwThreadID2; // ������ ������ ID�� ������ ���� ����..
	
	// ������ ������ IP �� �Է¹޴´�..
	char IP[20];
	//strcpy(IP,"127.0.0.1");
	printf("Input Server's IP : ");
	fgets(IP, 20, stdin);
	
	// ������ ������ PORT �� �Է¹޴´�..
	char PORT[6];
	//strcpy(PORT,"5001");
	printf("������ Server's Port Number : ");
	fgets(PORT, 6, stdin);
	
	
	
	
	if (WSAStartup(MAKEWORD(2,2), &wsaData)!=0) {// ���̺귯�� �ʱ�ȭ�۾�..
		printf ("WSAStartup error!!\n");
		exit(1);}
	
	sock=socket(PF_INET, SOCK_STREAM, 0); // IPv4�������ݿ� �����ϰ� SOCK_STREAM�� ����Ÿ ����Ÿ������ �ϴ� ������ ����.. 
	if (sock == INVALID_SOCKET){ // ���� ������ �����߻��ϸ� INVALID_SOCKET�� ���������� �̸� ������ ���Ͽ� ���� ó��..
		printf ("Socket Error!!\n");
		exit(1);}
	
	memset(&servAddr, 0, sizeof(servAddr)); // servAddr�� 0���� �ʱ�ȭ�Ѵ�..
	servAddr.sin_family=AF_INET; // IPv4�������ݷ� ����..
	servAddr.sin_addr.s_addr=inet_addr(IP); // ���ڷ� ���� IP ��ȯ..
	servAddr.sin_port=htons(atoi(PORT)); // ��Ʈ ��ȯ..
	
	if (connect(sock, (SOCKADDR*)&servAddr, sizeof(servAddr))==SOCKET_ERROR){ // ������ ���� ��û�� �ϰ� ���� �߻��� ó��..
		printf ("Connect Error!!\n");
		exit(1);
	}
	
	
	printf("��ȭ���� �Է����ּ��� : ");
	gets(user.name);
	strcpy(username,user.name);
	
	
	//user.flag=7;
	send(sock,(char *)&user,sizeof(user),0);
	hThread1 = (HANDLE)_beginthreadex(NULL, 0, SendMSG, (void*)sock, 0, (unsigned *)&dwThreadID1); // SendMSG �Լ� ȣ���ϴ� ������ ����..
	hThread2 = (HANDLE)_beginthreadex(NULL, 0, RecvMSG, (void*)sock, 0, (unsigned *)&dwThreadID2); // RecvMSG �Լ� ȣ���ϴ� ������ ����..
	
	if (hThread1==0 || hThread2==0){ // ������ ������ ���� �߻��ϸ� ���� ó��..
		printf ("Thread Error!!\n");
		exit(1);}
	
	WaitForSingleObject(hThread1, INFINITE); // hThread1 �۾��� ������ ���� ����Ѵ�..
	WaitForSingleObject(hThread2, INFINITE); // hThread2 �۾��� ������ ���� ����Ѵ�.. 
	closesocket(sock); // ������ �ݴ´�..
	return 0;
}
void admittance(SOCKET sock)
{
	int choice;

		fflush(stdin);

		printf("\n1. �����\n2. �渮��Ʈ ����\n3. �� ����\n4. ����\n����=/h\n�Է� : ");
		scanf("%d",&choice);
		switch(choice)
		{
		case 1:
			fflush(stdin);
			printf("\n�� ������ �Է��� �ּ��� : ");
			scanf("%s",user.message);
			user.flag=5;
			room++;
			send(sock,(char *)&user,sizeof(user),0);
		
			printf("[%s]��ȭ�濡 �����ϼ̽��ϴ�\n",user.message);
			break;
		case 2:
			strcpy(user.message,"/r");
			send(sock,(char *)&user,sizeof(user),0);
			break;
		case 3:
			fflush(stdin);
			printf("\n������ �� ��ȣ�� �Է����ּ��� : ");
			scanf("%d",&user.roomnum);
			user.flag=6;
			room++;
			send(sock,(char *)&user,sizeof(user),0);
			fflush(stdin);
			break;
	
		case 4:
			strcpy(user.message,"/q");
			send(sock,(char *)&user,sizeof(user),0);
			printf("�������� ������ �����մϴ�.!!\n���α׷��� �̿����ּż� �����մϴ�.!!\n");
				Sleep(1000);
				closesocket(sock);
				exit(0);
			break;
			}

	
}
unsigned int WINAPI SendMSG (void *arg) // �޼����� ������ �Լ�..
{
	char name[20]={0};
	char changename[20]={0};
	char msg[50]="���� ��ȭ���� �ٲټ̽��ϴ� ->";
	SOCKET sock = (SOCKET)arg;
	

	while(1){
		
		while(!room){
			admittance(sock);
			Sleep(300);
			}
		user.flag=0;
		fgets(user.message, BUFSIZE, stdin); // �޼����� �޾Ƽ� ���ۿ� ����..
		if(strstr(user.message,"/c"))
		{
			
			memset(changename,0,20);
			strcpy(changename,user.name);//������ �ִ� ��ȭ�� ����
			memset(name,0,sizeof(name));
			printf("���ο� ��ȭ���� �Է����ּ��� : ");
			gets(name);//���ο� ��ȭ�� �Է¹���
			
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
			{ // ���� �޼����� q��� �����Ѵ�..
				printf("�������� ������ �����մϴ�.!!\n���α׷��� �̿����ּż� �����մϴ�.!!\n");
				Sleep(1000);
				closesocket(sock);
				exit(0);
			}
		}
	}
}

unsigned int WINAPI RecvMSG (void *arg) // �޼����� �޴� �Լ�..
{
	SOCKET sock = (SOCKET)arg;;
	while(1){
		recv(sock,(char *)&user,sizeof(user),0);
		if(user.flag==1)
		{
			printf("[%s] ���� �����ϼ̽��ϴ�.\n",user.name);
		}
		else if(user.flag==2)
		{
			printf("���� ������ : %s\n",user.message);
		}
		else if(user.flag==3)
		{
			printf("[%s] ���� �����ϼ̽��ϴ�.\n",user.name);
		}
		else if(user.flag==4)
		{
			printf("\t\t***���� ������ �� ���***\n%s",user.message);
		}
		else if(user.flag==7)
		{
			printf("[%s] ���� �����ϼ̽��ϴ�.\n",user.name);
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
			printf("[%s]��ȭ�濡 �����ϼ̽��ϴ�\n",user.message);
		}

		else{
			printf("[%s] : ",user.name);
			printf("%s",user.message); // �޼����� ����Ѵ�...
		}	
	}
}