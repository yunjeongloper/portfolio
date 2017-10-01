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
	
	if(pipe(fd1)<0 || pipe(fd2)<0 || pipe(fd3)<0 || pipe(fd4)<0) // 네 개의 파이프 생성
		error_handling("pipe() error");

	act.sa_handler=z_handler; //시그널 핸들링을 위한 핸들러 설정
	sigemptyset(&act.sa_mask);
	act.sa_flags=0;

	state=sigaction(SIGCHLD, &act, 0); //시그널 핸들러 등록
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
		
		// 자식 프로세스 생성   
		if((pid=fork()) ==-1) { // 생성 실패 시   
			close(clnt_sock);
			continue;  
		}  
		else if( pid>0 ) {				// 부모 프로세스 실행 영역
			if(num%2==1)	continue;	//클라이언트 연결을 하나만 받았을 때 다른 연결을 받기 위해 다시 돌아감.
			close(clnt_sock);
			while(1){					//게임 시작
				read(fd1[0], buffer, BUFSIZE);	//자식1의 선택번호 수신

				write(fd4[1], buffer, BUFSIZE);	//자식2에게 선택번호 전송

				read(fd3[0], buffer, BUFSIZE);	//자식2의 선택번호 수신

				write(fd2[1], buffer, BUFSIZE); //자식1에게 선택번호 전송
			}
		}
		else{							//자식 프로세스 실행 영역
			close(serv_sock);
			printf("%d client accepted\n",num);		
			sprintf(buffer,"%d",num);	
			write(clnt_sock, buffer, BUFSIZE);
			while(1){
				if(num%2==1){							//자식1
					read(clnt_sock, buffer, BUFSIZE);	//클라이언트1의 선택번호 수신
					write(fd1[1], buffer, BUFSIZE);		//부모 프로세스로 번호 전송
					printf("\n %d client1's choice : %d \n\n", num, buffer[0]);

					read(fd2[0], buffer, BUFSIZE);		//부모 프로세스로부터 번호 수신
					write(clnt_sock, buffer, BUFSIZE);	//클라이언트1로 선택번호 전송
				}

				if(num%2==0){							//자식2
					read(fd4[0], buffer, BUFSIZE);		//부모 프로세스로부터 번호 수신
					write(clnt_sock, buffer, BUFSIZE);	//클라이언트2로 선택번호 전송

					read(clnt_sock, buffer, BUFSIZE);	//클라이언트2의 선택번호 수신
					write(fd3[1], buffer, BUFSIZE);		//부모 프로세스로 번호 전송
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
	printf("소멸 된 좀비의 프로세스 ID : %d \n", pid);  
	printf("리턴 된 data : %d \n\n", WEXITSTATUS(rtn));   
}  

void error_handling(char *message)  
{  
	fputs(message, stderr);  
	fputc('\n', stderr);  
	exit(1); 
}  

