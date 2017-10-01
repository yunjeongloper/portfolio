#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/socket.h>
#include <time.h>

#define BUFSIZE 100
void error_handling(char *message);
void z_handler(int sig);

int main(int argc, char **argv)
{
	int fd1[2], fd2[2], fd3[2], fd4[2];
	
	char buffer[BUFSIZE];

	int serv_sock;
	int clnt_sock;
	struct sockaddr_in serv_addr;
	struct sockaddr_in clnt_addr;
	struct sigaction act;
	int str_len, state, addr_size;
	pid_t pid;

	int num=0;
	int choice;
	int winner;

	if(argc!=2){
		printf("Usage : %s <port>\n", argv[0]);
		exit(1);
	}
	
	if(pipe(fd1)<0 || pipe(fd2)<0 || pipe(fd3)<0 || pipe(fd4)<0) // �� ���� ������ ����
		error_handling("pipe() error");

	act.sa_handler=z_handler; //�ñ׳� �ڵ鸵�� ���� �ڵ鷯 ����
	sigemptyset(&act.sa_mask);
	act.sa_flags=0;

	state=sigaction(SIGCHLD, &act, 0); //�ñ׳� �ڵ鷯 ���
	if(state!=0)
		error_handling("sigaction()error");

	serv_sock=socket(PF_INET, SOCK_STREAM, 0);
	
	memset(&serv_addr, 0, sizeof(serv_addr)); 
	serv_addr.sin_family=AF_INET; 
	serv_addr.sin_addr.s_addr=htonl(INADDR_ANY); 
	serv_addr.sin_port=htons(atoi(argv[1])); 

	if(bind(serv_sock, (struct sockaddr*) &serv_addr, sizeof(serv_addr)) )
		error_handling("bind() error");
	if(listen(serv_sock, 5))
		error_handling("listen() error");

	srand(time(NULL));

	while(1){
		addr_size=sizeof(clnt_addr);
	
		clnt_sock=accept(serv_sock, (struct sockaddr*)&clnt_addr, &addr_size);
		if(clnt_sock == -1) continue;
		++num;
		
		// �ڽ� ���μ��� ����   
		if((pid=fork()) ==-1) { // ���� ���� ��   
			close(clnt_sock);
			continue;  
		}  
		else if( pid>0 ) {				// �θ� ���μ��� ���� ����
			if(num%2==1)	continue;	//Ŭ���̾�Ʈ ������ �ϳ��� �޾��� �� �ٸ� ������ �ޱ� ���� �ٽ� ���ư�.
			close(clnt_sock);
			while(1){					//���� ����
				read(fd1[0], buffer, BUFSIZE);	//�ڽ�1�� ���ù�ȣ ����

				write(fd4[1], buffer, BUFSIZE);	//�ڽ�2���� ���ù�ȣ ����

				read(fd3[0], buffer, BUFSIZE);	//�ڽ�2�� ���ù�ȣ ����

				write(fd2[1], buffer, BUFSIZE); //�ڽ�1���� ���ù�ȣ ����
			}
		}
		else{							//�ڽ� ���μ��� ���� ����
			close(serv_sock);
			printf("%d client accepted\n",num);		
			sprintf(buffer,"%d",num);	
			write(clnt_sock, buffer, BUFSIZE);
			while(1){
				if(num%2==1){							//�ڽ�1
					read(clnt_sock, buffer, BUFSIZE);	//Ŭ���̾�Ʈ1�� ���ù�ȣ ����
					write(fd1[1], buffer, BUFSIZE);		//�θ� ���μ����� ��ȣ ����
					printf("\n %d client1's choice : %d \n\n", num, buffer[0]);

					read(fd2[0], buffer, BUFSIZE);		//�θ� ���μ����κ��� ��ȣ ����
					write(clnt_sock, buffer, BUFSIZE);	//Ŭ���̾�Ʈ1�� ���ù�ȣ ����
				}

				if(num%2==0){							//�ڽ�2
					read(fd4[0], buffer, BUFSIZE);		//�θ� ���μ����κ��� ��ȣ ����
					write(clnt_sock, buffer, BUFSIZE);	//Ŭ���̾�Ʈ2�� ���ù�ȣ ����

					read(clnt_sock, buffer, BUFSIZE);	//Ŭ���̾�Ʈ2�� ���ù�ȣ ����
					write(fd3[1], buffer, BUFSIZE);		//�θ� ���μ����� ��ȣ ����
					printf("\n %d client2's choice : %d \n\n", num, buffer[0]);
				}
				//break;
			}
			close(clnt_sock);
			exit(0);
		}
	}
	return 0;
}

void z_handler(int sig)
{
	pid_t pid;
	int rtn;
	
	pid=waitpid(-1, &rtn, WNOHANG);
	printf("�Ҹ� �� ������ ���μ��� ID : %d \n", pid);  
	printf("���� �� data : %d \n\n", WEXITSTATUS(rtn));   
}  

void error_handling(char *message)  
{  
	fputs(message, stderr);  
	fputc('\n', stderr);  
	exit(1); 
}  

