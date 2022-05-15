
_test_thread2:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  "stridetest",
};

int
main(int argc, char *argv[])
{
       0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
       4:	83 e4 f0             	and    $0xfffffff0,%esp
       7:	ff 71 fc             	pushl  -0x4(%ecx)
       a:	55                   	push   %ebp
       b:	89 e5                	mov    %esp,%ebp
       d:	57                   	push   %edi
       e:	56                   	push   %esi
       f:	53                   	push   %ebx
      10:	51                   	push   %ecx
      11:	83 ec 18             	sub    $0x18,%esp
      14:	8b 31                	mov    (%ecx),%esi
      16:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;
  int ret;
  int pid;
  int start = 0;
  int end = NTEST-1;
  if (argc >= 2)
      19:	83 fe 01             	cmp    $0x1,%esi
      1c:	0f 8f eb 00 00 00    	jg     10d <main+0x10d>
  int end = NTEST-1;
      22:	be 0d 00 00 00       	mov    $0xd,%esi
  int start = 0;
      27:	31 db                	xor    %ebx,%ebx
      write(gpipe[1], (char*)&ret, sizeof(ret));
      close(gpipe[1]);
      exit();
    } else{
      close(gpipe[1]);
      if (wait() == -1 || read(gpipe[0], (char*)&ret, sizeof(ret)) == -1 || ret != 0){
      29:	8d 7d e4             	lea    -0x1c(%ebp),%edi
      2c:	e9 9e 00 00 00       	jmp    cf <main+0xcf>
      31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ret = 0;
      38:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if ((pid = fork()) < 0){
      3f:	e8 36 13 00 00       	call   137a <fork>
      44:	85 c0                	test   %eax,%eax
      46:	0f 88 10 01 00 00    	js     15c <main+0x15c>
    if (pid == 0){
      4c:	0f 84 1d 01 00 00    	je     16f <main+0x16f>
      close(gpipe[1]);
      52:	83 ec 0c             	sub    $0xc,%esp
      55:	ff 35 0c 23 00 00    	pushl  0x230c
      5b:	e8 4a 13 00 00       	call   13aa <close>
      if (wait() == -1 || read(gpipe[0], (char*)&ret, sizeof(ret)) == -1 || ret != 0){
      60:	e8 25 13 00 00       	call   138a <wait>
      65:	83 c4 10             	add    $0x10,%esp
      68:	83 f8 ff             	cmp    $0xffffffff,%eax
      6b:	0f 84 d2 00 00 00    	je     143 <main+0x143>
      71:	83 ec 04             	sub    $0x4,%esp
      74:	6a 04                	push   $0x4
      76:	57                   	push   %edi
      77:	ff 35 08 23 00 00    	pushl  0x2308
      7d:	e8 18 13 00 00       	call   139a <read>
      82:	83 c4 10             	add    $0x10,%esp
      85:	83 f8 ff             	cmp    $0xffffffff,%eax
      88:	0f 84 b5 00 00 00    	je     143 <main+0x143>
      8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      91:	85 c0                	test   %eax,%eax
      93:	0f 85 aa 00 00 00    	jne    143 <main+0x143>
        printf(1,"%d. %s panic\n", i, testname[i]);
        exit();
      }
      close(gpipe[0]);
      99:	83 ec 0c             	sub    $0xc,%esp
      9c:	ff 35 08 23 00 00    	pushl  0x2308
      a2:	e8 03 13 00 00       	call   13aa <close>
    }
    printf(1,"%d. %s finish\n", i, testname[i]);
      a7:	ff 34 9d 80 22 00 00 	pushl  0x2280(,%ebx,4)
      ae:	53                   	push   %ebx
  for (i = start; i <= end; i++){
      af:	83 c3 01             	add    $0x1,%ebx
    printf(1,"%d. %s finish\n", i, testname[i]);
      b2:	68 f4 19 00 00       	push   $0x19f4
      b7:	6a 01                	push   $0x1
      b9:	e8 42 14 00 00       	call   1500 <printf>
    sleep(100);
      be:	83 c4 14             	add    $0x14,%esp
      c1:	6a 64                	push   $0x64
      c3:	e8 4a 13 00 00       	call   1412 <sleep>
  for (i = start; i <= end; i++){
      c8:	83 c4 10             	add    $0x10,%esp
      cb:	39 f3                	cmp    %esi,%ebx
      cd:	7f 6f                	jg     13e <main+0x13e>
    printf(1,"%d. %s start\n", i, testname[i]);
      cf:	ff 34 9d 80 22 00 00 	pushl  0x2280(,%ebx,4)
      d6:	53                   	push   %ebx
      d7:	68 c0 19 00 00       	push   $0x19c0
      dc:	6a 01                	push   $0x1
      de:	e8 1d 14 00 00       	call   1500 <printf>
    if (pipe(gpipe) < 0){
      e3:	c7 04 24 08 23 00 00 	movl   $0x2308,(%esp)
      ea:	e8 a3 12 00 00       	call   1392 <pipe>
      ef:	83 c4 10             	add    $0x10,%esp
      f2:	85 c0                	test   %eax,%eax
      f4:	0f 89 3e ff ff ff    	jns    38 <main+0x38>
      printf(1,"pipe panic\n");
      fa:	53                   	push   %ebx
      fb:	53                   	push   %ebx
      fc:	68 ce 19 00 00       	push   $0x19ce
     101:	6a 01                	push   $0x1
     103:	e8 f8 13 00 00       	call   1500 <printf>
      exit();
     108:	e8 75 12 00 00       	call   1382 <exit>
    start = atoi(argv[1]);
     10d:	83 ec 0c             	sub    $0xc,%esp
     110:	ff 77 04             	pushl  0x4(%edi)
     113:	e8 f8 11 00 00       	call   1310 <atoi>
  if (argc >= 3)
     118:	83 c4 10             	add    $0x10,%esp
     11b:	83 fe 02             	cmp    $0x2,%esi
    start = atoi(argv[1]);
     11e:	89 c3                	mov    %eax,%ebx
  if (argc >= 3)
     120:	0f 84 86 00 00 00    	je     1ac <main+0x1ac>
    end = atoi(argv[2]);
     126:	83 ec 0c             	sub    $0xc,%esp
     129:	ff 77 08             	pushl  0x8(%edi)
     12c:	e8 df 11 00 00       	call   1310 <atoi>
     131:	83 c4 10             	add    $0x10,%esp
     134:	89 c6                	mov    %eax,%esi
  for (i = start; i <= end; i++){
     136:	39 de                	cmp    %ebx,%esi
     138:	0f 8d eb fe ff ff    	jge    29 <main+0x29>
  }
  exit();
     13e:	e8 3f 12 00 00       	call   1382 <exit>
        printf(1,"%d. %s panic\n", i, testname[i]);
     143:	ff 34 9d 80 22 00 00 	pushl  0x2280(,%ebx,4)
     14a:	53                   	push   %ebx
     14b:	68 e6 19 00 00       	push   $0x19e6
     150:	6a 01                	push   $0x1
     152:	e8 a9 13 00 00       	call   1500 <printf>
        exit();
     157:	e8 26 12 00 00       	call   1382 <exit>
      printf(1,"fork panic\n");
     15c:	51                   	push   %ecx
     15d:	51                   	push   %ecx
     15e:	68 da 19 00 00       	push   $0x19da
     163:	6a 01                	push   $0x1
     165:	e8 96 13 00 00       	call   1500 <printf>
      exit();
     16a:	e8 13 12 00 00       	call   1382 <exit>
      close(gpipe[0]);
     16f:	83 ec 0c             	sub    $0xc,%esp
     172:	ff 35 08 23 00 00    	pushl  0x2308
     178:	e8 2d 12 00 00       	call   13aa <close>
      ret = testfunc[i]();
     17d:	ff 14 9d c0 22 00 00 	call   *0x22c0(,%ebx,4)
     184:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      write(gpipe[1], (char*)&ret, sizeof(ret));
     187:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     18a:	83 c4 0c             	add    $0xc,%esp
     18d:	6a 04                	push   $0x4
     18f:	50                   	push   %eax
     190:	ff 35 0c 23 00 00    	pushl  0x230c
     196:	e8 07 12 00 00       	call   13a2 <write>
      close(gpipe[1]);
     19b:	5a                   	pop    %edx
     19c:	ff 35 0c 23 00 00    	pushl  0x230c
     1a2:	e8 03 12 00 00       	call   13aa <close>
      exit();
     1a7:	e8 d6 11 00 00       	call   1382 <exit>
  int end = NTEST-1;
     1ac:	be 0d 00 00 00       	mov    $0xd,%esi
     1b1:	eb 83                	jmp    136 <main+0x136>
     1b3:	66 90                	xchg   %ax,%ax
     1b5:	66 90                	xchg   %ax,%ax
     1b7:	66 90                	xchg   %ax,%ax
     1b9:	66 90                	xchg   %ax,%ax
     1bb:	66 90                	xchg   %ax,%ax
     1bd:	66 90                	xchg   %ax,%ax
     1bf:	90                   	nop

000001c0 <nop>:
}

// ============================================================================
void nop(){ }
     1c0:	55                   	push   %ebp
     1c1:	89 e5                	mov    %esp,%ebp
     1c3:	5d                   	pop    %ebp
     1c4:	c3                   	ret    
     1c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     1c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001d0 <racingthreadmain>:

void*
racingthreadmain(void *arg)
{
     1d0:	55                   	push   %ebp
  int tid = (int) arg;
     1d1:	ba 80 96 98 00       	mov    $0x989680,%edx
{
     1d6:	89 e5                	mov    %esp,%ebp
     1d8:	83 ec 08             	sub    $0x8,%esp
     1db:	90                   	nop
     1dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int i;
  int tmp;
  for (i = 0; i < 10000000; i++){
    tmp = gcnt;
     1e0:	a1 04 23 00 00       	mov    0x2304,%eax
    tmp++;
     1e5:	83 c0 01             	add    $0x1,%eax
	asm volatile("call %P0"::"i"(nop));
     1e8:	e8 d3 ff ff ff       	call   1c0 <nop>
  for (i = 0; i < 10000000; i++){
     1ed:	83 ea 01             	sub    $0x1,%edx
    gcnt = tmp;
     1f0:	a3 04 23 00 00       	mov    %eax,0x2304
  for (i = 0; i < 10000000; i++){
     1f5:	75 e9                	jne    1e0 <racingthreadmain+0x10>
  }
  thread_exit((void *)(tid+1));
     1f7:	8b 45 08             	mov    0x8(%ebp),%eax
     1fa:	83 ec 0c             	sub    $0xc,%esp
     1fd:	83 c0 01             	add    $0x1,%eax
     200:	50                   	push   %eax
     201:	e8 3c 12 00 00       	call   1442 <thread_exit>
     206:	8d 76 00             	lea    0x0(%esi),%esi
     209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000210 <basicthreadmain>:
}

// ============================================================================
void*
basicthreadmain(void *arg)
{
     210:	55                   	push   %ebp
     211:	89 e5                	mov    %esp,%ebp
     213:	57                   	push   %edi
     214:	56                   	push   %esi
     215:	53                   	push   %ebx
  int tid = (int) arg;
  int i;
  for (i = 0; i < 100000000; i++){
    if (i % 20000000 == 0){
     216:	bf 6b ca 5f 6b       	mov    $0x6b5fca6b,%edi
  for (i = 0; i < 100000000; i++){
     21b:	31 db                	xor    %ebx,%ebx
{
     21d:	83 ec 0c             	sub    $0xc,%esp
     220:	8b 75 08             	mov    0x8(%ebp),%esi
     223:	eb 0e                	jmp    233 <basicthreadmain+0x23>
     225:	8d 76 00             	lea    0x0(%esi),%esi
  for (i = 0; i < 100000000; i++){
     228:	83 c3 01             	add    $0x1,%ebx
     22b:	81 fb 00 e1 f5 05    	cmp    $0x5f5e100,%ebx
     231:	74 2f                	je     262 <basicthreadmain+0x52>
    if (i % 20000000 == 0){
     233:	89 d8                	mov    %ebx,%eax
     235:	f7 e7                	mul    %edi
     237:	c1 ea 17             	shr    $0x17,%edx
     23a:	69 d2 00 2d 31 01    	imul   $0x1312d00,%edx,%edx
     240:	39 d3                	cmp    %edx,%ebx
     242:	75 e4                	jne    228 <basicthreadmain+0x18>
      printf(1, "%d", tid);
     244:	83 ec 04             	sub    $0x4,%esp
  for (i = 0; i < 100000000; i++){
     247:	83 c3 01             	add    $0x1,%ebx
      printf(1, "%d", tid);
     24a:	56                   	push   %esi
     24b:	68 58 18 00 00       	push   $0x1858
     250:	6a 01                	push   $0x1
     252:	e8 a9 12 00 00       	call   1500 <printf>
     257:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < 100000000; i++){
     25a:	81 fb 00 e1 f5 05    	cmp    $0x5f5e100,%ebx
     260:	75 d1                	jne    233 <basicthreadmain+0x23>
    }
  }
  thread_exit((void *)(tid+1));
     262:	83 ec 0c             	sub    $0xc,%esp
     265:	83 c6 01             	add    $0x1,%esi
     268:	56                   	push   %esi
     269:	e8 d4 11 00 00       	call   1442 <thread_exit>
     26e:	66 90                	xchg   %ax,%ax

00000270 <jointhreadmain>:

// ============================================================================

void*
jointhreadmain(void *arg)
{
     270:	55                   	push   %ebp
     271:	89 e5                	mov    %esp,%ebp
     273:	83 ec 14             	sub    $0x14,%esp
  int val = (int)arg;
  sleep(200);
     276:	68 c8 00 00 00       	push   $0xc8
     27b:	e8 92 11 00 00       	call   1412 <sleep>
  printf(1, "thread_exit...\n");
     280:	58                   	pop    %eax
     281:	5a                   	pop    %edx
     282:	68 5b 18 00 00       	push   $0x185b
     287:	6a 01                	push   $0x1
     289:	e8 72 12 00 00       	call   1500 <printf>
  thread_exit((void *)(val*2));
     28e:	8b 45 08             	mov    0x8(%ebp),%eax
     291:	01 c0                	add    %eax,%eax
     293:	89 04 24             	mov    %eax,(%esp)
     296:	e8 a7 11 00 00       	call   1442 <thread_exit>
     29b:	90                   	nop
     29c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002a0 <stressthreadmain>:

// ============================================================================

void*
stressthreadmain(void *arg)
{
     2a0:	55                   	push   %ebp
     2a1:	89 e5                	mov    %esp,%ebp
     2a3:	83 ec 14             	sub    $0x14,%esp
  thread_exit(0);
     2a6:	6a 00                	push   $0x0
     2a8:	e8 95 11 00 00       	call   1442 <thread_exit>
     2ad:	8d 76 00             	lea    0x0(%esi),%esi

000002b0 <exitthreadmain>:

// ============================================================================

void*
exitthreadmain(void *arg)
{
     2b0:	55                   	push   %ebp
     2b1:	89 e5                	mov    %esp,%ebp
     2b3:	83 ec 08             	sub    $0x8,%esp
     2b6:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;
  if ((int)arg == 1){
     2b9:	83 f8 01             	cmp    $0x1,%eax
     2bc:	74 12                	je     2d0 <exitthreadmain+0x20>
    while(1){
      printf(1, "thread_exit ...\n");
      for (i = 0; i < 5000000; i++);
    }
  } else if ((int)arg == 2){
     2be:	83 f8 02             	cmp    $0x2,%eax
     2c1:	74 21                	je     2e4 <exitthreadmain+0x34>
    exit();
  }
  thread_exit(0);
     2c3:	83 ec 0c             	sub    $0xc,%esp
     2c6:	6a 00                	push   $0x0
     2c8:	e8 75 11 00 00       	call   1442 <thread_exit>
     2cd:	8d 76 00             	lea    0x0(%esi),%esi
      printf(1, "thread_exit ...\n");
     2d0:	83 ec 08             	sub    $0x8,%esp
     2d3:	68 6b 18 00 00       	push   $0x186b
     2d8:	6a 01                	push   $0x1
     2da:	e8 21 12 00 00       	call   1500 <printf>
     2df:	83 c4 10             	add    $0x10,%esp
     2e2:	eb ec                	jmp    2d0 <exitthreadmain+0x20>
    exit();
     2e4:	e8 99 10 00 00       	call   1382 <exit>
     2e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002f0 <forkthreadmain>:

// ============================================================================

void*
forkthreadmain(void *arg)
{
     2f0:	55                   	push   %ebp
     2f1:	89 e5                	mov    %esp,%ebp
     2f3:	83 ec 08             	sub    $0x8,%esp
  int pid;
  if ((pid = fork()) == -1){
     2f6:	e8 7f 10 00 00       	call   137a <fork>
     2fb:	83 f8 ff             	cmp    $0xffffffff,%eax
     2fe:	74 3c                	je     33c <forkthreadmain+0x4c>
    printf(1, "panic at fork in forktest\n");
    exit();
  } else if (pid == 0){
     300:	85 c0                	test   %eax,%eax
     302:	74 25                	je     329 <forkthreadmain+0x39>
    printf(1, "child\n");
    exit();
  } else{
    printf(1, "parent\n");
     304:	52                   	push   %edx
     305:	52                   	push   %edx
     306:	68 9e 18 00 00       	push   $0x189e
     30b:	6a 01                	push   $0x1
     30d:	e8 ee 11 00 00       	call   1500 <printf>
    if (wait() == -1){
     312:	e8 73 10 00 00       	call   138a <wait>
     317:	83 c4 10             	add    $0x10,%esp
     31a:	83 c0 01             	add    $0x1,%eax
     31d:	74 30                	je     34f <forkthreadmain+0x5f>
      printf(1, "panic at wait in forktest\n");
      exit();
    }
  }
  thread_exit(0);
     31f:	83 ec 0c             	sub    $0xc,%esp
     322:	6a 00                	push   $0x0
     324:	e8 19 11 00 00       	call   1442 <thread_exit>
    printf(1, "child\n");
     329:	51                   	push   %ecx
     32a:	51                   	push   %ecx
     32b:	68 97 18 00 00       	push   $0x1897
     330:	6a 01                	push   $0x1
     332:	e8 c9 11 00 00       	call   1500 <printf>
    exit();
     337:	e8 46 10 00 00       	call   1382 <exit>
    printf(1, "panic at fork in forktest\n");
     33c:	50                   	push   %eax
     33d:	50                   	push   %eax
     33e:	68 7c 18 00 00       	push   $0x187c
     343:	6a 01                	push   $0x1
     345:	e8 b6 11 00 00       	call   1500 <printf>
    exit();
     34a:	e8 33 10 00 00       	call   1382 <exit>
      printf(1, "panic at wait in forktest\n");
     34f:	50                   	push   %eax
     350:	50                   	push   %eax
     351:	68 a6 18 00 00       	push   $0x18a6
     356:	6a 01                	push   $0x1
     358:	e8 a3 11 00 00       	call   1500 <printf>
      exit();
     35d:	e8 20 10 00 00       	call   1382 <exit>
     362:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000370 <sleepthreadmain>:

// ============================================================================

void*
sleepthreadmain(void *arg)
{
     370:	55                   	push   %ebp
     371:	89 e5                	mov    %esp,%ebp
     373:	83 ec 14             	sub    $0x14,%esp
  sleep(1000000);
     376:	68 40 42 0f 00       	push   $0xf4240
     37b:	e8 92 10 00 00       	call   1412 <sleep>
  thread_exit(0);
     380:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     387:	e8 b6 10 00 00       	call   1442 <thread_exit>
     38c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000390 <exittest2>:
{
     390:	55                   	push   %ebp
     391:	89 e5                	mov    %esp,%ebp
     393:	56                   	push   %esi
     394:	53                   	push   %ebx
     395:	8d 75 f8             	lea    -0x8(%ebp),%esi
     398:	8d 5d d0             	lea    -0x30(%ebp),%ebx
     39b:	83 ec 30             	sub    $0x30,%esp
    if (thread_create(&threads[i], exitthreadmain, (void*)2) != 0){
     39e:	83 ec 04             	sub    $0x4,%esp
     3a1:	6a 02                	push   $0x2
     3a3:	68 b0 02 00 00       	push   $0x2b0
     3a8:	53                   	push   %ebx
     3a9:	e8 8c 10 00 00       	call   143a <thread_create>
     3ae:	83 c4 10             	add    $0x10,%esp
     3b1:	85 c0                	test   %eax,%eax
     3b3:	75 0b                	jne    3c0 <exittest2+0x30>
     3b5:	83 c3 04             	add    $0x4,%ebx
  for (i = 0; i < NUM_THREAD; i++){
     3b8:	39 f3                	cmp    %esi,%ebx
     3ba:	75 e2                	jne    39e <exittest2+0xe>
     3bc:	eb fe                	jmp    3bc <exittest2+0x2c>
     3be:	66 90                	xchg   %ax,%ax
      printf(1, "panic at thread_create\n");
     3c0:	83 ec 08             	sub    $0x8,%esp
     3c3:	68 c1 18 00 00       	push   $0x18c1
     3c8:	6a 01                	push   $0x1
     3ca:	e8 31 11 00 00       	call   1500 <printf>
}
     3cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
     3d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     3d7:	5b                   	pop    %ebx
     3d8:	5e                   	pop    %esi
     3d9:	5d                   	pop    %ebp
     3da:	c3                   	ret    
     3db:	90                   	nop
     3dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003e0 <jointest2>:
{
     3e0:	55                   	push   %ebp
     3e1:	89 e5                	mov    %esp,%ebp
     3e3:	56                   	push   %esi
     3e4:	53                   	push   %ebx
     3e5:	8d 75 cc             	lea    -0x34(%ebp),%esi
  for (i = 1; i <= NUM_THREAD; i++){
     3e8:	bb 01 00 00 00       	mov    $0x1,%ebx
{
     3ed:	83 ec 40             	sub    $0x40,%esp
    if (thread_create(&threads[i-1], jointhreadmain, (void*)(i)) != 0){
     3f0:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
     3f3:	83 ec 04             	sub    $0x4,%esp
     3f6:	53                   	push   %ebx
     3f7:	68 70 02 00 00       	push   $0x270
     3fc:	50                   	push   %eax
     3fd:	e8 38 10 00 00       	call   143a <thread_create>
     402:	83 c4 10             	add    $0x10,%esp
     405:	85 c0                	test   %eax,%eax
     407:	75 77                	jne    480 <jointest2+0xa0>
  for (i = 1; i <= NUM_THREAD; i++){
     409:	83 c3 01             	add    $0x1,%ebx
     40c:	83 fb 0b             	cmp    $0xb,%ebx
     40f:	75 df                	jne    3f0 <jointest2+0x10>
  sleep(500);
     411:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "thread_join!!!\n");
     414:	bb 02 00 00 00       	mov    $0x2,%ebx
  sleep(500);
     419:	68 f4 01 00 00       	push   $0x1f4
     41e:	e8 ef 0f 00 00       	call   1412 <sleep>
  printf(1, "thread_join!!!\n");
     423:	58                   	pop    %eax
     424:	5a                   	pop    %edx
     425:	68 d9 18 00 00       	push   $0x18d9
     42a:	6a 01                	push   $0x1
     42c:	e8 cf 10 00 00       	call   1500 <printf>
     431:	83 c4 10             	add    $0x10,%esp
     434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
     438:	83 ec 08             	sub    $0x8,%esp
     43b:	56                   	push   %esi
     43c:	ff 74 5d cc          	pushl  -0x34(%ebp,%ebx,2)
     440:	e8 05 10 00 00       	call   144a <thread_join>
     445:	83 c4 10             	add    $0x10,%esp
     448:	85 c0                	test   %eax,%eax
     44a:	75 54                	jne    4a0 <jointest2+0xc0>
     44c:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
     44f:	75 4f                	jne    4a0 <jointest2+0xc0>
     451:	83 c3 02             	add    $0x2,%ebx
  for (i = 1; i <= NUM_THREAD; i++){
     454:	83 fb 16             	cmp    $0x16,%ebx
     457:	75 df                	jne    438 <jointest2+0x58>
  printf(1,"\n");
     459:	83 ec 08             	sub    $0x8,%esp
     45c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
     45f:	68 e7 18 00 00       	push   $0x18e7
     464:	6a 01                	push   $0x1
     466:	e8 95 10 00 00       	call   1500 <printf>
  return 0;
     46b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     46e:	83 c4 10             	add    $0x10,%esp
}
     471:	8d 65 f8             	lea    -0x8(%ebp),%esp
     474:	5b                   	pop    %ebx
     475:	5e                   	pop    %esi
     476:	5d                   	pop    %ebp
     477:	c3                   	ret    
     478:	90                   	nop
     479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "panic at thread_create\n");
     480:	83 ec 08             	sub    $0x8,%esp
     483:	68 c1 18 00 00       	push   $0x18c1
     488:	6a 01                	push   $0x1
     48a:	e8 71 10 00 00       	call   1500 <printf>
      return -1;
     48f:	83 c4 10             	add    $0x10,%esp
}
     492:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return -1;
     495:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     49a:	5b                   	pop    %ebx
     49b:	5e                   	pop    %esi
     49c:	5d                   	pop    %ebp
     49d:	c3                   	ret    
     49e:	66 90                	xchg   %ax,%ax
      printf(1, "panic at thread_join\n");
     4a0:	83 ec 08             	sub    $0x8,%esp
     4a3:	68 e9 18 00 00       	push   $0x18e9
     4a8:	6a 01                	push   $0x1
     4aa:	e8 51 10 00 00       	call   1500 <printf>
      return -1;
     4af:	83 c4 10             	add    $0x10,%esp
}
     4b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return -1;
     4b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     4ba:	5b                   	pop    %ebx
     4bb:	5e                   	pop    %esi
     4bc:	5d                   	pop    %ebp
     4bd:	c3                   	ret    
     4be:	66 90                	xchg   %ax,%ax

000004c0 <pipetest>:
{
     4c0:	55                   	push   %ebp
     4c1:	89 e5                	mov    %esp,%ebp
     4c3:	57                   	push   %edi
     4c4:	56                   	push   %esi
     4c5:	53                   	push   %ebx
  if (pipe(fd) < 0){
     4c6:	8d 45 ac             	lea    -0x54(%ebp),%eax
{
     4c9:	83 ec 68             	sub    $0x68,%esp
  if (pipe(fd) < 0){
     4cc:	50                   	push   %eax
     4cd:	e8 c0 0e 00 00       	call   1392 <pipe>
     4d2:	83 c4 10             	add    $0x10,%esp
     4d5:	85 c0                	test   %eax,%eax
     4d7:	0f 88 94 01 00 00    	js     671 <pipetest+0x1b1>
  arg[1] = fd[0];
     4dd:	8b 45 ac             	mov    -0x54(%ebp),%eax
     4e0:	89 45 b8             	mov    %eax,-0x48(%ebp)
  arg[2] = fd[1];
     4e3:	8b 45 b0             	mov    -0x50(%ebp),%eax
     4e6:	89 45 bc             	mov    %eax,-0x44(%ebp)
  if ((pid = fork()) < 0){
     4e9:	e8 8c 0e 00 00       	call   137a <fork>
     4ee:	85 c0                	test   %eax,%eax
     4f0:	0f 88 94 01 00 00    	js     68a <pipetest+0x1ca>
  } else if (pid == 0){
     4f6:	75 78                	jne    570 <pipetest+0xb0>
    close(fd[0]);
     4f8:	83 ec 0c             	sub    $0xc,%esp
     4fb:	8d 5d c0             	lea    -0x40(%ebp),%ebx
     4fe:	ff 75 ac             	pushl  -0x54(%ebp)
     501:	8d 75 b4             	lea    -0x4c(%ebp),%esi
     504:	e8 a1 0e 00 00       	call   13aa <close>
    arg[0] = 0;
     509:	89 df                	mov    %ebx,%edi
     50b:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
     512:	83 c4 10             	add    $0x10,%esp
     515:	8d 76 00             	lea    0x0(%esi),%esi
      if (thread_create(&threads[i], pipethreadmain, (void*)arg) != 0){
     518:	83 ec 04             	sub    $0x4,%esp
     51b:	56                   	push   %esi
     51c:	68 b0 07 00 00       	push   $0x7b0
     521:	57                   	push   %edi
     522:	e8 13 0f 00 00       	call   143a <thread_create>
     527:	83 c4 10             	add    $0x10,%esp
     52a:	85 c0                	test   %eax,%eax
     52c:	0f 85 f6 00 00 00    	jne    628 <pipetest+0x168>
    for (i = 0; i < NUM_THREAD; i++){
     532:	8d 45 e8             	lea    -0x18(%ebp),%eax
     535:	83 c7 04             	add    $0x4,%edi
     538:	39 c7                	cmp    %eax,%edi
     53a:	75 dc                	jne    518 <pipetest+0x58>
     53c:	8d 75 a8             	lea    -0x58(%ebp),%esi
     53f:	90                   	nop
      if (thread_join(threads[i], &retval) != 0){
     540:	83 ec 08             	sub    $0x8,%esp
     543:	56                   	push   %esi
     544:	ff 33                	pushl  (%ebx)
     546:	e8 ff 0e 00 00       	call   144a <thread_join>
     54b:	83 c4 10             	add    $0x10,%esp
     54e:	85 c0                	test   %eax,%eax
     550:	0f 85 fa 00 00 00    	jne    650 <pipetest+0x190>
     556:	83 c3 04             	add    $0x4,%ebx
    for (i = 0; i < NUM_THREAD; i++){
     559:	39 df                	cmp    %ebx,%edi
     55b:	75 e3                	jne    540 <pipetest+0x80>
    close(fd[1]);
     55d:	83 ec 0c             	sub    $0xc,%esp
     560:	ff 75 b0             	pushl  -0x50(%ebp)
     563:	e8 42 0e 00 00       	call   13aa <close>
    exit();
     568:	e8 15 0e 00 00       	call   1382 <exit>
     56d:	8d 76 00             	lea    0x0(%esi),%esi
    close(fd[1]);
     570:	83 ec 0c             	sub    $0xc,%esp
     573:	ff 75 b0             	pushl  -0x50(%ebp)
     576:	8d 7d e8             	lea    -0x18(%ebp),%edi
     579:	8d 75 b4             	lea    -0x4c(%ebp),%esi
     57c:	e8 29 0e 00 00       	call   13aa <close>
     581:	8d 45 c0             	lea    -0x40(%ebp),%eax
    arg[0] = 1;
     584:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
    gcnt = 0;
     58b:	c7 05 04 23 00 00 00 	movl   $0x0,0x2304
     592:	00 00 00 
     595:	83 c4 10             	add    $0x10,%esp
     598:	89 45 a4             	mov    %eax,-0x5c(%ebp)
     59b:	89 c3                	mov    %eax,%ebx
     59d:	8d 76 00             	lea    0x0(%esi),%esi
      if (thread_create(&threads[i], pipethreadmain, (void*)arg) != 0){
     5a0:	83 ec 04             	sub    $0x4,%esp
     5a3:	56                   	push   %esi
     5a4:	68 b0 07 00 00       	push   $0x7b0
     5a9:	53                   	push   %ebx
     5aa:	e8 8b 0e 00 00       	call   143a <thread_create>
     5af:	83 c4 10             	add    $0x10,%esp
     5b2:	85 c0                	test   %eax,%eax
     5b4:	75 72                	jne    628 <pipetest+0x168>
     5b6:	83 c3 04             	add    $0x4,%ebx
    for (i = 0; i < NUM_THREAD; i++){
     5b9:	39 fb                	cmp    %edi,%ebx
     5bb:	75 e3                	jne    5a0 <pipetest+0xe0>
     5bd:	8d 75 a8             	lea    -0x58(%ebp),%esi
      if (thread_join(threads[i], &retval) != 0){
     5c0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
     5c3:	83 ec 08             	sub    $0x8,%esp
     5c6:	56                   	push   %esi
     5c7:	ff 30                	pushl  (%eax)
     5c9:	e8 7c 0e 00 00       	call   144a <thread_join>
     5ce:	83 c4 10             	add    $0x10,%esp
     5d1:	85 c0                	test   %eax,%eax
     5d3:	89 c7                	mov    %eax,%edi
     5d5:	75 79                	jne    650 <pipetest+0x190>
     5d7:	83 45 a4 04          	addl   $0x4,-0x5c(%ebp)
     5db:	8b 45 a4             	mov    -0x5c(%ebp),%eax
    for (i = 0; i < NUM_THREAD; i++){
     5de:	39 d8                	cmp    %ebx,%eax
     5e0:	75 de                	jne    5c0 <pipetest+0x100>
    close(fd[0]);
     5e2:	83 ec 0c             	sub    $0xc,%esp
     5e5:	ff 75 ac             	pushl  -0x54(%ebp)
     5e8:	e8 bd 0d 00 00       	call   13aa <close>
  if (wait() == -1){
     5ed:	e8 98 0d 00 00       	call   138a <wait>
     5f2:	83 c4 10             	add    $0x10,%esp
     5f5:	83 f8 ff             	cmp    $0xffffffff,%eax
     5f8:	0f 84 a5 00 00 00    	je     6a3 <pipetest+0x1e3>
  if (gcnt != 0)
     5fe:	a1 04 23 00 00       	mov    0x2304,%eax
     603:	85 c0                	test   %eax,%eax
     605:	74 38                	je     63f <pipetest+0x17f>
    printf(1,"panic at validation in pipetest : %d\n", gcnt);
     607:	a1 04 23 00 00       	mov    0x2304,%eax
     60c:	83 ec 04             	sub    $0x4,%esp
     60f:	50                   	push   %eax
     610:	68 90 1a 00 00       	push   $0x1a90
     615:	6a 01                	push   $0x1
     617:	e8 e4 0e 00 00       	call   1500 <printf>
     61c:	83 c4 10             	add    $0x10,%esp
     61f:	eb 1e                	jmp    63f <pipetest+0x17f>
     621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "panic at thread_create\n");
     628:	83 ec 08             	sub    $0x8,%esp
        return -1;
     62b:	bf ff ff ff ff       	mov    $0xffffffff,%edi
        printf(1, "panic at thread_create\n");
     630:	68 c1 18 00 00       	push   $0x18c1
     635:	6a 01                	push   $0x1
     637:	e8 c4 0e 00 00       	call   1500 <printf>
        return -1;
     63c:	83 c4 10             	add    $0x10,%esp
}
     63f:	8d 65 f4             	lea    -0xc(%ebp),%esp
     642:	89 f8                	mov    %edi,%eax
     644:	5b                   	pop    %ebx
     645:	5e                   	pop    %esi
     646:	5f                   	pop    %edi
     647:	5d                   	pop    %ebp
     648:	c3                   	ret    
     649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "panic at thread_join\n");
     650:	83 ec 08             	sub    $0x8,%esp
        return -1;
     653:	bf ff ff ff ff       	mov    $0xffffffff,%edi
        printf(1, "panic at thread_join\n");
     658:	68 e9 18 00 00       	push   $0x18e9
     65d:	6a 01                	push   $0x1
     65f:	e8 9c 0e 00 00       	call   1500 <printf>
        return -1;
     664:	83 c4 10             	add    $0x10,%esp
}
     667:	8d 65 f4             	lea    -0xc(%ebp),%esp
     66a:	89 f8                	mov    %edi,%eax
     66c:	5b                   	pop    %ebx
     66d:	5e                   	pop    %esi
     66e:	5f                   	pop    %edi
     66f:	5d                   	pop    %ebp
     670:	c3                   	ret    
    printf(1, "panic at pipe in pipetest\n");
     671:	83 ec 08             	sub    $0x8,%esp
    return -1;
     674:	bf ff ff ff ff       	mov    $0xffffffff,%edi
    printf(1, "panic at pipe in pipetest\n");
     679:	68 ff 18 00 00       	push   $0x18ff
     67e:	6a 01                	push   $0x1
     680:	e8 7b 0e 00 00       	call   1500 <printf>
    return -1;
     685:	83 c4 10             	add    $0x10,%esp
     688:	eb b5                	jmp    63f <pipetest+0x17f>
      printf(1, "panic at fork in pipetest\n");
     68a:	83 ec 08             	sub    $0x8,%esp
      return -1;
     68d:	bf ff ff ff ff       	mov    $0xffffffff,%edi
      printf(1, "panic at fork in pipetest\n");
     692:	68 1a 19 00 00       	push   $0x191a
     697:	6a 01                	push   $0x1
     699:	e8 62 0e 00 00       	call   1500 <printf>
      return -1;
     69e:	83 c4 10             	add    $0x10,%esp
     6a1:	eb 9c                	jmp    63f <pipetest+0x17f>
    printf(1, "panic at wait in pipetest\n");
     6a3:	50                   	push   %eax
     6a4:	50                   	push   %eax
    return -1;
     6a5:	83 cf ff             	or     $0xffffffff,%edi
    printf(1, "panic at wait in pipetest\n");
     6a8:	68 35 19 00 00       	push   $0x1935
     6ad:	6a 01                	push   $0x1
     6af:	e8 4c 0e 00 00       	call   1500 <printf>
    return -1;
     6b4:	83 c4 10             	add    $0x10,%esp
     6b7:	eb 86                	jmp    63f <pipetest+0x17f>
     6b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000006c0 <execthreadmain>:
{
     6c0:	55                   	push   %ebp
     6c1:	89 e5                	mov    %esp,%ebp
     6c3:	83 ec 24             	sub    $0x24,%esp
  sleep(1);
     6c6:	6a 01                	push   $0x1
  char *args[3] = {"echo", "echo is executed!", 0}; 
     6c8:	c7 45 ec 50 19 00 00 	movl   $0x1950,-0x14(%ebp)
     6cf:	c7 45 f0 55 19 00 00 	movl   $0x1955,-0x10(%ebp)
     6d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  sleep(1);
     6dd:	e8 30 0d 00 00       	call   1412 <sleep>
  exec("echo", args);
     6e2:	58                   	pop    %eax
     6e3:	8d 45 ec             	lea    -0x14(%ebp),%eax
     6e6:	5a                   	pop    %edx
     6e7:	50                   	push   %eax
     6e8:	68 50 19 00 00       	push   $0x1950
     6ed:	e8 c8 0c 00 00       	call   13ba <exec>
  printf(1, "panic at execthreadmain\n");
     6f2:	59                   	pop    %ecx
     6f3:	58                   	pop    %eax
     6f4:	68 67 19 00 00       	push   $0x1967
     6f9:	6a 01                	push   $0x1
     6fb:	e8 00 0e 00 00       	call   1500 <printf>
  exit();
     700:	e8 7d 0c 00 00       	call   1382 <exit>
     705:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000710 <sbrkthreadmain>:
{
     710:	55                   	push   %ebp
     711:	89 e5                	mov    %esp,%ebp
     713:	57                   	push   %edi
     714:	56                   	push   %esi
     715:	53                   	push   %ebx
     716:	83 ec 18             	sub    $0x18,%esp
     719:	8b 75 08             	mov    0x8(%ebp),%esi
  oldbrk = sbrk(1000);
     71c:	68 e8 03 00 00       	push   $0x3e8
     721:	e8 e4 0c 00 00       	call   140a <sbrk>
     726:	8d 56 01             	lea    0x1(%esi),%edx
  end = oldbrk + 1000;
     729:	8d 98 e8 03 00 00    	lea    0x3e8(%eax),%ebx
  oldbrk = sbrk(1000);
     72f:	89 c7                	mov    %eax,%edi
     731:	83 c4 10             	add    $0x10,%esp
     734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *c = tid+1;
     738:	88 10                	mov    %dl,(%eax)
  for (c = oldbrk; c < end; c++){
     73a:	83 c0 01             	add    $0x1,%eax
     73d:	39 c3                	cmp    %eax,%ebx
     73f:	75 f7                	jne    738 <sbrkthreadmain+0x28>
  sleep(1);
     741:	83 ec 0c             	sub    $0xc,%esp
    if (*c != tid+1){
     744:	83 c6 01             	add    $0x1,%esi
  sleep(1);
     747:	6a 01                	push   $0x1
     749:	e8 c4 0c 00 00       	call   1412 <sleep>
    if (*c != tid+1){
     74e:	0f be 17             	movsbl (%edi),%edx
     751:	83 c4 10             	add    $0x10,%esp
     754:	39 d6                	cmp    %edx,%esi
     756:	89 d0                	mov    %edx,%eax
     758:	75 11                	jne    76b <sbrkthreadmain+0x5b>
     75a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (c = oldbrk; c < end; c++){
     760:	83 c7 01             	add    $0x1,%edi
     763:	39 fb                	cmp    %edi,%ebx
     765:	74 18                	je     77f <sbrkthreadmain+0x6f>
    if (*c != tid+1){
     767:	38 07                	cmp    %al,(%edi)
     769:	74 f5                	je     760 <sbrkthreadmain+0x50>
      printf(1, "panic at sbrkthreadmain\n");
     76b:	83 ec 08             	sub    $0x8,%esp
     76e:	68 80 19 00 00       	push   $0x1980
     773:	6a 01                	push   $0x1
     775:	e8 86 0d 00 00       	call   1500 <printf>
      exit();
     77a:	e8 03 0c 00 00       	call   1382 <exit>
  thread_exit(0);
     77f:	83 ec 0c             	sub    $0xc,%esp
     782:	6a 00                	push   $0x0
     784:	e8 b9 0c 00 00       	call   1442 <thread_exit>
     789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000790 <killthreadmain>:
{
     790:	55                   	push   %ebp
     791:	89 e5                	mov    %esp,%ebp
     793:	83 ec 08             	sub    $0x8,%esp
  kill(getpid());
     796:	e8 67 0c 00 00       	call   1402 <getpid>
     79b:	83 ec 0c             	sub    $0xc,%esp
     79e:	50                   	push   %eax
     79f:	e8 0e 0c 00 00       	call   13b2 <kill>
     7a4:	83 c4 10             	add    $0x10,%esp
     7a7:	eb fe                	jmp    7a7 <killthreadmain+0x17>
     7a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000007b0 <pipethreadmain>:
{
     7b0:	55                   	push   %ebp
     7b1:	89 e5                	mov    %esp,%ebp
     7b3:	57                   	push   %edi
     7b4:	56                   	push   %esi
     7b5:	53                   	push   %ebx
      write(fd[1], &i, sizeof(int));
     7b6:	8d 7d e0             	lea    -0x20(%ebp),%edi
{
     7b9:	83 ec 1c             	sub    $0x1c,%esp
     7bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  for (i = -5; i <= 5; i++){
     7bf:	c7 45 e0 fb ff ff ff 	movl   $0xfffffffb,-0x20(%ebp)
  int type = ((int*)arg)[0];
     7c6:	8b 33                	mov    (%ebx),%esi
     7c8:	eb 32                	jmp    7fc <pipethreadmain+0x4c>
     7ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      read(fd[0], &input, sizeof(int));
     7d0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     7d3:	83 ec 04             	sub    $0x4,%esp
     7d6:	6a 04                	push   $0x4
     7d8:	50                   	push   %eax
     7d9:	ff 73 04             	pushl  0x4(%ebx)
     7dc:	e8 b9 0b 00 00       	call   139a <read>
      __sync_fetch_and_add(&gcnt, input);
     7e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     7e4:	f0 01 05 04 23 00 00 	lock add %eax,0x2304
  for (i = -5; i <= 5; i++){
     7eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
     7ee:	83 c4 10             	add    $0x10,%esp
     7f1:	83 c0 01             	add    $0x1,%eax
     7f4:	83 f8 05             	cmp    $0x5,%eax
     7f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
     7fa:	7f 23                	jg     81f <pipethreadmain+0x6f>
    if (type){
     7fc:	85 f6                	test   %esi,%esi
     7fe:	75 d0                	jne    7d0 <pipethreadmain+0x20>
      write(fd[1], &i, sizeof(int));
     800:	83 ec 04             	sub    $0x4,%esp
     803:	6a 04                	push   $0x4
     805:	57                   	push   %edi
     806:	ff 73 08             	pushl  0x8(%ebx)
     809:	e8 94 0b 00 00       	call   13a2 <write>
  for (i = -5; i <= 5; i++){
     80e:	8b 45 e0             	mov    -0x20(%ebp),%eax
      write(fd[1], &i, sizeof(int));
     811:	83 c4 10             	add    $0x10,%esp
  for (i = -5; i <= 5; i++){
     814:	83 c0 01             	add    $0x1,%eax
     817:	83 f8 05             	cmp    $0x5,%eax
     81a:	89 45 e0             	mov    %eax,-0x20(%ebp)
     81d:	7e dd                	jle    7fc <pipethreadmain+0x4c>
  thread_exit(0);
     81f:	83 ec 0c             	sub    $0xc,%esp
     822:	6a 00                	push   $0x0
     824:	e8 19 0c 00 00       	call   1442 <thread_exit>
     829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000830 <stridethreadmain>:

// ============================================================================

void*
stridethreadmain(void *arg)
{
     830:	55                   	push   %ebp
     831:	89 e5                	mov    %esp,%ebp
     833:	83 ec 08             	sub    $0x8,%esp
     836:	8b 55 08             	mov    0x8(%ebp),%edx
     839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  volatile int *flag = (int*)arg;
  int t;
  while(*flag){
     840:	8b 02                	mov    (%edx),%eax
     842:	85 c0                	test   %eax,%eax
     844:	74 22                	je     868 <stridethreadmain+0x38>
     846:	8d 76 00             	lea    0x0(%esi),%esi
     849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    while(*flag == 1){
     850:	8b 02                	mov    (%edx),%eax
     852:	83 f8 01             	cmp    $0x1,%eax
     855:	75 e9                	jne    840 <stridethreadmain+0x10>
      for (t = 0; t < 5; t++);
      __sync_fetch_and_add(&gcnt, 1);
     857:	f0 83 05 04 23 00 00 	lock addl $0x1,0x2304
     85e:	01 
     85f:	eb ef                	jmp    850 <stridethreadmain+0x20>
     861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
  }
  thread_exit(0);
     868:	83 ec 0c             	sub    $0xc,%esp
     86b:	6a 00                	push   $0x0
     86d:	e8 d0 0b 00 00       	call   1442 <thread_exit>
     872:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000880 <stridetest>:
  return 0;
}

int
stridetest(void)
{
     880:	55                   	push   %ebp
     881:	89 e5                	mov    %esp,%ebp
     883:	57                   	push   %edi
     884:	56                   	push   %esi
     885:	53                   	push   %ebx
     886:	83 ec 4c             	sub    $0x4c,%esp
  int i;
  int pid;
  int flag;
  void *retval;

  gcnt = 0;
     889:	c7 05 04 23 00 00 00 	movl   $0x0,0x2304
     890:	00 00 00 
  flag = 2;
     893:	c7 45 b8 02 00 00 00 	movl   $0x2,-0x48(%ebp)
  if ((pid = fork()) == -1){
     89a:	e8 db 0a 00 00       	call   137a <fork>
     89f:	83 f8 ff             	cmp    $0xffffffff,%eax
     8a2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
     8a5:	0f 84 2e 01 00 00    	je     9d9 <stridetest+0x159>
    printf(1, "panic at fork in forktest\n");
    exit();
  } else if (pid == 0){
     8ab:	8b 5d b4             	mov    -0x4c(%ebp),%ebx
     8ae:	85 db                	test   %ebx,%ebx
     8b0:	0f 85 c2 00 00 00    	jne    978 <stridetest+0xf8>
    set_cpu_share(2);
     8b6:	83 ec 0c             	sub    $0xc,%esp
     8b9:	6a 02                	push   $0x2
     8bb:	e8 72 0b 00 00       	call   1432 <set_cpu_share>
     8c0:	83 c4 10             	add    $0x10,%esp
     8c3:	8d 5d c0             	lea    -0x40(%ebp),%ebx
     8c6:	8d 7d b8             	lea    -0x48(%ebp),%edi
{
     8c9:	89 de                	mov    %ebx,%esi
     8cb:	90                   	nop
     8cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  } else{
    set_cpu_share(10);
  }

  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], stridethreadmain, (void*)&flag) != 0){
     8d0:	83 ec 04             	sub    $0x4,%esp
     8d3:	57                   	push   %edi
     8d4:	68 30 08 00 00       	push   $0x830
     8d9:	56                   	push   %esi
     8da:	e8 5b 0b 00 00       	call   143a <thread_create>
     8df:	83 c4 10             	add    $0x10,%esp
     8e2:	85 c0                	test   %eax,%eax
     8e4:	0f 85 a6 00 00 00    	jne    990 <stridetest+0x110>
  for (i = 0; i < NUM_THREAD; i++){
     8ea:	8d 45 e8             	lea    -0x18(%ebp),%eax
     8ed:	83 c6 04             	add    $0x4,%esi
     8f0:	39 c6                	cmp    %eax,%esi
     8f2:	75 dc                	jne    8d0 <stridetest+0x50>
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  flag = 1;
  sleep(500);
     8f4:	83 ec 0c             	sub    $0xc,%esp
  flag = 1;
     8f7:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  sleep(500);
     8fe:	68 f4 01 00 00       	push   $0x1f4
     903:	e8 0a 0b 00 00       	call   1412 <sleep>
  flag = 0;
     908:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
     90f:	83 c4 10             	add    $0x10,%esp
     912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_join(threads[i], &retval) != 0){
     918:	8d 45 bc             	lea    -0x44(%ebp),%eax
     91b:	83 ec 08             	sub    $0x8,%esp
     91e:	50                   	push   %eax
     91f:	ff 33                	pushl  (%ebx)
     921:	e8 24 0b 00 00       	call   144a <thread_join>
     926:	83 c4 10             	add    $0x10,%esp
     929:	85 c0                	test   %eax,%eax
     92b:	89 c7                	mov    %eax,%edi
     92d:	0f 85 85 00 00 00    	jne    9b8 <stridetest+0x138>
     933:	83 c3 04             	add    $0x4,%ebx
  for (i = 0; i < NUM_THREAD; i++){
     936:	39 f3                	cmp    %esi,%ebx
     938:	75 de                	jne    918 <stridetest+0x98>
      printf(1, "panic at thread_join\n");
      return -1;
    }
  }

  if (pid == 0){
     93a:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
    printf(1, " 2% : %d\n", gcnt);
     93d:	a1 04 23 00 00       	mov    0x2304,%eax
  if (pid == 0){
     942:	85 c9                	test   %ecx,%ecx
     944:	0f 84 a2 00 00 00    	je     9ec <stridetest+0x16c>
    exit();
  } else{
    printf(1, "10% : %d\n", gcnt);
     94a:	83 ec 04             	sub    $0x4,%esp
     94d:	50                   	push   %eax
     94e:	68 a3 19 00 00       	push   $0x19a3
     953:	6a 01                	push   $0x1
     955:	e8 a6 0b 00 00       	call   1500 <printf>
    if (wait() == -1){
     95a:	e8 2b 0a 00 00       	call   138a <wait>
     95f:	83 c4 10             	add    $0x10,%esp
     962:	83 f8 ff             	cmp    $0xffffffff,%eax
     965:	0f 84 94 00 00 00    	je     9ff <stridetest+0x17f>
      exit();
    }
  }

  return 0;
}
     96b:	8d 65 f4             	lea    -0xc(%ebp),%esp
     96e:	89 f8                	mov    %edi,%eax
     970:	5b                   	pop    %ebx
     971:	5e                   	pop    %esi
     972:	5f                   	pop    %edi
     973:	5d                   	pop    %ebp
     974:	c3                   	ret    
     975:	8d 76 00             	lea    0x0(%esi),%esi
    set_cpu_share(10);
     978:	83 ec 0c             	sub    $0xc,%esp
     97b:	6a 0a                	push   $0xa
     97d:	e8 b0 0a 00 00       	call   1432 <set_cpu_share>
     982:	83 c4 10             	add    $0x10,%esp
     985:	e9 39 ff ff ff       	jmp    8c3 <stridetest+0x43>
     98a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      printf(1, "panic at thread_create\n");
     990:	83 ec 08             	sub    $0x8,%esp
      return -1;
     993:	bf ff ff ff ff       	mov    $0xffffffff,%edi
      printf(1, "panic at thread_create\n");
     998:	68 c1 18 00 00       	push   $0x18c1
     99d:	6a 01                	push   $0x1
     99f:	e8 5c 0b 00 00       	call   1500 <printf>
      return -1;
     9a4:	83 c4 10             	add    $0x10,%esp
}
     9a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
     9aa:	89 f8                	mov    %edi,%eax
     9ac:	5b                   	pop    %ebx
     9ad:	5e                   	pop    %esi
     9ae:	5f                   	pop    %edi
     9af:	5d                   	pop    %ebp
     9b0:	c3                   	ret    
     9b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "panic at thread_join\n");
     9b8:	83 ec 08             	sub    $0x8,%esp
      return -1;
     9bb:	bf ff ff ff ff       	mov    $0xffffffff,%edi
      printf(1, "panic at thread_join\n");
     9c0:	68 e9 18 00 00       	push   $0x18e9
     9c5:	6a 01                	push   $0x1
     9c7:	e8 34 0b 00 00       	call   1500 <printf>
      return -1;
     9cc:	83 c4 10             	add    $0x10,%esp
}
     9cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
     9d2:	89 f8                	mov    %edi,%eax
     9d4:	5b                   	pop    %ebx
     9d5:	5e                   	pop    %esi
     9d6:	5f                   	pop    %edi
     9d7:	5d                   	pop    %ebp
     9d8:	c3                   	ret    
    printf(1, "panic at fork in forktest\n");
     9d9:	56                   	push   %esi
     9da:	56                   	push   %esi
     9db:	68 7c 18 00 00       	push   $0x187c
     9e0:	6a 01                	push   $0x1
     9e2:	e8 19 0b 00 00       	call   1500 <printf>
    exit();
     9e7:	e8 96 09 00 00       	call   1382 <exit>
    printf(1, " 2% : %d\n", gcnt);
     9ec:	52                   	push   %edx
     9ed:	50                   	push   %eax
     9ee:	68 99 19 00 00       	push   $0x1999
     9f3:	6a 01                	push   $0x1
     9f5:	e8 06 0b 00 00       	call   1500 <printf>
    exit();
     9fa:	e8 83 09 00 00       	call   1382 <exit>
      printf(1, "panic at wait in forktest\n");
     9ff:	50                   	push   %eax
     a00:	50                   	push   %eax
     a01:	68 a6 18 00 00       	push   $0x18a6
     a06:	6a 01                	push   $0x1
     a08:	e8 f3 0a 00 00       	call   1500 <printf>
      exit();
     a0d:	e8 70 09 00 00       	call   1382 <exit>
     a12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000a20 <exittest1>:
{
     a20:	55                   	push   %ebp
     a21:	89 e5                	mov    %esp,%ebp
     a23:	57                   	push   %edi
     a24:	56                   	push   %esi
     a25:	53                   	push   %ebx
     a26:	8d 7d e8             	lea    -0x18(%ebp),%edi
     a29:	8d 5d c0             	lea    -0x40(%ebp),%ebx
     a2c:	83 ec 3c             	sub    $0x3c,%esp
     a2f:	90                   	nop
    if (thread_create(&threads[i], exitthreadmain, (void*)1) != 0){
     a30:	83 ec 04             	sub    $0x4,%esp
     a33:	6a 01                	push   $0x1
     a35:	68 b0 02 00 00       	push   $0x2b0
     a3a:	53                   	push   %ebx
     a3b:	e8 fa 09 00 00       	call   143a <thread_create>
     a40:	83 c4 10             	add    $0x10,%esp
     a43:	85 c0                	test   %eax,%eax
     a45:	89 c6                	mov    %eax,%esi
     a47:	75 27                	jne    a70 <exittest1+0x50>
     a49:	83 c3 04             	add    $0x4,%ebx
  for (i = 0; i < NUM_THREAD; i++){
     a4c:	39 fb                	cmp    %edi,%ebx
     a4e:	75 e0                	jne    a30 <exittest1+0x10>
  sleep(1);
     a50:	83 ec 0c             	sub    $0xc,%esp
     a53:	6a 01                	push   $0x1
     a55:	e8 b8 09 00 00       	call   1412 <sleep>
  return 0;
     a5a:	83 c4 10             	add    $0x10,%esp
}
     a5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a60:	89 f0                	mov    %esi,%eax
     a62:	5b                   	pop    %ebx
     a63:	5e                   	pop    %esi
     a64:	5f                   	pop    %edi
     a65:	5d                   	pop    %ebp
     a66:	c3                   	ret    
     a67:	89 f6                	mov    %esi,%esi
     a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      printf(1, "panic at thread_create\n");
     a70:	83 ec 08             	sub    $0x8,%esp
     a73:	be ff ff ff ff       	mov    $0xffffffff,%esi
     a78:	68 c1 18 00 00       	push   $0x18c1
     a7d:	6a 01                	push   $0x1
     a7f:	e8 7c 0a 00 00       	call   1500 <printf>
     a84:	83 c4 10             	add    $0x10,%esp
}
     a87:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a8a:	89 f0                	mov    %esi,%eax
     a8c:	5b                   	pop    %ebx
     a8d:	5e                   	pop    %esi
     a8e:	5f                   	pop    %edi
     a8f:	5d                   	pop    %ebp
     a90:	c3                   	ret    
     a91:	eb 0d                	jmp    aa0 <jointest1>
     a93:	90                   	nop
     a94:	90                   	nop
     a95:	90                   	nop
     a96:	90                   	nop
     a97:	90                   	nop
     a98:	90                   	nop
     a99:	90                   	nop
     a9a:	90                   	nop
     a9b:	90                   	nop
     a9c:	90                   	nop
     a9d:	90                   	nop
     a9e:	90                   	nop
     a9f:	90                   	nop

00000aa0 <jointest1>:
{
     aa0:	55                   	push   %ebp
     aa1:	89 e5                	mov    %esp,%ebp
     aa3:	56                   	push   %esi
     aa4:	53                   	push   %ebx
     aa5:	8d 75 cc             	lea    -0x34(%ebp),%esi
  for (i = 1; i <= NUM_THREAD; i++){
     aa8:	bb 01 00 00 00       	mov    $0x1,%ebx
{
     aad:	83 ec 40             	sub    $0x40,%esp
    if (thread_create(&threads[i-1], jointhreadmain, (void*)i) != 0){
     ab0:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
     ab3:	83 ec 04             	sub    $0x4,%esp
     ab6:	53                   	push   %ebx
     ab7:	68 70 02 00 00       	push   $0x270
     abc:	50                   	push   %eax
     abd:	e8 78 09 00 00       	call   143a <thread_create>
     ac2:	83 c4 10             	add    $0x10,%esp
     ac5:	85 c0                	test   %eax,%eax
     ac7:	75 67                	jne    b30 <jointest1+0x90>
  for (i = 1; i <= NUM_THREAD; i++){
     ac9:	83 c3 01             	add    $0x1,%ebx
     acc:	83 fb 0b             	cmp    $0xb,%ebx
     acf:	75 df                	jne    ab0 <jointest1+0x10>
  printf(1, "thread_join!!!\n");
     ad1:	83 ec 08             	sub    $0x8,%esp
     ad4:	bb 02 00 00 00       	mov    $0x2,%ebx
     ad9:	68 d9 18 00 00       	push   $0x18d9
     ade:	6a 01                	push   $0x1
     ae0:	e8 1b 0a 00 00       	call   1500 <printf>
     ae5:	83 c4 10             	add    $0x10,%esp
     ae8:	90                   	nop
     ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
     af0:	83 ec 08             	sub    $0x8,%esp
     af3:	56                   	push   %esi
     af4:	ff 74 5d cc          	pushl  -0x34(%ebp,%ebx,2)
     af8:	e8 4d 09 00 00       	call   144a <thread_join>
     afd:	83 c4 10             	add    $0x10,%esp
     b00:	85 c0                	test   %eax,%eax
     b02:	75 4c                	jne    b50 <jointest1+0xb0>
     b04:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
     b07:	75 47                	jne    b50 <jointest1+0xb0>
     b09:	83 c3 02             	add    $0x2,%ebx
  for (i = 1; i <= NUM_THREAD; i++){
     b0c:	83 fb 16             	cmp    $0x16,%ebx
     b0f:	75 df                	jne    af0 <jointest1+0x50>
  printf(1,"\n");
     b11:	83 ec 08             	sub    $0x8,%esp
     b14:	89 45 c4             	mov    %eax,-0x3c(%ebp)
     b17:	68 e7 18 00 00       	push   $0x18e7
     b1c:	6a 01                	push   $0x1
     b1e:	e8 dd 09 00 00       	call   1500 <printf>
  return 0;
     b23:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     b26:	83 c4 10             	add    $0x10,%esp
}
     b29:	8d 65 f8             	lea    -0x8(%ebp),%esp
     b2c:	5b                   	pop    %ebx
     b2d:	5e                   	pop    %esi
     b2e:	5d                   	pop    %ebp
     b2f:	c3                   	ret    
      printf(1, "panic at thread_create\n");
     b30:	83 ec 08             	sub    $0x8,%esp
     b33:	68 c1 18 00 00       	push   $0x18c1
     b38:	6a 01                	push   $0x1
     b3a:	e8 c1 09 00 00       	call   1500 <printf>
      return -1;
     b3f:	83 c4 10             	add    $0x10,%esp
}
     b42:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return -1;
     b45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     b4a:	5b                   	pop    %ebx
     b4b:	5e                   	pop    %esi
     b4c:	5d                   	pop    %ebp
     b4d:	c3                   	ret    
     b4e:	66 90                	xchg   %ax,%ax
      printf(1, "panic at thread_join\n");
     b50:	83 ec 08             	sub    $0x8,%esp
     b53:	68 e9 18 00 00       	push   $0x18e9
     b58:	6a 01                	push   $0x1
     b5a:	e8 a1 09 00 00       	call   1500 <printf>
     b5f:	83 c4 10             	add    $0x10,%esp
}
     b62:	8d 65 f8             	lea    -0x8(%ebp),%esp
      printf(1, "panic at thread_join\n");
     b65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     b6a:	5b                   	pop    %ebx
     b6b:	5e                   	pop    %esi
     b6c:	5d                   	pop    %ebp
     b6d:	c3                   	ret    
     b6e:	66 90                	xchg   %ax,%ax

00000b70 <stresstest>:
{
     b70:	55                   	push   %ebp
     b71:	89 e5                	mov    %esp,%ebp
     b73:	57                   	push   %edi
     b74:	56                   	push   %esi
     b75:	53                   	push   %ebx
     b76:	8d 75 bc             	lea    -0x44(%ebp),%esi
     b79:	83 ec 4c             	sub    $0x4c,%esp
  for (n = 1; n <= nstress; n++){
     b7c:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
     b83:	31 ff                	xor    %edi,%edi
     b85:	8d 76 00             	lea    0x0(%esi),%esi
      if (thread_create(&threads[i], stressthreadmain, (void*)i) != 0){
     b88:	8d 44 bd c0          	lea    -0x40(%ebp,%edi,4),%eax
     b8c:	83 ec 04             	sub    $0x4,%esp
     b8f:	8d 5d c0             	lea    -0x40(%ebp),%ebx
     b92:	57                   	push   %edi
     b93:	68 a0 02 00 00       	push   $0x2a0
     b98:	50                   	push   %eax
     b99:	e8 9c 08 00 00       	call   143a <thread_create>
     b9e:	83 c4 10             	add    $0x10,%esp
     ba1:	85 c0                	test   %eax,%eax
     ba3:	75 6b                	jne    c10 <stresstest+0xa0>
    for (i = 0; i < NUM_THREAD; i++){
     ba5:	83 c7 01             	add    $0x1,%edi
     ba8:	83 ff 0a             	cmp    $0xa,%edi
     bab:	75 db                	jne    b88 <stresstest+0x18>
     bad:	8d 76 00             	lea    0x0(%esi),%esi
      if (thread_join(threads[i], &retval) != 0){
     bb0:	83 ec 08             	sub    $0x8,%esp
     bb3:	56                   	push   %esi
     bb4:	ff 33                	pushl  (%ebx)
     bb6:	e8 8f 08 00 00       	call   144a <thread_join>
     bbb:	83 c4 10             	add    $0x10,%esp
     bbe:	85 c0                	test   %eax,%eax
     bc0:	75 6e                	jne    c30 <stresstest+0xc0>
    for (i = 0; i < NUM_THREAD; i++){
     bc2:	8d 4d e8             	lea    -0x18(%ebp),%ecx
     bc5:	83 c3 04             	add    $0x4,%ebx
     bc8:	39 cb                	cmp    %ecx,%ebx
     bca:	75 e4                	jne    bb0 <stresstest+0x40>
  for (n = 1; n <= nstress; n++){
     bcc:	83 45 b4 01          	addl   $0x1,-0x4c(%ebp)
     bd0:	8b 55 b4             	mov    -0x4c(%ebp),%edx
     bd3:	81 fa b9 88 00 00    	cmp    $0x88b9,%edx
     bd9:	74 74                	je     c4f <stresstest+0xdf>
    if (n % 1000 == 0)
     bdb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
     bde:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
     be3:	f7 e2                	mul    %edx
     be5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
     be8:	c1 ea 06             	shr    $0x6,%edx
     beb:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
     bf1:	39 d0                	cmp    %edx,%eax
     bf3:	75 8e                	jne    b83 <stresstest+0x13>
      printf(1, "%d\n", n);
     bf5:	83 ec 04             	sub    $0x4,%esp
     bf8:	50                   	push   %eax
     bf9:	68 a9 19 00 00       	push   $0x19a9
     bfe:	6a 01                	push   $0x1
     c00:	e8 fb 08 00 00       	call   1500 <printf>
     c05:	83 c4 10             	add    $0x10,%esp
     c08:	e9 76 ff ff ff       	jmp    b83 <stresstest+0x13>
     c0d:	8d 76 00             	lea    0x0(%esi),%esi
        printf(1, "panic at thread_create\n");
     c10:	83 ec 08             	sub    $0x8,%esp
     c13:	68 c1 18 00 00       	push   $0x18c1
     c18:	6a 01                	push   $0x1
     c1a:	e8 e1 08 00 00       	call   1500 <printf>
        return -1;
     c1f:	83 c4 10             	add    $0x10,%esp
     c22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     c27:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c2a:	5b                   	pop    %ebx
     c2b:	5e                   	pop    %esi
     c2c:	5f                   	pop    %edi
     c2d:	5d                   	pop    %ebp
     c2e:	c3                   	ret    
     c2f:	90                   	nop
        printf(1, "panic at thread_join\n");
     c30:	83 ec 08             	sub    $0x8,%esp
     c33:	68 e9 18 00 00       	push   $0x18e9
     c38:	6a 01                	push   $0x1
     c3a:	e8 c1 08 00 00       	call   1500 <printf>
        return -1;
     c3f:	83 c4 10             	add    $0x10,%esp
}
     c42:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
     c45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     c4a:	5b                   	pop    %ebx
     c4b:	5e                   	pop    %esi
     c4c:	5f                   	pop    %edi
     c4d:	5d                   	pop    %ebp
     c4e:	c3                   	ret    
  printf(1, "\n");
     c4f:	83 ec 08             	sub    $0x8,%esp
     c52:	89 45 b4             	mov    %eax,-0x4c(%ebp)
     c55:	68 e7 18 00 00       	push   $0x18e7
     c5a:	6a 01                	push   $0x1
     c5c:	e8 9f 08 00 00       	call   1500 <printf>
     c61:	83 c4 10             	add    $0x10,%esp
     c64:	8b 45 b4             	mov    -0x4c(%ebp),%eax
     c67:	eb be                	jmp    c27 <stresstest+0xb7>
     c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000c70 <killtest>:
{
     c70:	55                   	push   %ebp
     c71:	89 e5                	mov    %esp,%ebp
     c73:	57                   	push   %edi
     c74:	56                   	push   %esi
     c75:	53                   	push   %ebx
  for (i = 0; i < NUM_THREAD; i++){
     c76:	31 db                	xor    %ebx,%ebx
{
     c78:	83 ec 3c             	sub    $0x3c,%esp
     c7b:	90                   	nop
     c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (thread_create(&threads[i], killthreadmain, (void*)i) != 0){
     c80:	8d 44 9d c0          	lea    -0x40(%ebp,%ebx,4),%eax
     c84:	83 ec 04             	sub    $0x4,%esp
     c87:	8d 75 c0             	lea    -0x40(%ebp),%esi
     c8a:	53                   	push   %ebx
     c8b:	68 90 07 00 00       	push   $0x790
     c90:	50                   	push   %eax
     c91:	e8 a4 07 00 00       	call   143a <thread_create>
     c96:	83 c4 10             	add    $0x10,%esp
     c99:	85 c0                	test   %eax,%eax
     c9b:	75 53                	jne    cf0 <killtest+0x80>
  for (i = 0; i < NUM_THREAD; i++){
     c9d:	83 c3 01             	add    $0x1,%ebx
     ca0:	83 fb 0a             	cmp    $0xa,%ebx
     ca3:	75 db                	jne    c80 <killtest+0x10>
     ca5:	8d 7d e8             	lea    -0x18(%ebp),%edi
     ca8:	8d 5d bc             	lea    -0x44(%ebp),%ebx
    if (thread_join(threads[i], &retval) != 0){
     cab:	83 ec 08             	sub    $0x8,%esp
     cae:	53                   	push   %ebx
     caf:	ff 36                	pushl  (%esi)
     cb1:	e8 94 07 00 00       	call   144a <thread_join>
     cb6:	83 c4 10             	add    $0x10,%esp
     cb9:	85 c0                	test   %eax,%eax
     cbb:	75 13                	jne    cd0 <killtest+0x60>
     cbd:	83 c6 04             	add    $0x4,%esi
  for (i = 0; i < NUM_THREAD; i++){
     cc0:	39 fe                	cmp    %edi,%esi
     cc2:	75 e7                	jne    cab <killtest+0x3b>
     cc4:	eb fe                	jmp    cc4 <killtest+0x54>
     cc6:	8d 76 00             	lea    0x0(%esi),%esi
     cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      printf(1, "panic at thread_join\n");
     cd0:	83 ec 08             	sub    $0x8,%esp
     cd3:	68 e9 18 00 00       	push   $0x18e9
     cd8:	6a 01                	push   $0x1
     cda:	e8 21 08 00 00       	call   1500 <printf>
      return -1;
     cdf:	83 c4 10             	add    $0x10,%esp
}
     ce2:	8d 65 f4             	lea    -0xc(%ebp),%esp
     ce5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     cea:	5b                   	pop    %ebx
     ceb:	5e                   	pop    %esi
     cec:	5f                   	pop    %edi
     ced:	5d                   	pop    %ebp
     cee:	c3                   	ret    
     cef:	90                   	nop
      printf(1, "panic at thread_create\n");
     cf0:	83 ec 08             	sub    $0x8,%esp
     cf3:	68 c1 18 00 00       	push   $0x18c1
     cf8:	6a 01                	push   $0x1
     cfa:	e8 01 08 00 00       	call   1500 <printf>
     cff:	83 c4 10             	add    $0x10,%esp
}
     d02:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d0a:	5b                   	pop    %ebx
     d0b:	5e                   	pop    %esi
     d0c:	5f                   	pop    %edi
     d0d:	5d                   	pop    %ebp
     d0e:	c3                   	ret    
     d0f:	90                   	nop

00000d10 <sleeptest>:
{
     d10:	55                   	push   %ebp
     d11:	89 e5                	mov    %esp,%ebp
     d13:	56                   	push   %esi
     d14:	53                   	push   %ebx
  for (i = 0; i < NUM_THREAD; i++){
     d15:	31 db                	xor    %ebx,%ebx
{
     d17:	83 ec 30             	sub    $0x30,%esp
     d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (thread_create(&threads[i], sleepthreadmain, (void*)i) != 0){
     d20:	8d 44 9d d0          	lea    -0x30(%ebp,%ebx,4),%eax
     d24:	83 ec 04             	sub    $0x4,%esp
     d27:	53                   	push   %ebx
     d28:	68 70 03 00 00       	push   $0x370
     d2d:	50                   	push   %eax
     d2e:	e8 07 07 00 00       	call   143a <thread_create>
     d33:	83 c4 10             	add    $0x10,%esp
     d36:	85 c0                	test   %eax,%eax
     d38:	89 c6                	mov    %eax,%esi
     d3a:	75 24                	jne    d60 <sleeptest+0x50>
  for (i = 0; i < NUM_THREAD; i++){
     d3c:	83 c3 01             	add    $0x1,%ebx
     d3f:	83 fb 0a             	cmp    $0xa,%ebx
     d42:	75 dc                	jne    d20 <sleeptest+0x10>
  sleep(10);
     d44:	83 ec 0c             	sub    $0xc,%esp
     d47:	6a 0a                	push   $0xa
     d49:	e8 c4 06 00 00       	call   1412 <sleep>
  return 0;
     d4e:	83 c4 10             	add    $0x10,%esp
}
     d51:	8d 65 f8             	lea    -0x8(%ebp),%esp
     d54:	89 f0                	mov    %esi,%eax
     d56:	5b                   	pop    %ebx
     d57:	5e                   	pop    %esi
     d58:	5d                   	pop    %ebp
     d59:	c3                   	ret    
     d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      printf(1, "panic at thread_create\n");
     d60:	83 ec 08             	sub    $0x8,%esp
     d63:	be ff ff ff ff       	mov    $0xffffffff,%esi
     d68:	68 c1 18 00 00       	push   $0x18c1
     d6d:	6a 01                	push   $0x1
     d6f:	e8 8c 07 00 00       	call   1500 <printf>
     d74:	83 c4 10             	add    $0x10,%esp
}
     d77:	8d 65 f8             	lea    -0x8(%ebp),%esp
     d7a:	89 f0                	mov    %esi,%eax
     d7c:	5b                   	pop    %ebx
     d7d:	5e                   	pop    %esi
     d7e:	5d                   	pop    %ebp
     d7f:	c3                   	ret    

00000d80 <forktest>:
{
     d80:	55                   	push   %ebp
     d81:	89 e5                	mov    %esp,%ebp
     d83:	57                   	push   %edi
     d84:	56                   	push   %esi
     d85:	8d 75 c0             	lea    -0x40(%ebp),%esi
     d88:	53                   	push   %ebx
     d89:	8d 7d e8             	lea    -0x18(%ebp),%edi
     d8c:	83 ec 3c             	sub    $0x3c,%esp
     d8f:	89 f3                	mov    %esi,%ebx
     d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (thread_create(&threads[i], forkthreadmain, (void*)0) != 0){
     d98:	83 ec 04             	sub    $0x4,%esp
     d9b:	6a 00                	push   $0x0
     d9d:	68 f0 02 00 00       	push   $0x2f0
     da2:	53                   	push   %ebx
     da3:	e8 92 06 00 00       	call   143a <thread_create>
     da8:	83 c4 10             	add    $0x10,%esp
     dab:	85 c0                	test   %eax,%eax
     dad:	75 39                	jne    de8 <forktest+0x68>
     daf:	83 c3 04             	add    $0x4,%ebx
  for (i = 0; i < NUM_THREAD; i++){
     db2:	39 fb                	cmp    %edi,%ebx
     db4:	75 e2                	jne    d98 <forktest+0x18>
     db6:	8d 7d bc             	lea    -0x44(%ebp),%edi
     db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (thread_join(threads[i], &retval) != 0){
     dc0:	83 ec 08             	sub    $0x8,%esp
     dc3:	57                   	push   %edi
     dc4:	ff 36                	pushl  (%esi)
     dc6:	e8 7f 06 00 00       	call   144a <thread_join>
     dcb:	83 c4 10             	add    $0x10,%esp
     dce:	85 c0                	test   %eax,%eax
     dd0:	75 3e                	jne    e10 <forktest+0x90>
     dd2:	83 c6 04             	add    $0x4,%esi
  for (i = 0; i < NUM_THREAD; i++){
     dd5:	39 de                	cmp    %ebx,%esi
     dd7:	75 e7                	jne    dc0 <forktest+0x40>
}
     dd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
     ddc:	5b                   	pop    %ebx
     ddd:	5e                   	pop    %esi
     dde:	5f                   	pop    %edi
     ddf:	5d                   	pop    %ebp
     de0:	c3                   	ret    
     de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "panic at thread_create\n");
     de8:	83 ec 08             	sub    $0x8,%esp
     deb:	68 c1 18 00 00       	push   $0x18c1
     df0:	6a 01                	push   $0x1
     df2:	e8 09 07 00 00       	call   1500 <printf>
      return -1;
     df7:	83 c4 10             	add    $0x10,%esp
}
     dfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
     dfd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     e02:	5b                   	pop    %ebx
     e03:	5e                   	pop    %esi
     e04:	5f                   	pop    %edi
     e05:	5d                   	pop    %ebp
     e06:	c3                   	ret    
     e07:	89 f6                	mov    %esi,%esi
     e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      printf(1, "panic at thread_join\n");
     e10:	83 ec 08             	sub    $0x8,%esp
     e13:	68 e9 18 00 00       	push   $0x18e9
     e18:	6a 01                	push   $0x1
     e1a:	e8 e1 06 00 00       	call   1500 <printf>
     e1f:	83 c4 10             	add    $0x10,%esp
}
     e22:	8d 65 f4             	lea    -0xc(%ebp),%esp
      printf(1, "panic at thread_join\n");
     e25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     e2a:	5b                   	pop    %ebx
     e2b:	5e                   	pop    %esi
     e2c:	5f                   	pop    %edi
     e2d:	5d                   	pop    %ebp
     e2e:	c3                   	ret    
     e2f:	90                   	nop

00000e30 <sbrktest>:
{
     e30:	55                   	push   %ebp
     e31:	89 e5                	mov    %esp,%ebp
     e33:	57                   	push   %edi
     e34:	56                   	push   %esi
     e35:	53                   	push   %ebx
  for (i = 0; i < NUM_THREAD; i++){
     e36:	31 db                	xor    %ebx,%ebx
{
     e38:	83 ec 3c             	sub    $0x3c,%esp
     e3b:	90                   	nop
     e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (thread_create(&threads[i], sbrkthreadmain, (void*)i) != 0){
     e40:	8d 44 9d c0          	lea    -0x40(%ebp,%ebx,4),%eax
     e44:	83 ec 04             	sub    $0x4,%esp
     e47:	8d 75 c0             	lea    -0x40(%ebp),%esi
     e4a:	53                   	push   %ebx
     e4b:	68 10 07 00 00       	push   $0x710
     e50:	50                   	push   %eax
     e51:	e8 e4 05 00 00       	call   143a <thread_create>
     e56:	83 c4 10             	add    $0x10,%esp
     e59:	85 c0                	test   %eax,%eax
     e5b:	75 3b                	jne    e98 <sbrktest+0x68>
  for (i = 0; i < NUM_THREAD; i++){
     e5d:	83 c3 01             	add    $0x1,%ebx
     e60:	83 fb 0a             	cmp    $0xa,%ebx
     e63:	75 db                	jne    e40 <sbrktest+0x10>
     e65:	8d 7d e8             	lea    -0x18(%ebp),%edi
     e68:	8d 5d bc             	lea    -0x44(%ebp),%ebx
     e6b:	90                   	nop
     e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (thread_join(threads[i], &retval) != 0){
     e70:	83 ec 08             	sub    $0x8,%esp
     e73:	53                   	push   %ebx
     e74:	ff 36                	pushl  (%esi)
     e76:	e8 cf 05 00 00       	call   144a <thread_join>
     e7b:	83 c4 10             	add    $0x10,%esp
     e7e:	85 c0                	test   %eax,%eax
     e80:	75 3e                	jne    ec0 <sbrktest+0x90>
     e82:	83 c6 04             	add    $0x4,%esi
  for (i = 0; i < NUM_THREAD; i++){
     e85:	39 fe                	cmp    %edi,%esi
     e87:	75 e7                	jne    e70 <sbrktest+0x40>
}
     e89:	8d 65 f4             	lea    -0xc(%ebp),%esp
     e8c:	5b                   	pop    %ebx
     e8d:	5e                   	pop    %esi
     e8e:	5f                   	pop    %edi
     e8f:	5d                   	pop    %ebp
     e90:	c3                   	ret    
     e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "panic at thread_create\n");
     e98:	83 ec 08             	sub    $0x8,%esp
     e9b:	68 c1 18 00 00       	push   $0x18c1
     ea0:	6a 01                	push   $0x1
     ea2:	e8 59 06 00 00       	call   1500 <printf>
      return -1;
     ea7:	83 c4 10             	add    $0x10,%esp
}
     eaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
     ead:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     eb2:	5b                   	pop    %ebx
     eb3:	5e                   	pop    %esi
     eb4:	5f                   	pop    %edi
     eb5:	5d                   	pop    %ebp
     eb6:	c3                   	ret    
     eb7:	89 f6                	mov    %esi,%esi
     eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      printf(1, "panic at thread_join\n");
     ec0:	83 ec 08             	sub    $0x8,%esp
     ec3:	68 e9 18 00 00       	push   $0x18e9
     ec8:	6a 01                	push   $0x1
     eca:	e8 31 06 00 00       	call   1500 <printf>
     ecf:	83 c4 10             	add    $0x10,%esp
}
     ed2:	8d 65 f4             	lea    -0xc(%ebp),%esp
      printf(1, "panic at thread_join\n");
     ed5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     eda:	5b                   	pop    %ebx
     edb:	5e                   	pop    %esi
     edc:	5f                   	pop    %edi
     edd:	5d                   	pop    %ebp
     ede:	c3                   	ret    
     edf:	90                   	nop

00000ee0 <basictest>:
{
     ee0:	55                   	push   %ebp
     ee1:	89 e5                	mov    %esp,%ebp
     ee3:	56                   	push   %esi
     ee4:	53                   	push   %ebx
  for (i = 0; i < NUM_THREAD; i++){
     ee5:	31 db                	xor    %ebx,%ebx
{
     ee7:	83 ec 40             	sub    $0x40,%esp
     eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (thread_create(&threads[i], basicthreadmain, (void*)i) != 0){
     ef0:	8d 44 9d d0          	lea    -0x30(%ebp,%ebx,4),%eax
     ef4:	83 ec 04             	sub    $0x4,%esp
     ef7:	53                   	push   %ebx
     ef8:	68 10 02 00 00       	push   $0x210
     efd:	50                   	push   %eax
     efe:	e8 37 05 00 00       	call   143a <thread_create>
     f03:	83 c4 10             	add    $0x10,%esp
     f06:	85 c0                	test   %eax,%eax
     f08:	89 c6                	mov    %eax,%esi
     f0a:	75 54                	jne    f60 <basictest+0x80>
  for (i = 0; i < NUM_THREAD; i++){
     f0c:	83 c3 01             	add    $0x1,%ebx
     f0f:	83 fb 0a             	cmp    $0xa,%ebx
     f12:	75 dc                	jne    ef0 <basictest+0x10>
     f14:	8d 5d cc             	lea    -0x34(%ebp),%ebx
     f17:	89 f6                	mov    %esi,%esi
     f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
     f20:	83 ec 08             	sub    $0x8,%esp
     f23:	53                   	push   %ebx
     f24:	ff 74 b5 d0          	pushl  -0x30(%ebp,%esi,4)
     f28:	e8 1d 05 00 00       	call   144a <thread_join>
     f2d:	83 c4 10             	add    $0x10,%esp
     f30:	85 c0                	test   %eax,%eax
     f32:	75 4c                	jne    f80 <basictest+0xa0>
     f34:	83 c6 01             	add    $0x1,%esi
     f37:	39 75 cc             	cmp    %esi,-0x34(%ebp)
     f3a:	75 44                	jne    f80 <basictest+0xa0>
  for (i = 0; i < NUM_THREAD; i++){
     f3c:	83 fe 0a             	cmp    $0xa,%esi
     f3f:	75 df                	jne    f20 <basictest+0x40>
  printf(1,"\n");
     f41:	83 ec 08             	sub    $0x8,%esp
     f44:	89 45 c4             	mov    %eax,-0x3c(%ebp)
     f47:	68 e7 18 00 00       	push   $0x18e7
     f4c:	6a 01                	push   $0x1
     f4e:	e8 ad 05 00 00       	call   1500 <printf>
  return 0;
     f53:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     f56:	83 c4 10             	add    $0x10,%esp
}
     f59:	8d 65 f8             	lea    -0x8(%ebp),%esp
     f5c:	5b                   	pop    %ebx
     f5d:	5e                   	pop    %esi
     f5e:	5d                   	pop    %ebp
     f5f:	c3                   	ret    
      printf(1, "panic at thread_create\n");
     f60:	83 ec 08             	sub    $0x8,%esp
     f63:	68 c1 18 00 00       	push   $0x18c1
     f68:	6a 01                	push   $0x1
     f6a:	e8 91 05 00 00       	call   1500 <printf>
      return -1;
     f6f:	83 c4 10             	add    $0x10,%esp
}
     f72:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return -1;
     f75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     f7a:	5b                   	pop    %ebx
     f7b:	5e                   	pop    %esi
     f7c:	5d                   	pop    %ebp
     f7d:	c3                   	ret    
     f7e:	66 90                	xchg   %ax,%ax
      printf(1, "panic at thread_join\n");
     f80:	83 ec 08             	sub    $0x8,%esp
     f83:	68 e9 18 00 00       	push   $0x18e9
     f88:	6a 01                	push   $0x1
     f8a:	e8 71 05 00 00       	call   1500 <printf>
     f8f:	83 c4 10             	add    $0x10,%esp
}
     f92:	8d 65 f8             	lea    -0x8(%ebp),%esp
      printf(1, "panic at thread_join\n");
     f95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     f9a:	5b                   	pop    %ebx
     f9b:	5e                   	pop    %esi
     f9c:	5d                   	pop    %ebp
     f9d:	c3                   	ret    
     f9e:	66 90                	xchg   %ax,%ax

00000fa0 <exectest>:
{
     fa0:	55                   	push   %ebp
     fa1:	89 e5                	mov    %esp,%ebp
     fa3:	57                   	push   %edi
     fa4:	56                   	push   %esi
     fa5:	8d 75 c0             	lea    -0x40(%ebp),%esi
     fa8:	53                   	push   %ebx
     fa9:	8d 7d e8             	lea    -0x18(%ebp),%edi
     fac:	83 ec 4c             	sub    $0x4c,%esp
     faf:	89 f3                	mov    %esi,%ebx
     fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (thread_create(&threads[i], execthreadmain, (void*)0) != 0){
     fb8:	83 ec 04             	sub    $0x4,%esp
     fbb:	6a 00                	push   $0x0
     fbd:	68 c0 06 00 00       	push   $0x6c0
     fc2:	53                   	push   %ebx
     fc3:	e8 72 04 00 00       	call   143a <thread_create>
     fc8:	83 c4 10             	add    $0x10,%esp
     fcb:	85 c0                	test   %eax,%eax
     fcd:	75 51                	jne    1020 <exectest+0x80>
     fcf:	83 c3 04             	add    $0x4,%ebx
  for (i = 0; i < NUM_THREAD; i++){
     fd2:	39 fb                	cmp    %edi,%ebx
     fd4:	75 e2                	jne    fb8 <exectest+0x18>
     fd6:	8d 7d bc             	lea    -0x44(%ebp),%edi
     fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (thread_join(threads[i], &retval) != 0){
     fe0:	83 ec 08             	sub    $0x8,%esp
     fe3:	57                   	push   %edi
     fe4:	ff 36                	pushl  (%esi)
     fe6:	e8 5f 04 00 00       	call   144a <thread_join>
     feb:	83 c4 10             	add    $0x10,%esp
     fee:	85 c0                	test   %eax,%eax
     ff0:	75 4e                	jne    1040 <exectest+0xa0>
     ff2:	83 c6 04             	add    $0x4,%esi
  for (i = 0; i < NUM_THREAD; i++){
     ff5:	39 de                	cmp    %ebx,%esi
     ff7:	75 e7                	jne    fe0 <exectest+0x40>
  printf(1, "panic at exectest\n");
     ff9:	83 ec 08             	sub    $0x8,%esp
     ffc:	89 45 b4             	mov    %eax,-0x4c(%ebp)
     fff:	68 ad 19 00 00       	push   $0x19ad
    1004:	6a 01                	push   $0x1
    1006:	e8 f5 04 00 00       	call   1500 <printf>
  return 0;
    100b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    100e:	83 c4 10             	add    $0x10,%esp
}
    1011:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1014:	5b                   	pop    %ebx
    1015:	5e                   	pop    %esi
    1016:	5f                   	pop    %edi
    1017:	5d                   	pop    %ebp
    1018:	c3                   	ret    
    1019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "panic at thread_create\n");
    1020:	83 ec 08             	sub    $0x8,%esp
    1023:	68 c1 18 00 00       	push   $0x18c1
    1028:	6a 01                	push   $0x1
    102a:	e8 d1 04 00 00       	call   1500 <printf>
      return -1;
    102f:	83 c4 10             	add    $0x10,%esp
}
    1032:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
    1035:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    103a:	5b                   	pop    %ebx
    103b:	5e                   	pop    %esi
    103c:	5f                   	pop    %edi
    103d:	5d                   	pop    %ebp
    103e:	c3                   	ret    
    103f:	90                   	nop
      printf(1, "panic at thread_join\n");
    1040:	83 ec 08             	sub    $0x8,%esp
    1043:	68 e9 18 00 00       	push   $0x18e9
    1048:	6a 01                	push   $0x1
    104a:	e8 b1 04 00 00       	call   1500 <printf>
    104f:	83 c4 10             	add    $0x10,%esp
}
    1052:	8d 65 f4             	lea    -0xc(%ebp),%esp
      printf(1, "panic at thread_join\n");
    1055:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    105a:	5b                   	pop    %ebx
    105b:	5e                   	pop    %esi
    105c:	5f                   	pop    %edi
    105d:	5d                   	pop    %ebp
    105e:	c3                   	ret    
    105f:	90                   	nop

00001060 <racingtest>:
{
    1060:	55                   	push   %ebp
    1061:	89 e5                	mov    %esp,%ebp
    1063:	56                   	push   %esi
    1064:	53                   	push   %ebx
  for (i = 0; i < NUM_THREAD; i++){
    1065:	31 db                	xor    %ebx,%ebx
{
    1067:	83 ec 40             	sub    $0x40,%esp
  gcnt = 0;
    106a:	c7 05 04 23 00 00 00 	movl   $0x0,0x2304
    1071:	00 00 00 
    1074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (thread_create(&threads[i], racingthreadmain, (void*)i) != 0){
    1078:	8d 44 9d d0          	lea    -0x30(%ebp,%ebx,4),%eax
    107c:	83 ec 04             	sub    $0x4,%esp
    107f:	53                   	push   %ebx
    1080:	68 d0 01 00 00       	push   $0x1d0
    1085:	50                   	push   %eax
    1086:	e8 af 03 00 00       	call   143a <thread_create>
    108b:	83 c4 10             	add    $0x10,%esp
    108e:	85 c0                	test   %eax,%eax
    1090:	89 c6                	mov    %eax,%esi
    1092:	75 5c                	jne    10f0 <racingtest+0x90>
  for (i = 0; i < NUM_THREAD; i++){
    1094:	83 c3 01             	add    $0x1,%ebx
    1097:	83 fb 0a             	cmp    $0xa,%ebx
    109a:	75 dc                	jne    1078 <racingtest+0x18>
    109c:	8d 5d cc             	lea    -0x34(%ebp),%ebx
    109f:	90                   	nop
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
    10a0:	83 ec 08             	sub    $0x8,%esp
    10a3:	53                   	push   %ebx
    10a4:	ff 74 b5 d0          	pushl  -0x30(%ebp,%esi,4)
    10a8:	e8 9d 03 00 00       	call   144a <thread_join>
    10ad:	83 c4 10             	add    $0x10,%esp
    10b0:	85 c0                	test   %eax,%eax
    10b2:	75 5c                	jne    1110 <racingtest+0xb0>
    10b4:	83 c6 01             	add    $0x1,%esi
    10b7:	39 75 cc             	cmp    %esi,-0x34(%ebp)
    10ba:	75 54                	jne    1110 <racingtest+0xb0>
  for (i = 0; i < NUM_THREAD; i++){
    10bc:	83 fe 0a             	cmp    $0xa,%esi
    10bf:	75 df                	jne    10a0 <racingtest+0x40>
  printf(1,"%d\n", gcnt);
    10c1:	8b 15 04 23 00 00    	mov    0x2304,%edx
    10c7:	83 ec 04             	sub    $0x4,%esp
    10ca:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    10cd:	52                   	push   %edx
    10ce:	68 a9 19 00 00       	push   $0x19a9
    10d3:	6a 01                	push   $0x1
    10d5:	e8 26 04 00 00       	call   1500 <printf>
  return 0;
    10da:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    10dd:	83 c4 10             	add    $0x10,%esp
}
    10e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    10e3:	5b                   	pop    %ebx
    10e4:	5e                   	pop    %esi
    10e5:	5d                   	pop    %ebp
    10e6:	c3                   	ret    
    10e7:	89 f6                	mov    %esi,%esi
    10e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      printf(1, "panic at thread_create\n");
    10f0:	83 ec 08             	sub    $0x8,%esp
    10f3:	68 c1 18 00 00       	push   $0x18c1
    10f8:	6a 01                	push   $0x1
    10fa:	e8 01 04 00 00       	call   1500 <printf>
      return -1;
    10ff:	83 c4 10             	add    $0x10,%esp
}
    1102:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return -1;
    1105:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    110a:	5b                   	pop    %ebx
    110b:	5e                   	pop    %esi
    110c:	5d                   	pop    %ebp
    110d:	c3                   	ret    
    110e:	66 90                	xchg   %ax,%ax
      printf(1, "panic at thread_join\n");
    1110:	83 ec 08             	sub    $0x8,%esp
    1113:	68 e9 18 00 00       	push   $0x18e9
    1118:	6a 01                	push   $0x1
    111a:	e8 e1 03 00 00       	call   1500 <printf>
    111f:	83 c4 10             	add    $0x10,%esp
}
    1122:	8d 65 f8             	lea    -0x8(%ebp),%esp
      printf(1, "panic at thread_join\n");
    1125:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    112a:	5b                   	pop    %ebx
    112b:	5e                   	pop    %esi
    112c:	5d                   	pop    %ebp
    112d:	c3                   	ret    
    112e:	66 90                	xchg   %ax,%ax

00001130 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    1130:	55                   	push   %ebp
    1131:	89 e5                	mov    %esp,%ebp
    1133:	53                   	push   %ebx
    1134:	8b 45 08             	mov    0x8(%ebp),%eax
    1137:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    113a:	89 c2                	mov    %eax,%edx
    113c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1140:	83 c1 01             	add    $0x1,%ecx
    1143:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    1147:	83 c2 01             	add    $0x1,%edx
    114a:	84 db                	test   %bl,%bl
    114c:	88 5a ff             	mov    %bl,-0x1(%edx)
    114f:	75 ef                	jne    1140 <strcpy+0x10>
    ;
  return os;
}
    1151:	5b                   	pop    %ebx
    1152:	5d                   	pop    %ebp
    1153:	c3                   	ret    
    1154:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    115a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00001160 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1160:	55                   	push   %ebp
    1161:	89 e5                	mov    %esp,%ebp
    1163:	53                   	push   %ebx
    1164:	8b 55 08             	mov    0x8(%ebp),%edx
    1167:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
    116a:	0f b6 02             	movzbl (%edx),%eax
    116d:	0f b6 19             	movzbl (%ecx),%ebx
    1170:	84 c0                	test   %al,%al
    1172:	75 1c                	jne    1190 <strcmp+0x30>
    1174:	eb 2a                	jmp    11a0 <strcmp+0x40>
    1176:	8d 76 00             	lea    0x0(%esi),%esi
    1179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
    1180:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    1183:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
    1186:	83 c1 01             	add    $0x1,%ecx
    1189:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
    118c:	84 c0                	test   %al,%al
    118e:	74 10                	je     11a0 <strcmp+0x40>
    1190:	38 d8                	cmp    %bl,%al
    1192:	74 ec                	je     1180 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
    1194:	29 d8                	sub    %ebx,%eax
}
    1196:	5b                   	pop    %ebx
    1197:	5d                   	pop    %ebp
    1198:	c3                   	ret    
    1199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11a0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
    11a2:	29 d8                	sub    %ebx,%eax
}
    11a4:	5b                   	pop    %ebx
    11a5:	5d                   	pop    %ebp
    11a6:	c3                   	ret    
    11a7:	89 f6                	mov    %esi,%esi
    11a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000011b0 <strlen>:

uint
strlen(const char *s)
{
    11b0:	55                   	push   %ebp
    11b1:	89 e5                	mov    %esp,%ebp
    11b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    11b6:	80 39 00             	cmpb   $0x0,(%ecx)
    11b9:	74 15                	je     11d0 <strlen+0x20>
    11bb:	31 d2                	xor    %edx,%edx
    11bd:	8d 76 00             	lea    0x0(%esi),%esi
    11c0:	83 c2 01             	add    $0x1,%edx
    11c3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    11c7:	89 d0                	mov    %edx,%eax
    11c9:	75 f5                	jne    11c0 <strlen+0x10>
    ;
  return n;
}
    11cb:	5d                   	pop    %ebp
    11cc:	c3                   	ret    
    11cd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
    11d0:	31 c0                	xor    %eax,%eax
}
    11d2:	5d                   	pop    %ebp
    11d3:	c3                   	ret    
    11d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    11da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000011e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11e0:	55                   	push   %ebp
    11e1:	89 e5                	mov    %esp,%ebp
    11e3:	57                   	push   %edi
    11e4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    11e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
    11ea:	8b 45 0c             	mov    0xc(%ebp),%eax
    11ed:	89 d7                	mov    %edx,%edi
    11ef:	fc                   	cld    
    11f0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    11f2:	89 d0                	mov    %edx,%eax
    11f4:	5f                   	pop    %edi
    11f5:	5d                   	pop    %ebp
    11f6:	c3                   	ret    
    11f7:	89 f6                	mov    %esi,%esi
    11f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001200 <strchr>:

char*
strchr(const char *s, char c)
{
    1200:	55                   	push   %ebp
    1201:	89 e5                	mov    %esp,%ebp
    1203:	53                   	push   %ebx
    1204:	8b 45 08             	mov    0x8(%ebp),%eax
    1207:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
    120a:	0f b6 10             	movzbl (%eax),%edx
    120d:	84 d2                	test   %dl,%dl
    120f:	74 1d                	je     122e <strchr+0x2e>
    if(*s == c)
    1211:	38 d3                	cmp    %dl,%bl
    1213:	89 d9                	mov    %ebx,%ecx
    1215:	75 0d                	jne    1224 <strchr+0x24>
    1217:	eb 17                	jmp    1230 <strchr+0x30>
    1219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1220:	38 ca                	cmp    %cl,%dl
    1222:	74 0c                	je     1230 <strchr+0x30>
  for(; *s; s++)
    1224:	83 c0 01             	add    $0x1,%eax
    1227:	0f b6 10             	movzbl (%eax),%edx
    122a:	84 d2                	test   %dl,%dl
    122c:	75 f2                	jne    1220 <strchr+0x20>
      return (char*)s;
  return 0;
    122e:	31 c0                	xor    %eax,%eax
}
    1230:	5b                   	pop    %ebx
    1231:	5d                   	pop    %ebp
    1232:	c3                   	ret    
    1233:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001240 <gets>:

char*
gets(char *buf, int max)
{
    1240:	55                   	push   %ebp
    1241:	89 e5                	mov    %esp,%ebp
    1243:	57                   	push   %edi
    1244:	56                   	push   %esi
    1245:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1246:	31 f6                	xor    %esi,%esi
    1248:	89 f3                	mov    %esi,%ebx
{
    124a:	83 ec 1c             	sub    $0x1c,%esp
    124d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
    1250:	eb 2f                	jmp    1281 <gets+0x41>
    1252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
    1258:	8d 45 e7             	lea    -0x19(%ebp),%eax
    125b:	83 ec 04             	sub    $0x4,%esp
    125e:	6a 01                	push   $0x1
    1260:	50                   	push   %eax
    1261:	6a 00                	push   $0x0
    1263:	e8 32 01 00 00       	call   139a <read>
    if(cc < 1)
    1268:	83 c4 10             	add    $0x10,%esp
    126b:	85 c0                	test   %eax,%eax
    126d:	7e 1c                	jle    128b <gets+0x4b>
      break;
    buf[i++] = c;
    126f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    1273:	83 c7 01             	add    $0x1,%edi
    1276:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
    1279:	3c 0a                	cmp    $0xa,%al
    127b:	74 23                	je     12a0 <gets+0x60>
    127d:	3c 0d                	cmp    $0xd,%al
    127f:	74 1f                	je     12a0 <gets+0x60>
  for(i=0; i+1 < max; ){
    1281:	83 c3 01             	add    $0x1,%ebx
    1284:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    1287:	89 fe                	mov    %edi,%esi
    1289:	7c cd                	jl     1258 <gets+0x18>
    128b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
    128d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
    1290:	c6 03 00             	movb   $0x0,(%ebx)
}
    1293:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1296:	5b                   	pop    %ebx
    1297:	5e                   	pop    %esi
    1298:	5f                   	pop    %edi
    1299:	5d                   	pop    %ebp
    129a:	c3                   	ret    
    129b:	90                   	nop
    129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    12a0:	8b 75 08             	mov    0x8(%ebp),%esi
    12a3:	8b 45 08             	mov    0x8(%ebp),%eax
    12a6:	01 de                	add    %ebx,%esi
    12a8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
    12aa:	c6 03 00             	movb   $0x0,(%ebx)
}
    12ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
    12b0:	5b                   	pop    %ebx
    12b1:	5e                   	pop    %esi
    12b2:	5f                   	pop    %edi
    12b3:	5d                   	pop    %ebp
    12b4:	c3                   	ret    
    12b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    12b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000012c0 <stat>:

int
stat(const char *n, struct stat *st)
{
    12c0:	55                   	push   %ebp
    12c1:	89 e5                	mov    %esp,%ebp
    12c3:	56                   	push   %esi
    12c4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12c5:	83 ec 08             	sub    $0x8,%esp
    12c8:	6a 00                	push   $0x0
    12ca:	ff 75 08             	pushl  0x8(%ebp)
    12cd:	e8 f0 00 00 00       	call   13c2 <open>
  if(fd < 0)
    12d2:	83 c4 10             	add    $0x10,%esp
    12d5:	85 c0                	test   %eax,%eax
    12d7:	78 27                	js     1300 <stat+0x40>
    return -1;
  r = fstat(fd, st);
    12d9:	83 ec 08             	sub    $0x8,%esp
    12dc:	ff 75 0c             	pushl  0xc(%ebp)
    12df:	89 c3                	mov    %eax,%ebx
    12e1:	50                   	push   %eax
    12e2:	e8 f3 00 00 00       	call   13da <fstat>
  close(fd);
    12e7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    12ea:	89 c6                	mov    %eax,%esi
  close(fd);
    12ec:	e8 b9 00 00 00       	call   13aa <close>
  return r;
    12f1:	83 c4 10             	add    $0x10,%esp
}
    12f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
    12f7:	89 f0                	mov    %esi,%eax
    12f9:	5b                   	pop    %ebx
    12fa:	5e                   	pop    %esi
    12fb:	5d                   	pop    %ebp
    12fc:	c3                   	ret    
    12fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
    1300:	be ff ff ff ff       	mov    $0xffffffff,%esi
    1305:	eb ed                	jmp    12f4 <stat+0x34>
    1307:	89 f6                	mov    %esi,%esi
    1309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001310 <atoi>:

int
atoi(const char *s)
{
    1310:	55                   	push   %ebp
    1311:	89 e5                	mov    %esp,%ebp
    1313:	53                   	push   %ebx
    1314:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1317:	0f be 11             	movsbl (%ecx),%edx
    131a:	8d 42 d0             	lea    -0x30(%edx),%eax
    131d:	3c 09                	cmp    $0x9,%al
  n = 0;
    131f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    1324:	77 1f                	ja     1345 <atoi+0x35>
    1326:	8d 76 00             	lea    0x0(%esi),%esi
    1329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
    1330:	8d 04 80             	lea    (%eax,%eax,4),%eax
    1333:	83 c1 01             	add    $0x1,%ecx
    1336:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    133a:	0f be 11             	movsbl (%ecx),%edx
    133d:	8d 5a d0             	lea    -0x30(%edx),%ebx
    1340:	80 fb 09             	cmp    $0x9,%bl
    1343:	76 eb                	jbe    1330 <atoi+0x20>
  return n;
}
    1345:	5b                   	pop    %ebx
    1346:	5d                   	pop    %ebp
    1347:	c3                   	ret    
    1348:	90                   	nop
    1349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001350 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1350:	55                   	push   %ebp
    1351:	89 e5                	mov    %esp,%ebp
    1353:	56                   	push   %esi
    1354:	53                   	push   %ebx
    1355:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1358:	8b 45 08             	mov    0x8(%ebp),%eax
    135b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    135e:	85 db                	test   %ebx,%ebx
    1360:	7e 14                	jle    1376 <memmove+0x26>
    1362:	31 d2                	xor    %edx,%edx
    1364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
    1368:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    136c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    136f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
    1372:	39 d3                	cmp    %edx,%ebx
    1374:	75 f2                	jne    1368 <memmove+0x18>
  return vdst;
}
    1376:	5b                   	pop    %ebx
    1377:	5e                   	pop    %esi
    1378:	5d                   	pop    %ebp
    1379:	c3                   	ret    

0000137a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    137a:	b8 01 00 00 00       	mov    $0x1,%eax
    137f:	cd 40                	int    $0x40
    1381:	c3                   	ret    

00001382 <exit>:
SYSCALL(exit)
    1382:	b8 02 00 00 00       	mov    $0x2,%eax
    1387:	cd 40                	int    $0x40
    1389:	c3                   	ret    

0000138a <wait>:
SYSCALL(wait)
    138a:	b8 03 00 00 00       	mov    $0x3,%eax
    138f:	cd 40                	int    $0x40
    1391:	c3                   	ret    

00001392 <pipe>:
SYSCALL(pipe)
    1392:	b8 04 00 00 00       	mov    $0x4,%eax
    1397:	cd 40                	int    $0x40
    1399:	c3                   	ret    

0000139a <read>:
SYSCALL(read)
    139a:	b8 05 00 00 00       	mov    $0x5,%eax
    139f:	cd 40                	int    $0x40
    13a1:	c3                   	ret    

000013a2 <write>:
SYSCALL(write)
    13a2:	b8 10 00 00 00       	mov    $0x10,%eax
    13a7:	cd 40                	int    $0x40
    13a9:	c3                   	ret    

000013aa <close>:
SYSCALL(close)
    13aa:	b8 15 00 00 00       	mov    $0x15,%eax
    13af:	cd 40                	int    $0x40
    13b1:	c3                   	ret    

000013b2 <kill>:
SYSCALL(kill)
    13b2:	b8 06 00 00 00       	mov    $0x6,%eax
    13b7:	cd 40                	int    $0x40
    13b9:	c3                   	ret    

000013ba <exec>:
SYSCALL(exec)
    13ba:	b8 07 00 00 00       	mov    $0x7,%eax
    13bf:	cd 40                	int    $0x40
    13c1:	c3                   	ret    

000013c2 <open>:
SYSCALL(open)
    13c2:	b8 0f 00 00 00       	mov    $0xf,%eax
    13c7:	cd 40                	int    $0x40
    13c9:	c3                   	ret    

000013ca <mknod>:
SYSCALL(mknod)
    13ca:	b8 11 00 00 00       	mov    $0x11,%eax
    13cf:	cd 40                	int    $0x40
    13d1:	c3                   	ret    

000013d2 <unlink>:
SYSCALL(unlink)
    13d2:	b8 12 00 00 00       	mov    $0x12,%eax
    13d7:	cd 40                	int    $0x40
    13d9:	c3                   	ret    

000013da <fstat>:
SYSCALL(fstat)
    13da:	b8 08 00 00 00       	mov    $0x8,%eax
    13df:	cd 40                	int    $0x40
    13e1:	c3                   	ret    

000013e2 <link>:
SYSCALL(link)
    13e2:	b8 13 00 00 00       	mov    $0x13,%eax
    13e7:	cd 40                	int    $0x40
    13e9:	c3                   	ret    

000013ea <mkdir>:
SYSCALL(mkdir)
    13ea:	b8 14 00 00 00       	mov    $0x14,%eax
    13ef:	cd 40                	int    $0x40
    13f1:	c3                   	ret    

000013f2 <chdir>:
SYSCALL(chdir)
    13f2:	b8 09 00 00 00       	mov    $0x9,%eax
    13f7:	cd 40                	int    $0x40
    13f9:	c3                   	ret    

000013fa <dup>:
SYSCALL(dup)
    13fa:	b8 0a 00 00 00       	mov    $0xa,%eax
    13ff:	cd 40                	int    $0x40
    1401:	c3                   	ret    

00001402 <getpid>:
SYSCALL(getpid)
    1402:	b8 0b 00 00 00       	mov    $0xb,%eax
    1407:	cd 40                	int    $0x40
    1409:	c3                   	ret    

0000140a <sbrk>:
SYSCALL(sbrk)
    140a:	b8 0c 00 00 00       	mov    $0xc,%eax
    140f:	cd 40                	int    $0x40
    1411:	c3                   	ret    

00001412 <sleep>:
SYSCALL(sleep)
    1412:	b8 0d 00 00 00       	mov    $0xd,%eax
    1417:	cd 40                	int    $0x40
    1419:	c3                   	ret    

0000141a <uptime>:
SYSCALL(uptime)
    141a:	b8 0e 00 00 00       	mov    $0xe,%eax
    141f:	cd 40                	int    $0x40
    1421:	c3                   	ret    

00001422 <getlev>:
SYSCALL(getlev)
    1422:	b8 16 00 00 00       	mov    $0x16,%eax
    1427:	cd 40                	int    $0x40
    1429:	c3                   	ret    

0000142a <yield>:
SYSCALL(yield)
    142a:	b8 17 00 00 00       	mov    $0x17,%eax
    142f:	cd 40                	int    $0x40
    1431:	c3                   	ret    

00001432 <set_cpu_share>:
SYSCALL(set_cpu_share)
    1432:	b8 18 00 00 00       	mov    $0x18,%eax
    1437:	cd 40                	int    $0x40
    1439:	c3                   	ret    

0000143a <thread_create>:
SYSCALL(thread_create)
    143a:	b8 19 00 00 00       	mov    $0x19,%eax
    143f:	cd 40                	int    $0x40
    1441:	c3                   	ret    

00001442 <thread_exit>:
SYSCALL(thread_exit)
    1442:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1447:	cd 40                	int    $0x40
    1449:	c3                   	ret    

0000144a <thread_join>:
SYSCALL(thread_join)
    144a:	b8 1b 00 00 00       	mov    $0x1b,%eax
    144f:	cd 40                	int    $0x40
    1451:	c3                   	ret    
    1452:	66 90                	xchg   %ax,%ax
    1454:	66 90                	xchg   %ax,%ax
    1456:	66 90                	xchg   %ax,%ax
    1458:	66 90                	xchg   %ax,%ax
    145a:	66 90                	xchg   %ax,%ax
    145c:	66 90                	xchg   %ax,%ax
    145e:	66 90                	xchg   %ax,%ax

00001460 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1460:	55                   	push   %ebp
    1461:	89 e5                	mov    %esp,%ebp
    1463:	57                   	push   %edi
    1464:	56                   	push   %esi
    1465:	53                   	push   %ebx
    1466:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1469:	85 d2                	test   %edx,%edx
{
    146b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
    146e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
    1470:	79 76                	jns    14e8 <printint+0x88>
    1472:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    1476:	74 70                	je     14e8 <printint+0x88>
    x = -xx;
    1478:	f7 d8                	neg    %eax
    neg = 1;
    147a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    1481:	31 f6                	xor    %esi,%esi
    1483:	8d 5d d7             	lea    -0x29(%ebp),%ebx
    1486:	eb 0a                	jmp    1492 <printint+0x32>
    1488:	90                   	nop
    1489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
    1490:	89 fe                	mov    %edi,%esi
    1492:	31 d2                	xor    %edx,%edx
    1494:	8d 7e 01             	lea    0x1(%esi),%edi
    1497:	f7 f1                	div    %ecx
    1499:	0f b6 92 c0 1a 00 00 	movzbl 0x1ac0(%edx),%edx
  }while((x /= base) != 0);
    14a0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
    14a2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
    14a5:	75 e9                	jne    1490 <printint+0x30>
  if(neg)
    14a7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    14aa:	85 c0                	test   %eax,%eax
    14ac:	74 08                	je     14b6 <printint+0x56>
    buf[i++] = '-';
    14ae:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    14b3:	8d 7e 02             	lea    0x2(%esi),%edi
    14b6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
    14ba:	8b 7d c0             	mov    -0x40(%ebp),%edi
    14bd:	8d 76 00             	lea    0x0(%esi),%esi
    14c0:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
    14c3:	83 ec 04             	sub    $0x4,%esp
    14c6:	83 ee 01             	sub    $0x1,%esi
    14c9:	6a 01                	push   $0x1
    14cb:	53                   	push   %ebx
    14cc:	57                   	push   %edi
    14cd:	88 45 d7             	mov    %al,-0x29(%ebp)
    14d0:	e8 cd fe ff ff       	call   13a2 <write>

  while(--i >= 0)
    14d5:	83 c4 10             	add    $0x10,%esp
    14d8:	39 de                	cmp    %ebx,%esi
    14da:	75 e4                	jne    14c0 <printint+0x60>
    putc(fd, buf[i]);
}
    14dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    14df:	5b                   	pop    %ebx
    14e0:	5e                   	pop    %esi
    14e1:	5f                   	pop    %edi
    14e2:	5d                   	pop    %ebp
    14e3:	c3                   	ret    
    14e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    14e8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    14ef:	eb 90                	jmp    1481 <printint+0x21>
    14f1:	eb 0d                	jmp    1500 <printf>
    14f3:	90                   	nop
    14f4:	90                   	nop
    14f5:	90                   	nop
    14f6:	90                   	nop
    14f7:	90                   	nop
    14f8:	90                   	nop
    14f9:	90                   	nop
    14fa:	90                   	nop
    14fb:	90                   	nop
    14fc:	90                   	nop
    14fd:	90                   	nop
    14fe:	90                   	nop
    14ff:	90                   	nop

00001500 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1500:	55                   	push   %ebp
    1501:	89 e5                	mov    %esp,%ebp
    1503:	57                   	push   %edi
    1504:	56                   	push   %esi
    1505:	53                   	push   %ebx
    1506:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1509:	8b 75 0c             	mov    0xc(%ebp),%esi
    150c:	0f b6 1e             	movzbl (%esi),%ebx
    150f:	84 db                	test   %bl,%bl
    1511:	0f 84 b3 00 00 00    	je     15ca <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
    1517:	8d 45 10             	lea    0x10(%ebp),%eax
    151a:	83 c6 01             	add    $0x1,%esi
  state = 0;
    151d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
    151f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1522:	eb 2f                	jmp    1553 <printf+0x53>
    1524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    1528:	83 f8 25             	cmp    $0x25,%eax
    152b:	0f 84 a7 00 00 00    	je     15d8 <printf+0xd8>
  write(fd, &c, 1);
    1531:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    1534:	83 ec 04             	sub    $0x4,%esp
    1537:	88 5d e2             	mov    %bl,-0x1e(%ebp)
    153a:	6a 01                	push   $0x1
    153c:	50                   	push   %eax
    153d:	ff 75 08             	pushl  0x8(%ebp)
    1540:	e8 5d fe ff ff       	call   13a2 <write>
    1545:	83 c4 10             	add    $0x10,%esp
    1548:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
    154b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    154f:	84 db                	test   %bl,%bl
    1551:	74 77                	je     15ca <printf+0xca>
    if(state == 0){
    1553:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
    1555:	0f be cb             	movsbl %bl,%ecx
    1558:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    155b:	74 cb                	je     1528 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    155d:	83 ff 25             	cmp    $0x25,%edi
    1560:	75 e6                	jne    1548 <printf+0x48>
      if(c == 'd'){
    1562:	83 f8 64             	cmp    $0x64,%eax
    1565:	0f 84 05 01 00 00    	je     1670 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    156b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
    1571:	83 f9 70             	cmp    $0x70,%ecx
    1574:	74 72                	je     15e8 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    1576:	83 f8 73             	cmp    $0x73,%eax
    1579:	0f 84 99 00 00 00    	je     1618 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    157f:	83 f8 63             	cmp    $0x63,%eax
    1582:	0f 84 08 01 00 00    	je     1690 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    1588:	83 f8 25             	cmp    $0x25,%eax
    158b:	0f 84 ef 00 00 00    	je     1680 <printf+0x180>
  write(fd, &c, 1);
    1591:	8d 45 e7             	lea    -0x19(%ebp),%eax
    1594:	83 ec 04             	sub    $0x4,%esp
    1597:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    159b:	6a 01                	push   $0x1
    159d:	50                   	push   %eax
    159e:	ff 75 08             	pushl  0x8(%ebp)
    15a1:	e8 fc fd ff ff       	call   13a2 <write>
    15a6:	83 c4 0c             	add    $0xc,%esp
    15a9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    15ac:	88 5d e6             	mov    %bl,-0x1a(%ebp)
    15af:	6a 01                	push   $0x1
    15b1:	50                   	push   %eax
    15b2:	ff 75 08             	pushl  0x8(%ebp)
    15b5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    15b8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
    15ba:	e8 e3 fd ff ff       	call   13a2 <write>
  for(i = 0; fmt[i]; i++){
    15bf:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
    15c3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    15c6:	84 db                	test   %bl,%bl
    15c8:	75 89                	jne    1553 <printf+0x53>
    }
  }
}
    15ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
    15cd:	5b                   	pop    %ebx
    15ce:	5e                   	pop    %esi
    15cf:	5f                   	pop    %edi
    15d0:	5d                   	pop    %ebp
    15d1:	c3                   	ret    
    15d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
    15d8:	bf 25 00 00 00       	mov    $0x25,%edi
    15dd:	e9 66 ff ff ff       	jmp    1548 <printf+0x48>
    15e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
    15e8:	83 ec 0c             	sub    $0xc,%esp
    15eb:	b9 10 00 00 00       	mov    $0x10,%ecx
    15f0:	6a 00                	push   $0x0
    15f2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    15f5:	8b 45 08             	mov    0x8(%ebp),%eax
    15f8:	8b 17                	mov    (%edi),%edx
    15fa:	e8 61 fe ff ff       	call   1460 <printint>
        ap++;
    15ff:	89 f8                	mov    %edi,%eax
    1601:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1604:	31 ff                	xor    %edi,%edi
        ap++;
    1606:	83 c0 04             	add    $0x4,%eax
    1609:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    160c:	e9 37 ff ff ff       	jmp    1548 <printf+0x48>
    1611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
    1618:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    161b:	8b 08                	mov    (%eax),%ecx
        ap++;
    161d:	83 c0 04             	add    $0x4,%eax
    1620:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
    1623:	85 c9                	test   %ecx,%ecx
    1625:	0f 84 8e 00 00 00    	je     16b9 <printf+0x1b9>
        while(*s != 0){
    162b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
    162e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
    1630:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
    1632:	84 c0                	test   %al,%al
    1634:	0f 84 0e ff ff ff    	je     1548 <printf+0x48>
    163a:	89 75 d0             	mov    %esi,-0x30(%ebp)
    163d:	89 de                	mov    %ebx,%esi
    163f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1642:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    1645:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
    1648:	83 ec 04             	sub    $0x4,%esp
          s++;
    164b:	83 c6 01             	add    $0x1,%esi
    164e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
    1651:	6a 01                	push   $0x1
    1653:	57                   	push   %edi
    1654:	53                   	push   %ebx
    1655:	e8 48 fd ff ff       	call   13a2 <write>
        while(*s != 0){
    165a:	0f b6 06             	movzbl (%esi),%eax
    165d:	83 c4 10             	add    $0x10,%esp
    1660:	84 c0                	test   %al,%al
    1662:	75 e4                	jne    1648 <printf+0x148>
    1664:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
    1667:	31 ff                	xor    %edi,%edi
    1669:	e9 da fe ff ff       	jmp    1548 <printf+0x48>
    166e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
    1670:	83 ec 0c             	sub    $0xc,%esp
    1673:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1678:	6a 01                	push   $0x1
    167a:	e9 73 ff ff ff       	jmp    15f2 <printf+0xf2>
    167f:	90                   	nop
  write(fd, &c, 1);
    1680:	83 ec 04             	sub    $0x4,%esp
    1683:	88 5d e5             	mov    %bl,-0x1b(%ebp)
    1686:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1689:	6a 01                	push   $0x1
    168b:	e9 21 ff ff ff       	jmp    15b1 <printf+0xb1>
        putc(fd, *ap);
    1690:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
    1693:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    1696:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
    1698:	6a 01                	push   $0x1
        ap++;
    169a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
    169d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    16a0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    16a3:	50                   	push   %eax
    16a4:	ff 75 08             	pushl  0x8(%ebp)
    16a7:	e8 f6 fc ff ff       	call   13a2 <write>
        ap++;
    16ac:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    16af:	83 c4 10             	add    $0x10,%esp
      state = 0;
    16b2:	31 ff                	xor    %edi,%edi
    16b4:	e9 8f fe ff ff       	jmp    1548 <printf+0x48>
          s = "(null)";
    16b9:	bb b8 1a 00 00       	mov    $0x1ab8,%ebx
        while(*s != 0){
    16be:	b8 28 00 00 00       	mov    $0x28,%eax
    16c3:	e9 72 ff ff ff       	jmp    163a <printf+0x13a>
    16c8:	66 90                	xchg   %ax,%ax
    16ca:	66 90                	xchg   %ax,%ax
    16cc:	66 90                	xchg   %ax,%ax
    16ce:	66 90                	xchg   %ax,%ax

000016d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    16d0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16d1:	a1 f8 22 00 00       	mov    0x22f8,%eax
{
    16d6:	89 e5                	mov    %esp,%ebp
    16d8:	57                   	push   %edi
    16d9:	56                   	push   %esi
    16da:	53                   	push   %ebx
    16db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
    16de:	8d 4b f8             	lea    -0x8(%ebx),%ecx
    16e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16e8:	39 c8                	cmp    %ecx,%eax
    16ea:	8b 10                	mov    (%eax),%edx
    16ec:	73 32                	jae    1720 <free+0x50>
    16ee:	39 d1                	cmp    %edx,%ecx
    16f0:	72 04                	jb     16f6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16f2:	39 d0                	cmp    %edx,%eax
    16f4:	72 32                	jb     1728 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
    16f6:	8b 73 fc             	mov    -0x4(%ebx),%esi
    16f9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    16fc:	39 fa                	cmp    %edi,%edx
    16fe:	74 30                	je     1730 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1700:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1703:	8b 50 04             	mov    0x4(%eax),%edx
    1706:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1709:	39 f1                	cmp    %esi,%ecx
    170b:	74 3a                	je     1747 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    170d:	89 08                	mov    %ecx,(%eax)
  freep = p;
    170f:	a3 f8 22 00 00       	mov    %eax,0x22f8
}
    1714:	5b                   	pop    %ebx
    1715:	5e                   	pop    %esi
    1716:	5f                   	pop    %edi
    1717:	5d                   	pop    %ebp
    1718:	c3                   	ret    
    1719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1720:	39 d0                	cmp    %edx,%eax
    1722:	72 04                	jb     1728 <free+0x58>
    1724:	39 d1                	cmp    %edx,%ecx
    1726:	72 ce                	jb     16f6 <free+0x26>
{
    1728:	89 d0                	mov    %edx,%eax
    172a:	eb bc                	jmp    16e8 <free+0x18>
    172c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
    1730:	03 72 04             	add    0x4(%edx),%esi
    1733:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1736:	8b 10                	mov    (%eax),%edx
    1738:	8b 12                	mov    (%edx),%edx
    173a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    173d:	8b 50 04             	mov    0x4(%eax),%edx
    1740:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1743:	39 f1                	cmp    %esi,%ecx
    1745:	75 c6                	jne    170d <free+0x3d>
    p->s.size += bp->s.size;
    1747:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    174a:	a3 f8 22 00 00       	mov    %eax,0x22f8
    p->s.size += bp->s.size;
    174f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1752:	8b 53 f8             	mov    -0x8(%ebx),%edx
    1755:	89 10                	mov    %edx,(%eax)
}
    1757:	5b                   	pop    %ebx
    1758:	5e                   	pop    %esi
    1759:	5f                   	pop    %edi
    175a:	5d                   	pop    %ebp
    175b:	c3                   	ret    
    175c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001760 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1760:	55                   	push   %ebp
    1761:	89 e5                	mov    %esp,%ebp
    1763:	57                   	push   %edi
    1764:	56                   	push   %esi
    1765:	53                   	push   %ebx
    1766:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1769:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    176c:	8b 15 f8 22 00 00    	mov    0x22f8,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1772:	8d 78 07             	lea    0x7(%eax),%edi
    1775:	c1 ef 03             	shr    $0x3,%edi
    1778:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
    177b:	85 d2                	test   %edx,%edx
    177d:	0f 84 9d 00 00 00    	je     1820 <malloc+0xc0>
    1783:	8b 02                	mov    (%edx),%eax
    1785:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    1788:	39 cf                	cmp    %ecx,%edi
    178a:	76 6c                	jbe    17f8 <malloc+0x98>
    178c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
    1792:	bb 00 10 00 00       	mov    $0x1000,%ebx
    1797:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
    179a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
    17a1:	eb 0e                	jmp    17b1 <malloc+0x51>
    17a3:	90                   	nop
    17a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17a8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    17aa:	8b 48 04             	mov    0x4(%eax),%ecx
    17ad:	39 f9                	cmp    %edi,%ecx
    17af:	73 47                	jae    17f8 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    17b1:	39 05 f8 22 00 00    	cmp    %eax,0x22f8
    17b7:	89 c2                	mov    %eax,%edx
    17b9:	75 ed                	jne    17a8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
    17bb:	83 ec 0c             	sub    $0xc,%esp
    17be:	56                   	push   %esi
    17bf:	e8 46 fc ff ff       	call   140a <sbrk>
  if(p == (char*)-1)
    17c4:	83 c4 10             	add    $0x10,%esp
    17c7:	83 f8 ff             	cmp    $0xffffffff,%eax
    17ca:	74 1c                	je     17e8 <malloc+0x88>
  hp->s.size = nu;
    17cc:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    17cf:	83 ec 0c             	sub    $0xc,%esp
    17d2:	83 c0 08             	add    $0x8,%eax
    17d5:	50                   	push   %eax
    17d6:	e8 f5 fe ff ff       	call   16d0 <free>
  return freep;
    17db:	8b 15 f8 22 00 00    	mov    0x22f8,%edx
      if((p = morecore(nunits)) == 0)
    17e1:	83 c4 10             	add    $0x10,%esp
    17e4:	85 d2                	test   %edx,%edx
    17e6:	75 c0                	jne    17a8 <malloc+0x48>
        return 0;
  }
}
    17e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    17eb:	31 c0                	xor    %eax,%eax
}
    17ed:	5b                   	pop    %ebx
    17ee:	5e                   	pop    %esi
    17ef:	5f                   	pop    %edi
    17f0:	5d                   	pop    %ebp
    17f1:	c3                   	ret    
    17f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    17f8:	39 cf                	cmp    %ecx,%edi
    17fa:	74 54                	je     1850 <malloc+0xf0>
        p->s.size -= nunits;
    17fc:	29 f9                	sub    %edi,%ecx
    17fe:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    1801:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    1804:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
    1807:	89 15 f8 22 00 00    	mov    %edx,0x22f8
}
    180d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    1810:	83 c0 08             	add    $0x8,%eax
}
    1813:	5b                   	pop    %ebx
    1814:	5e                   	pop    %esi
    1815:	5f                   	pop    %edi
    1816:	5d                   	pop    %ebp
    1817:	c3                   	ret    
    1818:	90                   	nop
    1819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    1820:	c7 05 f8 22 00 00 fc 	movl   $0x22fc,0x22f8
    1827:	22 00 00 
    182a:	c7 05 fc 22 00 00 fc 	movl   $0x22fc,0x22fc
    1831:	22 00 00 
    base.s.size = 0;
    1834:	b8 fc 22 00 00       	mov    $0x22fc,%eax
    1839:	c7 05 00 23 00 00 00 	movl   $0x0,0x2300
    1840:	00 00 00 
    1843:	e9 44 ff ff ff       	jmp    178c <malloc+0x2c>
    1848:	90                   	nop
    1849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
    1850:	8b 08                	mov    (%eax),%ecx
    1852:	89 0a                	mov    %ecx,(%edx)
    1854:	eb b1                	jmp    1807 <malloc+0xa7>
