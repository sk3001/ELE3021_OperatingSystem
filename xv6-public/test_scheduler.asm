
_test_scheduler:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
	int arg;
};

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
		/* Process scheduled by MLFQ scheduler, does not yield itself */
		{test_mlfq, MLFQ_NONE},
		{test_mlfq, MLFQ_NONE},
	};

	for (i = 0; i < WORKLOAD_NUM; i++) {
   f:	31 db                	xor    %ebx,%ebx
{
  11:	83 ec 20             	sub    $0x20,%esp
	struct workload workloads[WORKLOAD_NUM] = {
  14:	c7 45 d8 a0 01 00 00 	movl   $0x1a0,-0x28(%ebp)
  1b:	c7 45 dc 05 00 00 00 	movl   $0x5,-0x24(%ebp)
  22:	c7 45 e0 a0 01 00 00 	movl   $0x1a0,-0x20(%ebp)
  29:	c7 45 e4 0f 00 00 00 	movl   $0xf,-0x1c(%ebp)
  30:	c7 45 e8 a0 00 00 00 	movl   $0xa0,-0x18(%ebp)
  37:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  3e:	c7 45 f0 a0 00 00 00 	movl   $0xa0,-0x10(%ebp)
  45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		pid = fork();
  4c:	e8 19 04 00 00       	call   46a <fork>
		if (pid > 0) {
  51:	83 f8 00             	cmp    $0x0,%eax
  54:	7f 12                	jg     68 <main+0x68>
			/* Parent */
			continue;
		} else if (pid == 0) {
  56:	75 31                	jne    89 <main+0x89>
			/* Child */
			void (*func)(int) = workloads[i].func;
			int arg = workloads[i].arg;
			/* Do this workload */
			func(arg);
  58:	83 ec 0c             	sub    $0xc,%esp
  5b:	ff 74 dd dc          	pushl  -0x24(%ebp,%ebx,8)
  5f:	ff 54 dd d8          	call   *-0x28(%ebp,%ebx,8)
			exit();
  63:	e8 0a 04 00 00       	call   472 <exit>
	for (i = 0; i < WORKLOAD_NUM; i++) {
  68:	83 c3 01             	add    $0x1,%ebx
  6b:	83 fb 04             	cmp    $0x4,%ebx
  6e:	75 dc                	jne    4c <main+0x4c>
			exit();
		}
	}

	for (i = 0; i < WORKLOAD_NUM; i++) {
		wait();
  70:	e8 05 04 00 00       	call   47a <wait>
  75:	e8 00 04 00 00       	call   47a <wait>
  7a:	e8 fb 03 00 00       	call   47a <wait>
  7f:	e8 f6 03 00 00       	call   47a <wait>
	}

	exit();
  84:	e8 e9 03 00 00       	call   472 <exit>
			printf(1, "FAIL : fork\n");
  89:	50                   	push   %eax
  8a:	50                   	push   %eax
  8b:	68 98 09 00 00       	push   $0x998
  90:	6a 01                	push   $0x1
  92:	e8 59 05 00 00       	call   5f0 <printf>
			exit();
  97:	e8 d6 03 00 00       	call   472 <exit>
  9c:	66 90                	xchg   %ax,%ax
  9e:	66 90                	xchg   %ax,%ax

000000a0 <test_mlfq>:
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	57                   	push   %edi
  a4:	56                   	push   %esi
  a5:	53                   	push   %ebx
	int cnt = 0;
  a6:	31 db                	xor    %ebx,%ebx
{
  a8:	83 ec 2c             	sub    $0x2c,%esp
	int cnt_level[MLFQ_LEVEL] = {0, 0, 0};
  ab:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  b2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  b9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	start_tick = uptime();
  c0:	e8 45 04 00 00       	call   50a <uptime>
  c5:	89 c7                	mov    %eax,%edi
			if (type == MLFQ_YIELD || type == MLFQ_LEVCNT_YIELD) {
  c7:	8b 45 08             	mov    0x8(%ebp),%eax
  ca:	8b 75 08             	mov    0x8(%ebp),%esi
  cd:	83 e8 02             	sub    $0x2,%eax
  d0:	83 e6 fd             	and    $0xfffffffd,%esi
  d3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  d6:	8d 76 00             	lea    0x0(%esi),%esi
  d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
			cnt++;
  e0:	83 c3 01             	add    $0x1,%ebx
			if (type == MLFQ_LEVCNT || type == MLFQ_LEVCNT_YIELD ) {
  e3:	83 fe 01             	cmp    $0x1,%esi
  e6:	74 28                	je     110 <test_mlfq+0x70>
			curr_tick = uptime();
  e8:	e8 1d 04 00 00       	call   50a <uptime>
			if (curr_tick - start_tick > LIFETIME) {
  ed:	29 f8                	sub    %edi,%eax
  ef:	3d e8 03 00 00       	cmp    $0x3e8,%eax
  f4:	7f 32                	jg     128 <test_mlfq+0x88>
			if (type == MLFQ_YIELD || type == MLFQ_LEVCNT_YIELD) {
  f6:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
  fa:	77 e4                	ja     e0 <test_mlfq+0x40>
				yield();
  fc:	e8 11 04 00 00       	call   512 <yield>
			cnt++;
 101:	83 c3 01             	add    $0x1,%ebx
			if (type == MLFQ_LEVCNT || type == MLFQ_LEVCNT_YIELD ) {
 104:	83 fe 01             	cmp    $0x1,%esi
 107:	75 df                	jne    e8 <test_mlfq+0x48>
 109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
				curr_mlfq_level = getlev(); /* getlev : system call */
 110:	e8 05 04 00 00       	call   51a <getlev>
				cnt_level[curr_mlfq_level]++;
 115:	83 44 85 dc 01       	addl   $0x1,-0x24(%ebp,%eax,4)
			curr_tick = uptime();
 11a:	e8 eb 03 00 00       	call   50a <uptime>
			if (curr_tick - start_tick > LIFETIME) {
 11f:	29 f8                	sub    %edi,%eax
 121:	3d e8 03 00 00       	cmp    $0x3e8,%eax
 126:	7e ce                	jle    f6 <test_mlfq+0x56>
	if (type == MLFQ_LEVCNT || type == MLFQ_LEVCNT_YIELD ) {
 128:	83 fe 01             	cmp    $0x1,%esi
 12b:	75 3b                	jne    168 <test_mlfq+0xc8>
		printf(1, "MLfQ(%s), cnt : %d, lev[0] : %d, lev[1] : %d, lev[2] : %d\n",
 12d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 131:	ba 48 09 00 00       	mov    $0x948,%edx
 136:	b8 50 09 00 00       	mov    $0x950,%eax
 13b:	0f 44 c2             	cmove  %edx,%eax
 13e:	83 ec 04             	sub    $0x4,%esp
 141:	ff 75 e4             	pushl  -0x1c(%ebp)
 144:	ff 75 e0             	pushl  -0x20(%ebp)
 147:	ff 75 dc             	pushl  -0x24(%ebp)
 14a:	53                   	push   %ebx
 14b:	50                   	push   %eax
 14c:	68 a8 09 00 00       	push   $0x9a8
 151:	6a 01                	push   $0x1
 153:	e8 98 04 00 00       	call   5f0 <printf>
 158:	83 c4 20             	add    $0x20,%esp
}
 15b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 15e:	5b                   	pop    %ebx
 15f:	5e                   	pop    %esi
 160:	5f                   	pop    %edi
 161:	5d                   	pop    %ebp
 162:	c3                   	ret    
 163:	90                   	nop
 164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		printf(1, "MLfQ(%s), cnt : %d\n",
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	ba 48 09 00 00       	mov    $0x948,%edx
 170:	53                   	push   %ebx
 171:	85 c0                	test   %eax,%eax
 173:	b8 50 09 00 00       	mov    $0x950,%eax
 178:	0f 44 c2             	cmove  %edx,%eax
 17b:	50                   	push   %eax
 17c:	68 56 09 00 00       	push   $0x956
 181:	6a 01                	push   $0x1
 183:	e8 68 04 00 00       	call   5f0 <printf>
 188:	83 c4 10             	add    $0x10,%esp
}
 18b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 18e:	5b                   	pop    %ebx
 18f:	5e                   	pop    %esi
 190:	5f                   	pop    %edi
 191:	5d                   	pop    %ebp
 192:	c3                   	ret    
 193:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001a0 <test_stride>:
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	57                   	push   %edi
 1a4:	56                   	push   %esi
 1a5:	53                   	push   %ebx
 1a6:	83 ec 18             	sub    $0x18,%esp
 1a9:	8b 7d 08             	mov    0x8(%ebp),%edi
	if (set_cpu_share(portion) != 0) {
 1ac:	57                   	push   %edi
 1ad:	e8 70 03 00 00       	call   522 <set_cpu_share>
 1b2:	83 c4 10             	add    $0x10,%esp
 1b5:	85 c0                	test   %eax,%eax
 1b7:	75 3f                	jne    1f8 <test_stride+0x58>
 1b9:	89 c3                	mov    %eax,%ebx
	start_tick = uptime();
 1bb:	e8 4a 03 00 00       	call   50a <uptime>
 1c0:	89 c6                	mov    %eax,%esi
 1c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
			curr_tick = uptime();
 1c8:	e8 3d 03 00 00       	call   50a <uptime>
			if (curr_tick - start_tick > LIFETIME) {
 1cd:	29 f0                	sub    %esi,%eax
			cnt++;
 1cf:	83 c3 01             	add    $0x1,%ebx
			if (curr_tick - start_tick > LIFETIME) {
 1d2:	3d e8 03 00 00       	cmp    $0x3e8,%eax
 1d7:	7e ef                	jle    1c8 <test_stride+0x28>
	printf(1, "STRIDE(%d%%), cnt : %d\n", portion, cnt);
 1d9:	53                   	push   %ebx
 1da:	57                   	push   %edi
 1db:	68 80 09 00 00       	push   $0x980
 1e0:	6a 01                	push   $0x1
 1e2:	e8 09 04 00 00       	call   5f0 <printf>
	return;
 1e7:	83 c4 10             	add    $0x10,%esp
}
 1ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1ed:	5b                   	pop    %ebx
 1ee:	5e                   	pop    %esi
 1ef:	5f                   	pop    %edi
 1f0:	5d                   	pop    %ebp
 1f1:	c3                   	ret    
 1f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		printf(1, "FAIL : set_cpu_share\n");
 1f8:	83 ec 08             	sub    $0x8,%esp
 1fb:	68 6a 09 00 00       	push   $0x96a
 200:	6a 01                	push   $0x1
 202:	e8 e9 03 00 00       	call   5f0 <printf>
 207:	83 c4 10             	add    $0x10,%esp
}
 20a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 20d:	5b                   	pop    %ebx
 20e:	5e                   	pop    %esi
 20f:	5f                   	pop    %edi
 210:	5d                   	pop    %ebp
 211:	c3                   	ret    
 212:	66 90                	xchg   %ax,%ax
 214:	66 90                	xchg   %ax,%ax
 216:	66 90                	xchg   %ax,%ax
 218:	66 90                	xchg   %ax,%ax
 21a:	66 90                	xchg   %ax,%ax
 21c:	66 90                	xchg   %ax,%ax
 21e:	66 90                	xchg   %ax,%ax

00000220 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	53                   	push   %ebx
 224:	8b 45 08             	mov    0x8(%ebp),%eax
 227:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 22a:	89 c2                	mov    %eax,%edx
 22c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 230:	83 c1 01             	add    $0x1,%ecx
 233:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 237:	83 c2 01             	add    $0x1,%edx
 23a:	84 db                	test   %bl,%bl
 23c:	88 5a ff             	mov    %bl,-0x1(%edx)
 23f:	75 ef                	jne    230 <strcpy+0x10>
    ;
  return os;
}
 241:	5b                   	pop    %ebx
 242:	5d                   	pop    %ebp
 243:	c3                   	ret    
 244:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 24a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000250 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	53                   	push   %ebx
 254:	8b 55 08             	mov    0x8(%ebp),%edx
 257:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 25a:	0f b6 02             	movzbl (%edx),%eax
 25d:	0f b6 19             	movzbl (%ecx),%ebx
 260:	84 c0                	test   %al,%al
 262:	75 1c                	jne    280 <strcmp+0x30>
 264:	eb 2a                	jmp    290 <strcmp+0x40>
 266:	8d 76 00             	lea    0x0(%esi),%esi
 269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 270:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 273:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 276:	83 c1 01             	add    $0x1,%ecx
 279:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 27c:	84 c0                	test   %al,%al
 27e:	74 10                	je     290 <strcmp+0x40>
 280:	38 d8                	cmp    %bl,%al
 282:	74 ec                	je     270 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 284:	29 d8                	sub    %ebx,%eax
}
 286:	5b                   	pop    %ebx
 287:	5d                   	pop    %ebp
 288:	c3                   	ret    
 289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 290:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 292:	29 d8                	sub    %ebx,%eax
}
 294:	5b                   	pop    %ebx
 295:	5d                   	pop    %ebp
 296:	c3                   	ret    
 297:	89 f6                	mov    %esi,%esi
 299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002a0 <strlen>:

uint
strlen(const char *s)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 2a6:	80 39 00             	cmpb   $0x0,(%ecx)
 2a9:	74 15                	je     2c0 <strlen+0x20>
 2ab:	31 d2                	xor    %edx,%edx
 2ad:	8d 76 00             	lea    0x0(%esi),%esi
 2b0:	83 c2 01             	add    $0x1,%edx
 2b3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 2b7:	89 d0                	mov    %edx,%eax
 2b9:	75 f5                	jne    2b0 <strlen+0x10>
    ;
  return n;
}
 2bb:	5d                   	pop    %ebp
 2bc:	c3                   	ret    
 2bd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 2c0:	31 c0                	xor    %eax,%eax
}
 2c2:	5d                   	pop    %ebp
 2c3:	c3                   	ret    
 2c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000002d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	57                   	push   %edi
 2d4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2da:	8b 45 0c             	mov    0xc(%ebp),%eax
 2dd:	89 d7                	mov    %edx,%edi
 2df:	fc                   	cld    
 2e0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2e2:	89 d0                	mov    %edx,%eax
 2e4:	5f                   	pop    %edi
 2e5:	5d                   	pop    %ebp
 2e6:	c3                   	ret    
 2e7:	89 f6                	mov    %esi,%esi
 2e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002f0 <strchr>:

char*
strchr(const char *s, char c)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	53                   	push   %ebx
 2f4:	8b 45 08             	mov    0x8(%ebp),%eax
 2f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 2fa:	0f b6 10             	movzbl (%eax),%edx
 2fd:	84 d2                	test   %dl,%dl
 2ff:	74 1d                	je     31e <strchr+0x2e>
    if(*s == c)
 301:	38 d3                	cmp    %dl,%bl
 303:	89 d9                	mov    %ebx,%ecx
 305:	75 0d                	jne    314 <strchr+0x24>
 307:	eb 17                	jmp    320 <strchr+0x30>
 309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 310:	38 ca                	cmp    %cl,%dl
 312:	74 0c                	je     320 <strchr+0x30>
  for(; *s; s++)
 314:	83 c0 01             	add    $0x1,%eax
 317:	0f b6 10             	movzbl (%eax),%edx
 31a:	84 d2                	test   %dl,%dl
 31c:	75 f2                	jne    310 <strchr+0x20>
      return (char*)s;
  return 0;
 31e:	31 c0                	xor    %eax,%eax
}
 320:	5b                   	pop    %ebx
 321:	5d                   	pop    %ebp
 322:	c3                   	ret    
 323:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000330 <gets>:

char*
gets(char *buf, int max)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	57                   	push   %edi
 334:	56                   	push   %esi
 335:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 336:	31 f6                	xor    %esi,%esi
 338:	89 f3                	mov    %esi,%ebx
{
 33a:	83 ec 1c             	sub    $0x1c,%esp
 33d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 340:	eb 2f                	jmp    371 <gets+0x41>
 342:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 348:	8d 45 e7             	lea    -0x19(%ebp),%eax
 34b:	83 ec 04             	sub    $0x4,%esp
 34e:	6a 01                	push   $0x1
 350:	50                   	push   %eax
 351:	6a 00                	push   $0x0
 353:	e8 32 01 00 00       	call   48a <read>
    if(cc < 1)
 358:	83 c4 10             	add    $0x10,%esp
 35b:	85 c0                	test   %eax,%eax
 35d:	7e 1c                	jle    37b <gets+0x4b>
      break;
    buf[i++] = c;
 35f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 363:	83 c7 01             	add    $0x1,%edi
 366:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 369:	3c 0a                	cmp    $0xa,%al
 36b:	74 23                	je     390 <gets+0x60>
 36d:	3c 0d                	cmp    $0xd,%al
 36f:	74 1f                	je     390 <gets+0x60>
  for(i=0; i+1 < max; ){
 371:	83 c3 01             	add    $0x1,%ebx
 374:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 377:	89 fe                	mov    %edi,%esi
 379:	7c cd                	jl     348 <gets+0x18>
 37b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 37d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 380:	c6 03 00             	movb   $0x0,(%ebx)
}
 383:	8d 65 f4             	lea    -0xc(%ebp),%esp
 386:	5b                   	pop    %ebx
 387:	5e                   	pop    %esi
 388:	5f                   	pop    %edi
 389:	5d                   	pop    %ebp
 38a:	c3                   	ret    
 38b:	90                   	nop
 38c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 390:	8b 75 08             	mov    0x8(%ebp),%esi
 393:	8b 45 08             	mov    0x8(%ebp),%eax
 396:	01 de                	add    %ebx,%esi
 398:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 39a:	c6 03 00             	movb   $0x0,(%ebx)
}
 39d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3a0:	5b                   	pop    %ebx
 3a1:	5e                   	pop    %esi
 3a2:	5f                   	pop    %edi
 3a3:	5d                   	pop    %ebp
 3a4:	c3                   	ret    
 3a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003b0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	56                   	push   %esi
 3b4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b5:	83 ec 08             	sub    $0x8,%esp
 3b8:	6a 00                	push   $0x0
 3ba:	ff 75 08             	pushl  0x8(%ebp)
 3bd:	e8 f0 00 00 00       	call   4b2 <open>
  if(fd < 0)
 3c2:	83 c4 10             	add    $0x10,%esp
 3c5:	85 c0                	test   %eax,%eax
 3c7:	78 27                	js     3f0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 3c9:	83 ec 08             	sub    $0x8,%esp
 3cc:	ff 75 0c             	pushl  0xc(%ebp)
 3cf:	89 c3                	mov    %eax,%ebx
 3d1:	50                   	push   %eax
 3d2:	e8 f3 00 00 00       	call   4ca <fstat>
  close(fd);
 3d7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 3da:	89 c6                	mov    %eax,%esi
  close(fd);
 3dc:	e8 b9 00 00 00       	call   49a <close>
  return r;
 3e1:	83 c4 10             	add    $0x10,%esp
}
 3e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3e7:	89 f0                	mov    %esi,%eax
 3e9:	5b                   	pop    %ebx
 3ea:	5e                   	pop    %esi
 3eb:	5d                   	pop    %ebp
 3ec:	c3                   	ret    
 3ed:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 3f0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3f5:	eb ed                	jmp    3e4 <stat+0x34>
 3f7:	89 f6                	mov    %esi,%esi
 3f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000400 <atoi>:

int
atoi(const char *s)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	53                   	push   %ebx
 404:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 407:	0f be 11             	movsbl (%ecx),%edx
 40a:	8d 42 d0             	lea    -0x30(%edx),%eax
 40d:	3c 09                	cmp    $0x9,%al
  n = 0;
 40f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 414:	77 1f                	ja     435 <atoi+0x35>
 416:	8d 76 00             	lea    0x0(%esi),%esi
 419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 420:	8d 04 80             	lea    (%eax,%eax,4),%eax
 423:	83 c1 01             	add    $0x1,%ecx
 426:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 42a:	0f be 11             	movsbl (%ecx),%edx
 42d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 430:	80 fb 09             	cmp    $0x9,%bl
 433:	76 eb                	jbe    420 <atoi+0x20>
  return n;
}
 435:	5b                   	pop    %ebx
 436:	5d                   	pop    %ebp
 437:	c3                   	ret    
 438:	90                   	nop
 439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000440 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	56                   	push   %esi
 444:	53                   	push   %ebx
 445:	8b 5d 10             	mov    0x10(%ebp),%ebx
 448:	8b 45 08             	mov    0x8(%ebp),%eax
 44b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 44e:	85 db                	test   %ebx,%ebx
 450:	7e 14                	jle    466 <memmove+0x26>
 452:	31 d2                	xor    %edx,%edx
 454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 458:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 45c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 45f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 462:	39 d3                	cmp    %edx,%ebx
 464:	75 f2                	jne    458 <memmove+0x18>
  return vdst;
}
 466:	5b                   	pop    %ebx
 467:	5e                   	pop    %esi
 468:	5d                   	pop    %ebp
 469:	c3                   	ret    

0000046a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 46a:	b8 01 00 00 00       	mov    $0x1,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <exit>:
SYSCALL(exit)
 472:	b8 02 00 00 00       	mov    $0x2,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <wait>:
SYSCALL(wait)
 47a:	b8 03 00 00 00       	mov    $0x3,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <pipe>:
SYSCALL(pipe)
 482:	b8 04 00 00 00       	mov    $0x4,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <read>:
SYSCALL(read)
 48a:	b8 05 00 00 00       	mov    $0x5,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <write>:
SYSCALL(write)
 492:	b8 10 00 00 00       	mov    $0x10,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <close>:
SYSCALL(close)
 49a:	b8 15 00 00 00       	mov    $0x15,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <kill>:
SYSCALL(kill)
 4a2:	b8 06 00 00 00       	mov    $0x6,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <exec>:
SYSCALL(exec)
 4aa:	b8 07 00 00 00       	mov    $0x7,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <open>:
SYSCALL(open)
 4b2:	b8 0f 00 00 00       	mov    $0xf,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <mknod>:
SYSCALL(mknod)
 4ba:	b8 11 00 00 00       	mov    $0x11,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <unlink>:
SYSCALL(unlink)
 4c2:	b8 12 00 00 00       	mov    $0x12,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <fstat>:
SYSCALL(fstat)
 4ca:	b8 08 00 00 00       	mov    $0x8,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <link>:
SYSCALL(link)
 4d2:	b8 13 00 00 00       	mov    $0x13,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <mkdir>:
SYSCALL(mkdir)
 4da:	b8 14 00 00 00       	mov    $0x14,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <chdir>:
SYSCALL(chdir)
 4e2:	b8 09 00 00 00       	mov    $0x9,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <dup>:
SYSCALL(dup)
 4ea:	b8 0a 00 00 00       	mov    $0xa,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <getpid>:
SYSCALL(getpid)
 4f2:	b8 0b 00 00 00       	mov    $0xb,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <sbrk>:
SYSCALL(sbrk)
 4fa:	b8 0c 00 00 00       	mov    $0xc,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <sleep>:
SYSCALL(sleep)
 502:	b8 0d 00 00 00       	mov    $0xd,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <uptime>:
SYSCALL(uptime)
 50a:	b8 0e 00 00 00       	mov    $0xe,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <yield>:
SYSCALL(yield)
 512:	b8 16 00 00 00       	mov    $0x16,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <getlev>:
SYSCALL(getlev)
 51a:	b8 17 00 00 00       	mov    $0x17,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <set_cpu_share>:
SYSCALL(set_cpu_share)
 522:	b8 18 00 00 00       	mov    $0x18,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <thread_create>:
SYSCALL(thread_create)
 52a:	b8 19 00 00 00       	mov    $0x19,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <thread_exit>:
SYSCALL(thread_exit)
 532:	b8 1a 00 00 00       	mov    $0x1a,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <thread_join>:
SYSCALL(thread_join)
 53a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    
 542:	66 90                	xchg   %ax,%ax
 544:	66 90                	xchg   %ax,%ax
 546:	66 90                	xchg   %ax,%ax
 548:	66 90                	xchg   %ax,%ax
 54a:	66 90                	xchg   %ax,%ax
 54c:	66 90                	xchg   %ax,%ax
 54e:	66 90                	xchg   %ax,%ax

00000550 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	57                   	push   %edi
 554:	56                   	push   %esi
 555:	53                   	push   %ebx
 556:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 559:	85 d2                	test   %edx,%edx
{
 55b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 55e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 560:	79 76                	jns    5d8 <printint+0x88>
 562:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 566:	74 70                	je     5d8 <printint+0x88>
    x = -xx;
 568:	f7 d8                	neg    %eax
    neg = 1;
 56a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 571:	31 f6                	xor    %esi,%esi
 573:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 576:	eb 0a                	jmp    582 <printint+0x32>
 578:	90                   	nop
 579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 580:	89 fe                	mov    %edi,%esi
 582:	31 d2                	xor    %edx,%edx
 584:	8d 7e 01             	lea    0x1(%esi),%edi
 587:	f7 f1                	div    %ecx
 589:	0f b6 92 ec 09 00 00 	movzbl 0x9ec(%edx),%edx
  }while((x /= base) != 0);
 590:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 592:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 595:	75 e9                	jne    580 <printint+0x30>
  if(neg)
 597:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 59a:	85 c0                	test   %eax,%eax
 59c:	74 08                	je     5a6 <printint+0x56>
    buf[i++] = '-';
 59e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 5a3:	8d 7e 02             	lea    0x2(%esi),%edi
 5a6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 5aa:	8b 7d c0             	mov    -0x40(%ebp),%edi
 5ad:	8d 76 00             	lea    0x0(%esi),%esi
 5b0:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 5b3:	83 ec 04             	sub    $0x4,%esp
 5b6:	83 ee 01             	sub    $0x1,%esi
 5b9:	6a 01                	push   $0x1
 5bb:	53                   	push   %ebx
 5bc:	57                   	push   %edi
 5bd:	88 45 d7             	mov    %al,-0x29(%ebp)
 5c0:	e8 cd fe ff ff       	call   492 <write>

  while(--i >= 0)
 5c5:	83 c4 10             	add    $0x10,%esp
 5c8:	39 de                	cmp    %ebx,%esi
 5ca:	75 e4                	jne    5b0 <printint+0x60>
    putc(fd, buf[i]);
}
 5cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5cf:	5b                   	pop    %ebx
 5d0:	5e                   	pop    %esi
 5d1:	5f                   	pop    %edi
 5d2:	5d                   	pop    %ebp
 5d3:	c3                   	ret    
 5d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 5d8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 5df:	eb 90                	jmp    571 <printint+0x21>
 5e1:	eb 0d                	jmp    5f0 <printf>
 5e3:	90                   	nop
 5e4:	90                   	nop
 5e5:	90                   	nop
 5e6:	90                   	nop
 5e7:	90                   	nop
 5e8:	90                   	nop
 5e9:	90                   	nop
 5ea:	90                   	nop
 5eb:	90                   	nop
 5ec:	90                   	nop
 5ed:	90                   	nop
 5ee:	90                   	nop
 5ef:	90                   	nop

000005f0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5f0:	55                   	push   %ebp
 5f1:	89 e5                	mov    %esp,%ebp
 5f3:	57                   	push   %edi
 5f4:	56                   	push   %esi
 5f5:	53                   	push   %ebx
 5f6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5f9:	8b 75 0c             	mov    0xc(%ebp),%esi
 5fc:	0f b6 1e             	movzbl (%esi),%ebx
 5ff:	84 db                	test   %bl,%bl
 601:	0f 84 b3 00 00 00    	je     6ba <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 607:	8d 45 10             	lea    0x10(%ebp),%eax
 60a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 60d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 60f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 612:	eb 2f                	jmp    643 <printf+0x53>
 614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 618:	83 f8 25             	cmp    $0x25,%eax
 61b:	0f 84 a7 00 00 00    	je     6c8 <printf+0xd8>
  write(fd, &c, 1);
 621:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 624:	83 ec 04             	sub    $0x4,%esp
 627:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 62a:	6a 01                	push   $0x1
 62c:	50                   	push   %eax
 62d:	ff 75 08             	pushl  0x8(%ebp)
 630:	e8 5d fe ff ff       	call   492 <write>
 635:	83 c4 10             	add    $0x10,%esp
 638:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 63b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 63f:	84 db                	test   %bl,%bl
 641:	74 77                	je     6ba <printf+0xca>
    if(state == 0){
 643:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 645:	0f be cb             	movsbl %bl,%ecx
 648:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 64b:	74 cb                	je     618 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 64d:	83 ff 25             	cmp    $0x25,%edi
 650:	75 e6                	jne    638 <printf+0x48>
      if(c == 'd'){
 652:	83 f8 64             	cmp    $0x64,%eax
 655:	0f 84 05 01 00 00    	je     760 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 65b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 661:	83 f9 70             	cmp    $0x70,%ecx
 664:	74 72                	je     6d8 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 666:	83 f8 73             	cmp    $0x73,%eax
 669:	0f 84 99 00 00 00    	je     708 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 66f:	83 f8 63             	cmp    $0x63,%eax
 672:	0f 84 08 01 00 00    	je     780 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 678:	83 f8 25             	cmp    $0x25,%eax
 67b:	0f 84 ef 00 00 00    	je     770 <printf+0x180>
  write(fd, &c, 1);
 681:	8d 45 e7             	lea    -0x19(%ebp),%eax
 684:	83 ec 04             	sub    $0x4,%esp
 687:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 68b:	6a 01                	push   $0x1
 68d:	50                   	push   %eax
 68e:	ff 75 08             	pushl  0x8(%ebp)
 691:	e8 fc fd ff ff       	call   492 <write>
 696:	83 c4 0c             	add    $0xc,%esp
 699:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 69c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 69f:	6a 01                	push   $0x1
 6a1:	50                   	push   %eax
 6a2:	ff 75 08             	pushl  0x8(%ebp)
 6a5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6a8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 6aa:	e8 e3 fd ff ff       	call   492 <write>
  for(i = 0; fmt[i]; i++){
 6af:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 6b3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 6b6:	84 db                	test   %bl,%bl
 6b8:	75 89                	jne    643 <printf+0x53>
    }
  }
}
 6ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6bd:	5b                   	pop    %ebx
 6be:	5e                   	pop    %esi
 6bf:	5f                   	pop    %edi
 6c0:	5d                   	pop    %ebp
 6c1:	c3                   	ret    
 6c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 6c8:	bf 25 00 00 00       	mov    $0x25,%edi
 6cd:	e9 66 ff ff ff       	jmp    638 <printf+0x48>
 6d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 6d8:	83 ec 0c             	sub    $0xc,%esp
 6db:	b9 10 00 00 00       	mov    $0x10,%ecx
 6e0:	6a 00                	push   $0x0
 6e2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 6e5:	8b 45 08             	mov    0x8(%ebp),%eax
 6e8:	8b 17                	mov    (%edi),%edx
 6ea:	e8 61 fe ff ff       	call   550 <printint>
        ap++;
 6ef:	89 f8                	mov    %edi,%eax
 6f1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6f4:	31 ff                	xor    %edi,%edi
        ap++;
 6f6:	83 c0 04             	add    $0x4,%eax
 6f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 6fc:	e9 37 ff ff ff       	jmp    638 <printf+0x48>
 701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 708:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 70b:	8b 08                	mov    (%eax),%ecx
        ap++;
 70d:	83 c0 04             	add    $0x4,%eax
 710:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 713:	85 c9                	test   %ecx,%ecx
 715:	0f 84 8e 00 00 00    	je     7a9 <printf+0x1b9>
        while(*s != 0){
 71b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 71e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 720:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 722:	84 c0                	test   %al,%al
 724:	0f 84 0e ff ff ff    	je     638 <printf+0x48>
 72a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 72d:	89 de                	mov    %ebx,%esi
 72f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 732:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 735:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 738:	83 ec 04             	sub    $0x4,%esp
          s++;
 73b:	83 c6 01             	add    $0x1,%esi
 73e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 741:	6a 01                	push   $0x1
 743:	57                   	push   %edi
 744:	53                   	push   %ebx
 745:	e8 48 fd ff ff       	call   492 <write>
        while(*s != 0){
 74a:	0f b6 06             	movzbl (%esi),%eax
 74d:	83 c4 10             	add    $0x10,%esp
 750:	84 c0                	test   %al,%al
 752:	75 e4                	jne    738 <printf+0x148>
 754:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 757:	31 ff                	xor    %edi,%edi
 759:	e9 da fe ff ff       	jmp    638 <printf+0x48>
 75e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 760:	83 ec 0c             	sub    $0xc,%esp
 763:	b9 0a 00 00 00       	mov    $0xa,%ecx
 768:	6a 01                	push   $0x1
 76a:	e9 73 ff ff ff       	jmp    6e2 <printf+0xf2>
 76f:	90                   	nop
  write(fd, &c, 1);
 770:	83 ec 04             	sub    $0x4,%esp
 773:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 776:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 779:	6a 01                	push   $0x1
 77b:	e9 21 ff ff ff       	jmp    6a1 <printf+0xb1>
        putc(fd, *ap);
 780:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 783:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 786:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 788:	6a 01                	push   $0x1
        ap++;
 78a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 78d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 790:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 793:	50                   	push   %eax
 794:	ff 75 08             	pushl  0x8(%ebp)
 797:	e8 f6 fc ff ff       	call   492 <write>
        ap++;
 79c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 79f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7a2:	31 ff                	xor    %edi,%edi
 7a4:	e9 8f fe ff ff       	jmp    638 <printf+0x48>
          s = "(null)";
 7a9:	bb e4 09 00 00       	mov    $0x9e4,%ebx
        while(*s != 0){
 7ae:	b8 28 00 00 00       	mov    $0x28,%eax
 7b3:	e9 72 ff ff ff       	jmp    72a <printf+0x13a>
 7b8:	66 90                	xchg   %ax,%ax
 7ba:	66 90                	xchg   %ax,%ax
 7bc:	66 90                	xchg   %ax,%ax
 7be:	66 90                	xchg   %ax,%ax

000007c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7c0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c1:	a1 0c 0d 00 00       	mov    0xd0c,%eax
{
 7c6:	89 e5                	mov    %esp,%ebp
 7c8:	57                   	push   %edi
 7c9:	56                   	push   %esi
 7ca:	53                   	push   %ebx
 7cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 7ce:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 7d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d8:	39 c8                	cmp    %ecx,%eax
 7da:	8b 10                	mov    (%eax),%edx
 7dc:	73 32                	jae    810 <free+0x50>
 7de:	39 d1                	cmp    %edx,%ecx
 7e0:	72 04                	jb     7e6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e2:	39 d0                	cmp    %edx,%eax
 7e4:	72 32                	jb     818 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7e6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7e9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7ec:	39 fa                	cmp    %edi,%edx
 7ee:	74 30                	je     820 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 7f0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7f3:	8b 50 04             	mov    0x4(%eax),%edx
 7f6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7f9:	39 f1                	cmp    %esi,%ecx
 7fb:	74 3a                	je     837 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7fd:	89 08                	mov    %ecx,(%eax)
  freep = p;
 7ff:	a3 0c 0d 00 00       	mov    %eax,0xd0c
}
 804:	5b                   	pop    %ebx
 805:	5e                   	pop    %esi
 806:	5f                   	pop    %edi
 807:	5d                   	pop    %ebp
 808:	c3                   	ret    
 809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 810:	39 d0                	cmp    %edx,%eax
 812:	72 04                	jb     818 <free+0x58>
 814:	39 d1                	cmp    %edx,%ecx
 816:	72 ce                	jb     7e6 <free+0x26>
{
 818:	89 d0                	mov    %edx,%eax
 81a:	eb bc                	jmp    7d8 <free+0x18>
 81c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 820:	03 72 04             	add    0x4(%edx),%esi
 823:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 826:	8b 10                	mov    (%eax),%edx
 828:	8b 12                	mov    (%edx),%edx
 82a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 82d:	8b 50 04             	mov    0x4(%eax),%edx
 830:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 833:	39 f1                	cmp    %esi,%ecx
 835:	75 c6                	jne    7fd <free+0x3d>
    p->s.size += bp->s.size;
 837:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 83a:	a3 0c 0d 00 00       	mov    %eax,0xd0c
    p->s.size += bp->s.size;
 83f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 842:	8b 53 f8             	mov    -0x8(%ebx),%edx
 845:	89 10                	mov    %edx,(%eax)
}
 847:	5b                   	pop    %ebx
 848:	5e                   	pop    %esi
 849:	5f                   	pop    %edi
 84a:	5d                   	pop    %ebp
 84b:	c3                   	ret    
 84c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000850 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 850:	55                   	push   %ebp
 851:	89 e5                	mov    %esp,%ebp
 853:	57                   	push   %edi
 854:	56                   	push   %esi
 855:	53                   	push   %ebx
 856:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 859:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 85c:	8b 15 0c 0d 00 00    	mov    0xd0c,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 862:	8d 78 07             	lea    0x7(%eax),%edi
 865:	c1 ef 03             	shr    $0x3,%edi
 868:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 86b:	85 d2                	test   %edx,%edx
 86d:	0f 84 9d 00 00 00    	je     910 <malloc+0xc0>
 873:	8b 02                	mov    (%edx),%eax
 875:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 878:	39 cf                	cmp    %ecx,%edi
 87a:	76 6c                	jbe    8e8 <malloc+0x98>
 87c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 882:	bb 00 10 00 00       	mov    $0x1000,%ebx
 887:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 88a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 891:	eb 0e                	jmp    8a1 <malloc+0x51>
 893:	90                   	nop
 894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 898:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 89a:	8b 48 04             	mov    0x4(%eax),%ecx
 89d:	39 f9                	cmp    %edi,%ecx
 89f:	73 47                	jae    8e8 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8a1:	39 05 0c 0d 00 00    	cmp    %eax,0xd0c
 8a7:	89 c2                	mov    %eax,%edx
 8a9:	75 ed                	jne    898 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 8ab:	83 ec 0c             	sub    $0xc,%esp
 8ae:	56                   	push   %esi
 8af:	e8 46 fc ff ff       	call   4fa <sbrk>
  if(p == (char*)-1)
 8b4:	83 c4 10             	add    $0x10,%esp
 8b7:	83 f8 ff             	cmp    $0xffffffff,%eax
 8ba:	74 1c                	je     8d8 <malloc+0x88>
  hp->s.size = nu;
 8bc:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 8bf:	83 ec 0c             	sub    $0xc,%esp
 8c2:	83 c0 08             	add    $0x8,%eax
 8c5:	50                   	push   %eax
 8c6:	e8 f5 fe ff ff       	call   7c0 <free>
  return freep;
 8cb:	8b 15 0c 0d 00 00    	mov    0xd0c,%edx
      if((p = morecore(nunits)) == 0)
 8d1:	83 c4 10             	add    $0x10,%esp
 8d4:	85 d2                	test   %edx,%edx
 8d6:	75 c0                	jne    898 <malloc+0x48>
        return 0;
  }
}
 8d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 8db:	31 c0                	xor    %eax,%eax
}
 8dd:	5b                   	pop    %ebx
 8de:	5e                   	pop    %esi
 8df:	5f                   	pop    %edi
 8e0:	5d                   	pop    %ebp
 8e1:	c3                   	ret    
 8e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 8e8:	39 cf                	cmp    %ecx,%edi
 8ea:	74 54                	je     940 <malloc+0xf0>
        p->s.size -= nunits;
 8ec:	29 f9                	sub    %edi,%ecx
 8ee:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 8f1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 8f4:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 8f7:	89 15 0c 0d 00 00    	mov    %edx,0xd0c
}
 8fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 900:	83 c0 08             	add    $0x8,%eax
}
 903:	5b                   	pop    %ebx
 904:	5e                   	pop    %esi
 905:	5f                   	pop    %edi
 906:	5d                   	pop    %ebp
 907:	c3                   	ret    
 908:	90                   	nop
 909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 910:	c7 05 0c 0d 00 00 10 	movl   $0xd10,0xd0c
 917:	0d 00 00 
 91a:	c7 05 10 0d 00 00 10 	movl   $0xd10,0xd10
 921:	0d 00 00 
    base.s.size = 0;
 924:	b8 10 0d 00 00       	mov    $0xd10,%eax
 929:	c7 05 14 0d 00 00 00 	movl   $0x0,0xd14
 930:	00 00 00 
 933:	e9 44 ff ff ff       	jmp    87c <malloc+0x2c>
 938:	90                   	nop
 939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 940:	8b 08                	mov    (%eax),%ecx
 942:	89 0a                	mov    %ecx,(%edx)
 944:	eb b1                	jmp    8f7 <malloc+0xa7>
