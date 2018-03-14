#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <pthread.h>

#define BUF_SIZE 200
#define MAX_CLNT 256

void * handle_clnt(void * arg);
void send_msg(char * msg, int len,int clnt_sock);
void error_handling(char * msg);

int clnt_cnt=0;
int clnt_socks[MAX_CLNT];
char clnt_info[200] = { 0, };
pthread_mutex_t mutx;

int main(int argc, char *argv[])
{
	int serv_sock, clnt_sock;
	struct sockaddr_in serv_adr, clnt_adr;
	int clnt_adr_sz;
	pthread_t t_id;
	if(argc!=2) {
		printf("Usage : %s <port>\n", argv[0]);
		exit(1);
	}
  
	pthread_mutex_init(&mutx, NULL);
	serv_sock=socket(PF_INET, SOCK_STREAM, 0);

	memset(&serv_adr, 0, sizeof(serv_adr));
	serv_adr.sin_family=AF_INET; 
	serv_adr.sin_addr.s_addr=htonl(INADDR_ANY);
	serv_adr.sin_port=htons(atoi(argv[1]));
	
	if(bind(serv_sock, (struct sockaddr*) &serv_adr, sizeof(serv_adr))==-1)
		error_handling("bind() error");
	if(listen(serv_sock, 5)==-1)
		error_handling("listen() error");
	
	while(1)
	{
		clnt_adr_sz=sizeof(clnt_adr);
		clnt_sock=accept(serv_sock, (struct sockaddr*)&clnt_adr,&clnt_adr_sz);
		
		pthread_mutex_lock(&mutx);
		clnt_socks[clnt_cnt++]=clnt_sock;
		pthread_mutex_unlock(&mutx);

		pthread_create(&t_id, NULL, handle_clnt, (void*)&clnt_sock);
		pthread_detach(t_id);
		printf("Connected client IP: %s \n", inet_ntoa(clnt_adr.sin_addr));
	}
	close(serv_sock);
	return 0;
}

/*생성된 스레드가 처리하는 함수*/
void * handle_clnt(void * arg)
{
	int clnt_sock = *((int*)arg);
	int str_len = 0, i, k = 0;
	char msg[BUF_SIZE] = { 0, };
	char newclnt[30];
	char clnt_list[100];
	char clnt_close[100];

	/*새로운 클라이언트 접속 시에 다른 클라이언트들에게 접속 정보 제공*/
	pthread_mutex_lock(&mutx);
	read(clnt_sock, msg, sizeof(msg));
	sprintf(newclnt, "New client %s!", msg);
	for (i = 0; i < clnt_cnt; i++){
		if (clnt_sock == clnt_socks[i])
			continue;
		else
			write(clnt_socks[i], newclnt, sizeof(newclnt));
	}

	/*새로운 클라이언트 접속 시에 해당 클라이언트에게 대화방 정보 제공*/
	strcat(clnt_info, msg);
	sprintf(clnt_list, "현재 접속 중인 클라이언트(총%d명) : %s", clnt_cnt, clnt_info);
	write(clnt_sock, clnt_list, sizeof(clnt_list));
	pthread_mutex_unlock(&mutx);

	while ((str_len = read(clnt_sock, msg, sizeof(msg))) != 0){
		/*클라이언트 접속 종료 시 다른 클라이언트들에게 접속 종료 정보 제공*/
		if ((msg[0] == 'Q') || (msg[0] == 'q')){
			sprintf(clnt_close, "%s 님이 접속을 종료하였습니다.\n", &msg[1]);
			pthread_mutex_lock(&mutx);
			for (i = 0; i < clnt_cnt; i++){
				write(clnt_socks[i], clnt_close, sizeof(clnt_close));
			}
			pthread_mutex_unlock(&mutx);
		}
		else
			send_msg(msg, str_len, clnt_sock);
	}


	/*클라이언트 접속 종료시 전역변수 처리 과정*/
	pthread_mutex_lock(&mutx);
	for(i=0; i<clnt_cnt; i++)  
	{
		if (clnt_sock == clnt_socks[i])
		{
			while (i < clnt_cnt - 1){
				clnt_socks[i] = clnt_socks[i + 1]; i++;
			}
			break;
		}
	}
	clnt_cnt--;
	pthread_mutex_unlock(&mutx);

	close(clnt_sock);

	return NULL;
}

/*클라이언트에게 메세지 전송*/
void send_msg(char * msg, int len,int clnt_sock)
{
	int i;
	/*입력한 메세지는 본인을 제외한 클라이언트들에게 전송되도록 설정*/
	pthread_mutex_lock(&mutx);
	for (i = 0; i < clnt_cnt; i++){
		if (clnt_sock == clnt_socks[i])
			continue;
		else
			write(clnt_socks[i], msg, len);
	}
	pthread_mutex_unlock(&mutx);
}
void error_handling(char * msg)
{
	fputs(msg, stderr);
	fputc('\n', stderr);
	exit(1);
}