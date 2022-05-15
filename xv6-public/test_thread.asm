
_test_thread:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  "stresstest",
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
  22:	be 04 00 00 00       	mov    $0x4,%esi
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
  3f:	e8 f6 08 00 00       	call   93a <fork>
  44:	85 c0                	test   %eax,%eax
  46:	0f 88 10 01 00 00    	js     15c <main+0x15c>
    if (pid == 0){
  4c:	0f 84 1d 01 00 00    	je     16f <main+0x16f>
      close(gpipe[1]);
  52:	83 ec 0c             	sub    $0xc,%esp
  55:	ff 35 ac 13 00 00    	pushl  0x13ac
  5b:	e8 0a 09 00 00       	call   96a <close>
      if (wait() == -1 || read(gpipe[0], (char*)&ret, sizeof(ret)) == -1 || ret != 0){
  60:	e8 e5 08 00 00       	call   94a <wait>
  65:	83 c4 10             	add    $0x10,%esp
  68:	83 f8 ff             	cmp    $0xffffffff,%eax
  6b:	0f 84 d2 00 00 00    	je     143 <main+0x143>
  71:	83 ec 04             	sub    $0x4,%esp
  74:	6a 04                	push   $0x4
  76:	57                   	push   %edi
  77:	ff 35 a8 13 00 00    	pushl  0x13a8
  7d:	e8 d8 08 00 00       	call   95a <read>
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
  9c:	ff 35 a8 13 00 00    	pushl  0x13a8
  a2:	e8 c3 08 00 00       	call   96a <close>
    }
    printf(1,"%d. %s finish\n", i, testname[i]);
  a7:	ff 34 9d 70 13 00 00 	pushl  0x1370(,%ebx,4)
  ae:	53                   	push   %ebx
  for (i = start; i <= end; i++){
  af:	83 c3 01             	add    $0x1,%ebx
    printf(1,"%d. %s finish\n", i, testname[i]);
  b2:	68 a1 0e 00 00       	push   $0xea1
  b7:	6a 01                	push   $0x1
  b9:	e8 02 0a 00 00       	call   ac0 <printf>
    sleep(100);
  be:	83 c4 14             	add    $0x14,%esp
  c1:	6a 64                	push   $0x64
  c3:	e8 0a 09 00 00       	call   9d2 <sleep>
  for (i = start; i <= end; i++){
  c8:	83 c4 10             	add    $0x10,%esp
  cb:	39 f3                	cmp    %esi,%ebx
  cd:	7f 6f                	jg     13e <main+0x13e>
    printf(1,"%d. %s start\n", i, testname[i]);
  cf:	ff 34 9d 70 13 00 00 	pushl  0x1370(,%ebx,4)
  d6:	53                   	push   %ebx
  d7:	68 6d 0e 00 00       	push   $0xe6d
  dc:	6a 01                	push   $0x1
  de:	e8 dd 09 00 00       	call   ac0 <printf>
    if (pipe(gpipe) < 0){
  e3:	c7 04 24 a8 13 00 00 	movl   $0x13a8,(%esp)
  ea:	e8 63 08 00 00       	call   952 <pipe>
  ef:	83 c4 10             	add    $0x10,%esp
  f2:	85 c0                	test   %eax,%eax
  f4:	0f 89 3e ff ff ff    	jns    38 <main+0x38>
      printf(1,"pipe panic\n");
  fa:	53                   	push   %ebx
  fb:	53                   	push   %ebx
  fc:	68 7b 0e 00 00       	push   $0xe7b
 101:	6a 01                	push   $0x1
 103:	e8 b8 09 00 00       	call   ac0 <printf>
      exit();
 108:	e8 35 08 00 00       	call   942 <exit>
    start = atoi(argv[1]);
 10d:	83 ec 0c             	sub    $0xc,%esp
 110:	ff 77 04             	pushl  0x4(%edi)
 113:	e8 b8 07 00 00       	call   8d0 <atoi>
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
 12c:	e8 9f 07 00 00       	call   8d0 <atoi>
 131:	83 c4 10             	add    $0x10,%esp
 134:	89 c6                	mov    %eax,%esi
  for (i = start; i <= end; i++){
 136:	39 de                	cmp    %ebx,%esi
 138:	0f 8d eb fe ff ff    	jge    29 <main+0x29>
  }
  exit();
 13e:	e8 ff 07 00 00       	call   942 <exit>
        printf(1,"%d. %s panic\n", i, testname[i]);
 143:	ff 34 9d 70 13 00 00 	pushl  0x1370(,%ebx,4)
 14a:	53                   	push   %ebx
 14b:	68 93 0e 00 00       	push   $0xe93
 150:	6a 01                	push   $0x1
 152:	e8 69 09 00 00       	call   ac0 <printf>
        exit();
 157:	e8 e6 07 00 00       	call   942 <exit>
      printf(1,"fork panic\n");
 15c:	51                   	push   %ecx
 15d:	51                   	push   %ecx
 15e:	68 87 0e 00 00       	push   $0xe87
 163:	6a 01                	push   $0x1
 165:	e8 56 09 00 00       	call   ac0 <printf>
      exit();
 16a:	e8 d3 07 00 00       	call   942 <exit>
      close(gpipe[0]);
 16f:	83 ec 0c             	sub    $0xc,%esp
 172:	ff 35 a8 13 00 00    	pushl  0x13a8
 178:	e8 ed 07 00 00       	call   96a <close>
      ret = testfunc[i]();
 17d:	ff 14 9d 84 13 00 00 	call   *0x1384(,%ebx,4)
 184:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      write(gpipe[1], (char*)&ret, sizeof(ret));
 187:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 18a:	83 c4 0c             	add    $0xc,%esp
 18d:	6a 04                	push   $0x4
 18f:	50                   	push   %eax
 190:	ff 35 ac 13 00 00    	pushl  0x13ac
 196:	e8 c7 07 00 00       	call   962 <write>
      close(gpipe[1]);
 19b:	5a                   	pop    %edx
 19c:	ff 35 ac 13 00 00    	pushl  0x13ac
 1a2:	e8 c3 07 00 00       	call   96a <close>
      exit();
 1a7:	e8 96 07 00 00       	call   942 <exit>
  int end = NTEST-1;
 1ac:	be 04 00 00 00       	mov    $0x4,%esi
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
  //int j;
  int tmp;
  for (i = 0; i < 10000000; i++){
    tmp = gcnt;
 1e0:	a1 a4 13 00 00       	mov    0x13a4,%eax
    tmp++;
 1e5:	83 c0 01             	add    $0x1,%eax
	asm volatile("call %P0"::"i"(nop));
 1e8:	e8 d3 ff ff ff       	call   1c0 <nop>
  for (i = 0; i < 10000000; i++){
 1ed:	83 ea 01             	sub    $0x1,%edx
    gcnt = tmp;
 1f0:	a3 a4 13 00 00       	mov    %eax,0x13a4
  for (i = 0; i < 10000000; i++){
 1f5:	75 e9                	jne    1e0 <racingthreadmain+0x10>
  }
  thread_exit((void *)(tid+1));
 1f7:	8b 45 08             	mov    0x8(%ebp),%eax
 1fa:	83 ec 0c             	sub    $0xc,%esp
 1fd:	83 c0 01             	add    $0x1,%eax
 200:	50                   	push   %eax
 201:	e8 fc 07 00 00       	call   a02 <thread_exit>
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
 24b:	68 18 0e 00 00       	push   $0xe18
 250:	6a 01                	push   $0x1
 252:	e8 69 08 00 00       	call   ac0 <printf>
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
 269:	e8 94 07 00 00       	call   a02 <thread_exit>
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
 27b:	e8 52 07 00 00       	call   9d2 <sleep>
  printf(1, "thread_exit...\n");
 280:	58                   	pop    %eax
 281:	5a                   	pop    %edx
 282:	68 1b 0e 00 00       	push   $0xe1b
 287:	6a 01                	push   $0x1
 289:	e8 32 08 00 00       	call   ac0 <printf>
  thread_exit((void *)(val*2));
 28e:	8b 45 08             	mov    0x8(%ebp),%eax
 291:	01 c0                	add    %eax,%eax
 293:	89 04 24             	mov    %eax,(%esp)
 296:	e8 67 07 00 00       	call   a02 <thread_exit>
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
 2a8:	e8 55 07 00 00       	call   a02 <thread_exit>
 2ad:	8d 76 00             	lea    0x0(%esi),%esi

000002b0 <jointest2>:
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	56                   	push   %esi
 2b4:	53                   	push   %ebx
 2b5:	8d 75 cc             	lea    -0x34(%ebp),%esi
  for (i = 1; i <= NUM_THREAD; i++){
 2b8:	bb 01 00 00 00       	mov    $0x1,%ebx
{
 2bd:	83 ec 40             	sub    $0x40,%esp
    if (thread_create(&threads[i-1], jointhreadmain, (void*)(i)) != 0){
 2c0:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
 2c3:	83 ec 04             	sub    $0x4,%esp
 2c6:	53                   	push   %ebx
 2c7:	68 70 02 00 00       	push   $0x270
 2cc:	50                   	push   %eax
 2cd:	e8 28 07 00 00       	call   9fa <thread_create>
 2d2:	83 c4 10             	add    $0x10,%esp
 2d5:	85 c0                	test   %eax,%eax
 2d7:	75 77                	jne    350 <jointest2+0xa0>
  for (i = 1; i <= NUM_THREAD; i++){
 2d9:	83 c3 01             	add    $0x1,%ebx
 2dc:	83 fb 0b             	cmp    $0xb,%ebx
 2df:	75 df                	jne    2c0 <jointest2+0x10>
  sleep(500);
 2e1:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "thread_join!!!\n");
 2e4:	bb 02 00 00 00       	mov    $0x2,%ebx
  sleep(500);
 2e9:	68 f4 01 00 00       	push   $0x1f4
 2ee:	e8 df 06 00 00       	call   9d2 <sleep>
  printf(1, "thread_join!!!\n");
 2f3:	58                   	pop    %eax
 2f4:	5a                   	pop    %edx
 2f5:	68 43 0e 00 00       	push   $0xe43
 2fa:	6a 01                	push   $0x1
 2fc:	e8 bf 07 00 00       	call   ac0 <printf>
 301:	83 c4 10             	add    $0x10,%esp
 304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
 308:	83 ec 08             	sub    $0x8,%esp
 30b:	56                   	push   %esi
 30c:	ff 74 5d cc          	pushl  -0x34(%ebp,%ebx,2)
 310:	e8 f5 06 00 00       	call   a0a <thread_join>
 315:	83 c4 10             	add    $0x10,%esp
 318:	85 c0                	test   %eax,%eax
 31a:	75 54                	jne    370 <jointest2+0xc0>
 31c:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
 31f:	75 4f                	jne    370 <jointest2+0xc0>
 321:	83 c3 02             	add    $0x2,%ebx
  for (i = 1; i <= NUM_THREAD; i++){
 324:	83 fb 16             	cmp    $0x16,%ebx
 327:	75 df                	jne    308 <jointest2+0x58>
  printf(1,"\n");
 329:	83 ec 08             	sub    $0x8,%esp
 32c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 32f:	68 51 0e 00 00       	push   $0xe51
 334:	6a 01                	push   $0x1
 336:	e8 85 07 00 00       	call   ac0 <printf>
  return 0;
 33b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 33e:	83 c4 10             	add    $0x10,%esp
}
 341:	8d 65 f8             	lea    -0x8(%ebp),%esp
 344:	5b                   	pop    %ebx
 345:	5e                   	pop    %esi
 346:	5d                   	pop    %ebp
 347:	c3                   	ret    
 348:	90                   	nop
 349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "panic at thread_create\n");
 350:	83 ec 08             	sub    $0x8,%esp
 353:	68 2b 0e 00 00       	push   $0xe2b
 358:	6a 01                	push   $0x1
 35a:	e8 61 07 00 00       	call   ac0 <printf>
      return -1;
 35f:	83 c4 10             	add    $0x10,%esp
}
 362:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return -1;
 365:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 36a:	5b                   	pop    %ebx
 36b:	5e                   	pop    %esi
 36c:	5d                   	pop    %ebp
 36d:	c3                   	ret    
 36e:	66 90                	xchg   %ax,%ax
      printf(1, "panic at thread_join\n");
 370:	83 ec 08             	sub    $0x8,%esp
 373:	68 53 0e 00 00       	push   $0xe53
 378:	6a 01                	push   $0x1
 37a:	e8 41 07 00 00       	call   ac0 <printf>
      return -1;
 37f:	83 c4 10             	add    $0x10,%esp
}
 382:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return -1;
 385:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 38a:	5b                   	pop    %ebx
 38b:	5e                   	pop    %esi
 38c:	5d                   	pop    %ebp
 38d:	c3                   	ret    
 38e:	66 90                	xchg   %ax,%ax

00000390 <jointest1>:
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	56                   	push   %esi
 394:	53                   	push   %ebx
 395:	8d 75 cc             	lea    -0x34(%ebp),%esi
  for (i = 1; i <= NUM_THREAD; i++){
 398:	bb 01 00 00 00       	mov    $0x1,%ebx
{
 39d:	83 ec 40             	sub    $0x40,%esp
    if (thread_create(&threads[i-1], jointhreadmain, (void*)i) != 0){
 3a0:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
 3a3:	83 ec 04             	sub    $0x4,%esp
 3a6:	53                   	push   %ebx
 3a7:	68 70 02 00 00       	push   $0x270
 3ac:	50                   	push   %eax
 3ad:	e8 48 06 00 00       	call   9fa <thread_create>
 3b2:	83 c4 10             	add    $0x10,%esp
 3b5:	85 c0                	test   %eax,%eax
 3b7:	75 67                	jne    420 <jointest1+0x90>
  for (i = 1; i <= NUM_THREAD; i++){
 3b9:	83 c3 01             	add    $0x1,%ebx
 3bc:	83 fb 0b             	cmp    $0xb,%ebx
 3bf:	75 df                	jne    3a0 <jointest1+0x10>
  printf(1, "thread_join!!!\n");
 3c1:	83 ec 08             	sub    $0x8,%esp
 3c4:	bb 02 00 00 00       	mov    $0x2,%ebx
 3c9:	68 43 0e 00 00       	push   $0xe43
 3ce:	6a 01                	push   $0x1
 3d0:	e8 eb 06 00 00       	call   ac0 <printf>
 3d5:	83 c4 10             	add    $0x10,%esp
 3d8:	90                   	nop
 3d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
 3e0:	83 ec 08             	sub    $0x8,%esp
 3e3:	56                   	push   %esi
 3e4:	ff 74 5d cc          	pushl  -0x34(%ebp,%ebx,2)
 3e8:	e8 1d 06 00 00       	call   a0a <thread_join>
 3ed:	83 c4 10             	add    $0x10,%esp
 3f0:	85 c0                	test   %eax,%eax
 3f2:	75 4c                	jne    440 <jointest1+0xb0>
 3f4:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
 3f7:	75 47                	jne    440 <jointest1+0xb0>
 3f9:	83 c3 02             	add    $0x2,%ebx
  for (i = 1; i <= NUM_THREAD; i++){
 3fc:	83 fb 16             	cmp    $0x16,%ebx
 3ff:	75 df                	jne    3e0 <jointest1+0x50>
  printf(1,"\n");
 401:	83 ec 08             	sub    $0x8,%esp
 404:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 407:	68 51 0e 00 00       	push   $0xe51
 40c:	6a 01                	push   $0x1
 40e:	e8 ad 06 00 00       	call   ac0 <printf>
  return 0;
 413:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 416:	83 c4 10             	add    $0x10,%esp
}
 419:	8d 65 f8             	lea    -0x8(%ebp),%esp
 41c:	5b                   	pop    %ebx
 41d:	5e                   	pop    %esi
 41e:	5d                   	pop    %ebp
 41f:	c3                   	ret    
      printf(1, "panic at thread_create\n");
 420:	83 ec 08             	sub    $0x8,%esp
 423:	68 2b 0e 00 00       	push   $0xe2b
 428:	6a 01                	push   $0x1
 42a:	e8 91 06 00 00       	call   ac0 <printf>
      return -1;
 42f:	83 c4 10             	add    $0x10,%esp
}
 432:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return -1;
 435:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 43a:	5b                   	pop    %ebx
 43b:	5e                   	pop    %esi
 43c:	5d                   	pop    %ebp
 43d:	c3                   	ret    
 43e:	66 90                	xchg   %ax,%ax
      printf(1, "panic at thread_join\n");
 440:	83 ec 08             	sub    $0x8,%esp
 443:	68 53 0e 00 00       	push   $0xe53
 448:	6a 01                	push   $0x1
 44a:	e8 71 06 00 00       	call   ac0 <printf>
 44f:	83 c4 10             	add    $0x10,%esp
}
 452:	8d 65 f8             	lea    -0x8(%ebp),%esp
      printf(1, "panic at thread_join\n");
 455:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 45a:	5b                   	pop    %ebx
 45b:	5e                   	pop    %esi
 45c:	5d                   	pop    %ebp
 45d:	c3                   	ret    
 45e:	66 90                	xchg   %ax,%ax

00000460 <stresstest>:
  return 0;
}

int
stresstest(void)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	57                   	push   %edi
 464:	56                   	push   %esi
 465:	53                   	push   %ebx
 466:	8d 75 bc             	lea    -0x44(%ebp),%esi
 469:	83 ec 4c             	sub    $0x4c,%esp
  const int nstress = 35000;
  thread_t threads[NUM_THREAD];
  int i, n;
  void *retval;

  for (n = 1; n <= nstress; n++){
 46c:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
 473:	31 ff                	xor    %edi,%edi
 475:	8d 76 00             	lea    0x0(%esi),%esi
    if (n % 1000 == 0)
      printf(1, "%d\n", n);
    for (i = 0; i < NUM_THREAD; i++){
      if (thread_create(&threads[i], stressthreadmain, (void*)i) != 0){
 478:	8d 44 bd c0          	lea    -0x40(%ebp,%edi,4),%eax
 47c:	83 ec 04             	sub    $0x4,%esp
 47f:	8d 5d c0             	lea    -0x40(%ebp),%ebx
 482:	57                   	push   %edi
 483:	68 a0 02 00 00       	push   $0x2a0
 488:	50                   	push   %eax
 489:	e8 6c 05 00 00       	call   9fa <thread_create>
 48e:	83 c4 10             	add    $0x10,%esp
 491:	85 c0                	test   %eax,%eax
 493:	75 6b                	jne    500 <stresstest+0xa0>
    for (i = 0; i < NUM_THREAD; i++){
 495:	83 c7 01             	add    $0x1,%edi
 498:	83 ff 0a             	cmp    $0xa,%edi
 49b:	75 db                	jne    478 <stresstest+0x18>
 49d:	8d 76 00             	lea    0x0(%esi),%esi
        printf(1, "panic at thread_create\n");
        return -1;
      }
    }
    for (i = 0; i < NUM_THREAD; i++){
      if (thread_join(threads[i], &retval) != 0){
 4a0:	83 ec 08             	sub    $0x8,%esp
 4a3:	56                   	push   %esi
 4a4:	ff 33                	pushl  (%ebx)
 4a6:	e8 5f 05 00 00       	call   a0a <thread_join>
 4ab:	83 c4 10             	add    $0x10,%esp
 4ae:	85 c0                	test   %eax,%eax
 4b0:	75 6e                	jne    520 <stresstest+0xc0>
    for (i = 0; i < NUM_THREAD; i++){
 4b2:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 4b5:	83 c3 04             	add    $0x4,%ebx
 4b8:	39 cb                	cmp    %ecx,%ebx
 4ba:	75 e4                	jne    4a0 <stresstest+0x40>
  for (n = 1; n <= nstress; n++){
 4bc:	83 45 b4 01          	addl   $0x1,-0x4c(%ebp)
 4c0:	8b 55 b4             	mov    -0x4c(%ebp),%edx
 4c3:	81 fa b9 88 00 00    	cmp    $0x88b9,%edx
 4c9:	74 74                	je     53f <stresstest+0xdf>
    if (n % 1000 == 0)
 4cb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 4ce:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
 4d3:	f7 e2                	mul    %edx
 4d5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 4d8:	c1 ea 06             	shr    $0x6,%edx
 4db:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
 4e1:	39 d0                	cmp    %edx,%eax
 4e3:	75 8e                	jne    473 <stresstest+0x13>
      printf(1, "%d\n", n);
 4e5:	83 ec 04             	sub    $0x4,%esp
 4e8:	50                   	push   %eax
 4e9:	68 69 0e 00 00       	push   $0xe69
 4ee:	6a 01                	push   $0x1
 4f0:	e8 cb 05 00 00       	call   ac0 <printf>
 4f5:	83 c4 10             	add    $0x10,%esp
 4f8:	e9 76 ff ff ff       	jmp    473 <stresstest+0x13>
 4fd:	8d 76 00             	lea    0x0(%esi),%esi
        printf(1, "panic at thread_create\n");
 500:	83 ec 08             	sub    $0x8,%esp
 503:	68 2b 0e 00 00       	push   $0xe2b
 508:	6a 01                	push   $0x1
 50a:	e8 b1 05 00 00       	call   ac0 <printf>
        return -1;
 50f:	83 c4 10             	add    $0x10,%esp
 512:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      }
    }
  }
  printf(1, "\n");
  return 0;
}
 517:	8d 65 f4             	lea    -0xc(%ebp),%esp
 51a:	5b                   	pop    %ebx
 51b:	5e                   	pop    %esi
 51c:	5f                   	pop    %edi
 51d:	5d                   	pop    %ebp
 51e:	c3                   	ret    
 51f:	90                   	nop
        printf(1, "panic at thread_join\n");
 520:	83 ec 08             	sub    $0x8,%esp
 523:	68 53 0e 00 00       	push   $0xe53
 528:	6a 01                	push   $0x1
 52a:	e8 91 05 00 00       	call   ac0 <printf>
        return -1;
 52f:	83 c4 10             	add    $0x10,%esp
}
 532:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
 535:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 53a:	5b                   	pop    %ebx
 53b:	5e                   	pop    %esi
 53c:	5f                   	pop    %edi
 53d:	5d                   	pop    %ebp
 53e:	c3                   	ret    
  printf(1, "\n");
 53f:	83 ec 08             	sub    $0x8,%esp
 542:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 545:	68 51 0e 00 00       	push   $0xe51
 54a:	6a 01                	push   $0x1
 54c:	e8 6f 05 00 00       	call   ac0 <printf>
 551:	83 c4 10             	add    $0x10,%esp
 554:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 557:	eb be                	jmp    517 <stresstest+0xb7>
 559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000560 <basictest>:
{
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	56                   	push   %esi
 564:	53                   	push   %ebx
  for (i = 0; i < NUM_THREAD; i++){
 565:	31 db                	xor    %ebx,%ebx
{
 567:	83 ec 40             	sub    $0x40,%esp
 56a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (thread_create(&threads[i], basicthreadmain, (void*)i) != 0){
 570:	8d 44 9d d0          	lea    -0x30(%ebp,%ebx,4),%eax
 574:	83 ec 04             	sub    $0x4,%esp
 577:	53                   	push   %ebx
 578:	68 10 02 00 00       	push   $0x210
 57d:	50                   	push   %eax
 57e:	e8 77 04 00 00       	call   9fa <thread_create>
 583:	83 c4 10             	add    $0x10,%esp
 586:	85 c0                	test   %eax,%eax
 588:	89 c6                	mov    %eax,%esi
 58a:	75 54                	jne    5e0 <basictest+0x80>
  for (i = 0; i < NUM_THREAD; i++){
 58c:	83 c3 01             	add    $0x1,%ebx
 58f:	83 fb 0a             	cmp    $0xa,%ebx
 592:	75 dc                	jne    570 <basictest+0x10>
 594:	8d 5d cc             	lea    -0x34(%ebp),%ebx
 597:	89 f6                	mov    %esi,%esi
 599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
 5a0:	83 ec 08             	sub    $0x8,%esp
 5a3:	53                   	push   %ebx
 5a4:	ff 74 b5 d0          	pushl  -0x30(%ebp,%esi,4)
 5a8:	e8 5d 04 00 00       	call   a0a <thread_join>
 5ad:	83 c4 10             	add    $0x10,%esp
 5b0:	85 c0                	test   %eax,%eax
 5b2:	75 4c                	jne    600 <basictest+0xa0>
 5b4:	83 c6 01             	add    $0x1,%esi
 5b7:	39 75 cc             	cmp    %esi,-0x34(%ebp)
 5ba:	75 44                	jne    600 <basictest+0xa0>
  for (i = 0; i < NUM_THREAD; i++){
 5bc:	83 fe 0a             	cmp    $0xa,%esi
 5bf:	75 df                	jne    5a0 <basictest+0x40>
  printf(1,"\n");
 5c1:	83 ec 08             	sub    $0x8,%esp
 5c4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 5c7:	68 51 0e 00 00       	push   $0xe51
 5cc:	6a 01                	push   $0x1
 5ce:	e8 ed 04 00 00       	call   ac0 <printf>
  return 0;
 5d3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 5d6:	83 c4 10             	add    $0x10,%esp
}
 5d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
 5dc:	5b                   	pop    %ebx
 5dd:	5e                   	pop    %esi
 5de:	5d                   	pop    %ebp
 5df:	c3                   	ret    
      printf(1, "panic at thread_create\n");
 5e0:	83 ec 08             	sub    $0x8,%esp
 5e3:	68 2b 0e 00 00       	push   $0xe2b
 5e8:	6a 01                	push   $0x1
 5ea:	e8 d1 04 00 00       	call   ac0 <printf>
      return -1;
 5ef:	83 c4 10             	add    $0x10,%esp
}
 5f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return -1;
 5f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 5fa:	5b                   	pop    %ebx
 5fb:	5e                   	pop    %esi
 5fc:	5d                   	pop    %ebp
 5fd:	c3                   	ret    
 5fe:	66 90                	xchg   %ax,%ax
      printf(1, "panic at thread_join\n");
 600:	83 ec 08             	sub    $0x8,%esp
 603:	68 53 0e 00 00       	push   $0xe53
 608:	6a 01                	push   $0x1
 60a:	e8 b1 04 00 00       	call   ac0 <printf>
 60f:	83 c4 10             	add    $0x10,%esp
}
 612:	8d 65 f8             	lea    -0x8(%ebp),%esp
      printf(1, "panic at thread_join\n");
 615:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 61a:	5b                   	pop    %ebx
 61b:	5e                   	pop    %esi
 61c:	5d                   	pop    %ebp
 61d:	c3                   	ret    
 61e:	66 90                	xchg   %ax,%ax

00000620 <racingtest>:
{
 620:	55                   	push   %ebp
 621:	89 e5                	mov    %esp,%ebp
 623:	56                   	push   %esi
 624:	53                   	push   %ebx
  for (i = 0; i < NUM_THREAD; i++){
 625:	31 db                	xor    %ebx,%ebx
{
 627:	83 ec 40             	sub    $0x40,%esp
  gcnt = 0;
 62a:	c7 05 a4 13 00 00 00 	movl   $0x0,0x13a4
 631:	00 00 00 
 634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (thread_create(&threads[i], racingthreadmain, (void*)i) != 0){
 638:	8d 44 9d d0          	lea    -0x30(%ebp,%ebx,4),%eax
 63c:	83 ec 04             	sub    $0x4,%esp
 63f:	53                   	push   %ebx
 640:	68 d0 01 00 00       	push   $0x1d0
 645:	50                   	push   %eax
 646:	e8 af 03 00 00       	call   9fa <thread_create>
 64b:	83 c4 10             	add    $0x10,%esp
 64e:	85 c0                	test   %eax,%eax
 650:	89 c6                	mov    %eax,%esi
 652:	75 5c                	jne    6b0 <racingtest+0x90>
  for (i = 0; i < NUM_THREAD; i++){
 654:	83 c3 01             	add    $0x1,%ebx
 657:	83 fb 0a             	cmp    $0xa,%ebx
 65a:	75 dc                	jne    638 <racingtest+0x18>
 65c:	8d 5d cc             	lea    -0x34(%ebp),%ebx
 65f:	90                   	nop
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
 660:	83 ec 08             	sub    $0x8,%esp
 663:	53                   	push   %ebx
 664:	ff 74 b5 d0          	pushl  -0x30(%ebp,%esi,4)
 668:	e8 9d 03 00 00       	call   a0a <thread_join>
 66d:	83 c4 10             	add    $0x10,%esp
 670:	85 c0                	test   %eax,%eax
 672:	75 5c                	jne    6d0 <racingtest+0xb0>
 674:	83 c6 01             	add    $0x1,%esi
 677:	39 75 cc             	cmp    %esi,-0x34(%ebp)
 67a:	75 54                	jne    6d0 <racingtest+0xb0>
  for (i = 0; i < NUM_THREAD; i++){
 67c:	83 fe 0a             	cmp    $0xa,%esi
 67f:	75 df                	jne    660 <racingtest+0x40>
  printf(1,"%d\n", gcnt);
 681:	8b 15 a4 13 00 00    	mov    0x13a4,%edx
 687:	83 ec 04             	sub    $0x4,%esp
 68a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 68d:	52                   	push   %edx
 68e:	68 69 0e 00 00       	push   $0xe69
 693:	6a 01                	push   $0x1
 695:	e8 26 04 00 00       	call   ac0 <printf>
  return 0;
 69a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 69d:	83 c4 10             	add    $0x10,%esp
}
 6a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
 6a3:	5b                   	pop    %ebx
 6a4:	5e                   	pop    %esi
 6a5:	5d                   	pop    %ebp
 6a6:	c3                   	ret    
 6a7:	89 f6                	mov    %esi,%esi
 6a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      printf(1, "panic at thread_create\n");
 6b0:	83 ec 08             	sub    $0x8,%esp
 6b3:	68 2b 0e 00 00       	push   $0xe2b
 6b8:	6a 01                	push   $0x1
 6ba:	e8 01 04 00 00       	call   ac0 <printf>
      return -1;
 6bf:	83 c4 10             	add    $0x10,%esp
}
 6c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return -1;
 6c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 6ca:	5b                   	pop    %ebx
 6cb:	5e                   	pop    %esi
 6cc:	5d                   	pop    %ebp
 6cd:	c3                   	ret    
 6ce:	66 90                	xchg   %ax,%ax
      printf(1, "panic at thread_join\n");
 6d0:	83 ec 08             	sub    $0x8,%esp
 6d3:	68 53 0e 00 00       	push   $0xe53
 6d8:	6a 01                	push   $0x1
 6da:	e8 e1 03 00 00       	call   ac0 <printf>
 6df:	83 c4 10             	add    $0x10,%esp
}
 6e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
      printf(1, "panic at thread_join\n");
 6e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 6ea:	5b                   	pop    %ebx
 6eb:	5e                   	pop    %esi
 6ec:	5d                   	pop    %ebp
 6ed:	c3                   	ret    
 6ee:	66 90                	xchg   %ax,%ax

000006f0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 6f0:	55                   	push   %ebp
 6f1:	89 e5                	mov    %esp,%ebp
 6f3:	53                   	push   %ebx
 6f4:	8b 45 08             	mov    0x8(%ebp),%eax
 6f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 6fa:	89 c2                	mov    %eax,%edx
 6fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 700:	83 c1 01             	add    $0x1,%ecx
 703:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 707:	83 c2 01             	add    $0x1,%edx
 70a:	84 db                	test   %bl,%bl
 70c:	88 5a ff             	mov    %bl,-0x1(%edx)
 70f:	75 ef                	jne    700 <strcpy+0x10>
    ;
  return os;
}
 711:	5b                   	pop    %ebx
 712:	5d                   	pop    %ebp
 713:	c3                   	ret    
 714:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 71a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000720 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 720:	55                   	push   %ebp
 721:	89 e5                	mov    %esp,%ebp
 723:	53                   	push   %ebx
 724:	8b 55 08             	mov    0x8(%ebp),%edx
 727:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 72a:	0f b6 02             	movzbl (%edx),%eax
 72d:	0f b6 19             	movzbl (%ecx),%ebx
 730:	84 c0                	test   %al,%al
 732:	75 1c                	jne    750 <strcmp+0x30>
 734:	eb 2a                	jmp    760 <strcmp+0x40>
 736:	8d 76 00             	lea    0x0(%esi),%esi
 739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 740:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 743:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 746:	83 c1 01             	add    $0x1,%ecx
 749:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 74c:	84 c0                	test   %al,%al
 74e:	74 10                	je     760 <strcmp+0x40>
 750:	38 d8                	cmp    %bl,%al
 752:	74 ec                	je     740 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 754:	29 d8                	sub    %ebx,%eax
}
 756:	5b                   	pop    %ebx
 757:	5d                   	pop    %ebp
 758:	c3                   	ret    
 759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 760:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 762:	29 d8                	sub    %ebx,%eax
}
 764:	5b                   	pop    %ebx
 765:	5d                   	pop    %ebp
 766:	c3                   	ret    
 767:	89 f6                	mov    %esi,%esi
 769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000770 <strlen>:

uint
strlen(const char *s)
{
 770:	55                   	push   %ebp
 771:	89 e5                	mov    %esp,%ebp
 773:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 776:	80 39 00             	cmpb   $0x0,(%ecx)
 779:	74 15                	je     790 <strlen+0x20>
 77b:	31 d2                	xor    %edx,%edx
 77d:	8d 76 00             	lea    0x0(%esi),%esi
 780:	83 c2 01             	add    $0x1,%edx
 783:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 787:	89 d0                	mov    %edx,%eax
 789:	75 f5                	jne    780 <strlen+0x10>
    ;
  return n;
}
 78b:	5d                   	pop    %ebp
 78c:	c3                   	ret    
 78d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 790:	31 c0                	xor    %eax,%eax
}
 792:	5d                   	pop    %ebp
 793:	c3                   	ret    
 794:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 79a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000007a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 7a0:	55                   	push   %ebp
 7a1:	89 e5                	mov    %esp,%ebp
 7a3:	57                   	push   %edi
 7a4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 7a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 7aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 7ad:	89 d7                	mov    %edx,%edi
 7af:	fc                   	cld    
 7b0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 7b2:	89 d0                	mov    %edx,%eax
 7b4:	5f                   	pop    %edi
 7b5:	5d                   	pop    %ebp
 7b6:	c3                   	ret    
 7b7:	89 f6                	mov    %esi,%esi
 7b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000007c0 <strchr>:

char*
strchr(const char *s, char c)
{
 7c0:	55                   	push   %ebp
 7c1:	89 e5                	mov    %esp,%ebp
 7c3:	53                   	push   %ebx
 7c4:	8b 45 08             	mov    0x8(%ebp),%eax
 7c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 7ca:	0f b6 10             	movzbl (%eax),%edx
 7cd:	84 d2                	test   %dl,%dl
 7cf:	74 1d                	je     7ee <strchr+0x2e>
    if(*s == c)
 7d1:	38 d3                	cmp    %dl,%bl
 7d3:	89 d9                	mov    %ebx,%ecx
 7d5:	75 0d                	jne    7e4 <strchr+0x24>
 7d7:	eb 17                	jmp    7f0 <strchr+0x30>
 7d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7e0:	38 ca                	cmp    %cl,%dl
 7e2:	74 0c                	je     7f0 <strchr+0x30>
  for(; *s; s++)
 7e4:	83 c0 01             	add    $0x1,%eax
 7e7:	0f b6 10             	movzbl (%eax),%edx
 7ea:	84 d2                	test   %dl,%dl
 7ec:	75 f2                	jne    7e0 <strchr+0x20>
      return (char*)s;
  return 0;
 7ee:	31 c0                	xor    %eax,%eax
}
 7f0:	5b                   	pop    %ebx
 7f1:	5d                   	pop    %ebp
 7f2:	c3                   	ret    
 7f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 7f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000800 <gets>:

char*
gets(char *buf, int max)
{
 800:	55                   	push   %ebp
 801:	89 e5                	mov    %esp,%ebp
 803:	57                   	push   %edi
 804:	56                   	push   %esi
 805:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 806:	31 f6                	xor    %esi,%esi
 808:	89 f3                	mov    %esi,%ebx
{
 80a:	83 ec 1c             	sub    $0x1c,%esp
 80d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 810:	eb 2f                	jmp    841 <gets+0x41>
 812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 818:	8d 45 e7             	lea    -0x19(%ebp),%eax
 81b:	83 ec 04             	sub    $0x4,%esp
 81e:	6a 01                	push   $0x1
 820:	50                   	push   %eax
 821:	6a 00                	push   $0x0
 823:	e8 32 01 00 00       	call   95a <read>
    if(cc < 1)
 828:	83 c4 10             	add    $0x10,%esp
 82b:	85 c0                	test   %eax,%eax
 82d:	7e 1c                	jle    84b <gets+0x4b>
      break;
    buf[i++] = c;
 82f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 833:	83 c7 01             	add    $0x1,%edi
 836:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 839:	3c 0a                	cmp    $0xa,%al
 83b:	74 23                	je     860 <gets+0x60>
 83d:	3c 0d                	cmp    $0xd,%al
 83f:	74 1f                	je     860 <gets+0x60>
  for(i=0; i+1 < max; ){
 841:	83 c3 01             	add    $0x1,%ebx
 844:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 847:	89 fe                	mov    %edi,%esi
 849:	7c cd                	jl     818 <gets+0x18>
 84b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 84d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 850:	c6 03 00             	movb   $0x0,(%ebx)
}
 853:	8d 65 f4             	lea    -0xc(%ebp),%esp
 856:	5b                   	pop    %ebx
 857:	5e                   	pop    %esi
 858:	5f                   	pop    %edi
 859:	5d                   	pop    %ebp
 85a:	c3                   	ret    
 85b:	90                   	nop
 85c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 860:	8b 75 08             	mov    0x8(%ebp),%esi
 863:	8b 45 08             	mov    0x8(%ebp),%eax
 866:	01 de                	add    %ebx,%esi
 868:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 86a:	c6 03 00             	movb   $0x0,(%ebx)
}
 86d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 870:	5b                   	pop    %ebx
 871:	5e                   	pop    %esi
 872:	5f                   	pop    %edi
 873:	5d                   	pop    %ebp
 874:	c3                   	ret    
 875:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000880 <stat>:

int
stat(const char *n, struct stat *st)
{
 880:	55                   	push   %ebp
 881:	89 e5                	mov    %esp,%ebp
 883:	56                   	push   %esi
 884:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 885:	83 ec 08             	sub    $0x8,%esp
 888:	6a 00                	push   $0x0
 88a:	ff 75 08             	pushl  0x8(%ebp)
 88d:	e8 f0 00 00 00       	call   982 <open>
  if(fd < 0)
 892:	83 c4 10             	add    $0x10,%esp
 895:	85 c0                	test   %eax,%eax
 897:	78 27                	js     8c0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 899:	83 ec 08             	sub    $0x8,%esp
 89c:	ff 75 0c             	pushl  0xc(%ebp)
 89f:	89 c3                	mov    %eax,%ebx
 8a1:	50                   	push   %eax
 8a2:	e8 f3 00 00 00       	call   99a <fstat>
  close(fd);
 8a7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 8aa:	89 c6                	mov    %eax,%esi
  close(fd);
 8ac:	e8 b9 00 00 00       	call   96a <close>
  return r;
 8b1:	83 c4 10             	add    $0x10,%esp
}
 8b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 8b7:	89 f0                	mov    %esi,%eax
 8b9:	5b                   	pop    %ebx
 8ba:	5e                   	pop    %esi
 8bb:	5d                   	pop    %ebp
 8bc:	c3                   	ret    
 8bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 8c0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 8c5:	eb ed                	jmp    8b4 <stat+0x34>
 8c7:	89 f6                	mov    %esi,%esi
 8c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000008d0 <atoi>:

int
atoi(const char *s)
{
 8d0:	55                   	push   %ebp
 8d1:	89 e5                	mov    %esp,%ebp
 8d3:	53                   	push   %ebx
 8d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 8d7:	0f be 11             	movsbl (%ecx),%edx
 8da:	8d 42 d0             	lea    -0x30(%edx),%eax
 8dd:	3c 09                	cmp    $0x9,%al
  n = 0;
 8df:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 8e4:	77 1f                	ja     905 <atoi+0x35>
 8e6:	8d 76 00             	lea    0x0(%esi),%esi
 8e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 8f0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 8f3:	83 c1 01             	add    $0x1,%ecx
 8f6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 8fa:	0f be 11             	movsbl (%ecx),%edx
 8fd:	8d 5a d0             	lea    -0x30(%edx),%ebx
 900:	80 fb 09             	cmp    $0x9,%bl
 903:	76 eb                	jbe    8f0 <atoi+0x20>
  return n;
}
 905:	5b                   	pop    %ebx
 906:	5d                   	pop    %ebp
 907:	c3                   	ret    
 908:	90                   	nop
 909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000910 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 910:	55                   	push   %ebp
 911:	89 e5                	mov    %esp,%ebp
 913:	56                   	push   %esi
 914:	53                   	push   %ebx
 915:	8b 5d 10             	mov    0x10(%ebp),%ebx
 918:	8b 45 08             	mov    0x8(%ebp),%eax
 91b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 91e:	85 db                	test   %ebx,%ebx
 920:	7e 14                	jle    936 <memmove+0x26>
 922:	31 d2                	xor    %edx,%edx
 924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 928:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 92c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 92f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 932:	39 d3                	cmp    %edx,%ebx
 934:	75 f2                	jne    928 <memmove+0x18>
  return vdst;
}
 936:	5b                   	pop    %ebx
 937:	5e                   	pop    %esi
 938:	5d                   	pop    %ebp
 939:	c3                   	ret    

0000093a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 93a:	b8 01 00 00 00       	mov    $0x1,%eax
 93f:	cd 40                	int    $0x40
 941:	c3                   	ret    

00000942 <exit>:
SYSCALL(exit)
 942:	b8 02 00 00 00       	mov    $0x2,%eax
 947:	cd 40                	int    $0x40
 949:	c3                   	ret    

0000094a <wait>:
SYSCALL(wait)
 94a:	b8 03 00 00 00       	mov    $0x3,%eax
 94f:	cd 40                	int    $0x40
 951:	c3                   	ret    

00000952 <pipe>:
SYSCALL(pipe)
 952:	b8 04 00 00 00       	mov    $0x4,%eax
 957:	cd 40                	int    $0x40
 959:	c3                   	ret    

0000095a <read>:
SYSCALL(read)
 95a:	b8 05 00 00 00       	mov    $0x5,%eax
 95f:	cd 40                	int    $0x40
 961:	c3                   	ret    

00000962 <write>:
SYSCALL(write)
 962:	b8 10 00 00 00       	mov    $0x10,%eax
 967:	cd 40                	int    $0x40
 969:	c3                   	ret    

0000096a <close>:
SYSCALL(close)
 96a:	b8 15 00 00 00       	mov    $0x15,%eax
 96f:	cd 40                	int    $0x40
 971:	c3                   	ret    

00000972 <kill>:
SYSCALL(kill)
 972:	b8 06 00 00 00       	mov    $0x6,%eax
 977:	cd 40                	int    $0x40
 979:	c3                   	ret    

0000097a <exec>:
SYSCALL(exec)
 97a:	b8 07 00 00 00       	mov    $0x7,%eax
 97f:	cd 40                	int    $0x40
 981:	c3                   	ret    

00000982 <open>:
SYSCALL(open)
 982:	b8 0f 00 00 00       	mov    $0xf,%eax
 987:	cd 40                	int    $0x40
 989:	c3                   	ret    

0000098a <mknod>:
SYSCALL(mknod)
 98a:	b8 11 00 00 00       	mov    $0x11,%eax
 98f:	cd 40                	int    $0x40
 991:	c3                   	ret    

00000992 <unlink>:
SYSCALL(unlink)
 992:	b8 12 00 00 00       	mov    $0x12,%eax
 997:	cd 40                	int    $0x40
 999:	c3                   	ret    

0000099a <fstat>:
SYSCALL(fstat)
 99a:	b8 08 00 00 00       	mov    $0x8,%eax
 99f:	cd 40                	int    $0x40
 9a1:	c3                   	ret    

000009a2 <link>:
SYSCALL(link)
 9a2:	b8 13 00 00 00       	mov    $0x13,%eax
 9a7:	cd 40                	int    $0x40
 9a9:	c3                   	ret    

000009aa <mkdir>:
SYSCALL(mkdir)
 9aa:	b8 14 00 00 00       	mov    $0x14,%eax
 9af:	cd 40                	int    $0x40
 9b1:	c3                   	ret    

000009b2 <chdir>:
SYSCALL(chdir)
 9b2:	b8 09 00 00 00       	mov    $0x9,%eax
 9b7:	cd 40                	int    $0x40
 9b9:	c3                   	ret    

000009ba <dup>:
SYSCALL(dup)
 9ba:	b8 0a 00 00 00       	mov    $0xa,%eax
 9bf:	cd 40                	int    $0x40
 9c1:	c3                   	ret    

000009c2 <getpid>:
SYSCALL(getpid)
 9c2:	b8 0b 00 00 00       	mov    $0xb,%eax
 9c7:	cd 40                	int    $0x40
 9c9:	c3                   	ret    

000009ca <sbrk>:
SYSCALL(sbrk)
 9ca:	b8 0c 00 00 00       	mov    $0xc,%eax
 9cf:	cd 40                	int    $0x40
 9d1:	c3                   	ret    

000009d2 <sleep>:
SYSCALL(sleep)
 9d2:	b8 0d 00 00 00       	mov    $0xd,%eax
 9d7:	cd 40                	int    $0x40
 9d9:	c3                   	ret    

000009da <uptime>:
SYSCALL(uptime)
 9da:	b8 0e 00 00 00       	mov    $0xe,%eax
 9df:	cd 40                	int    $0x40
 9e1:	c3                   	ret    

000009e2 <getlev>:
SYSCALL(getlev)
 9e2:	b8 16 00 00 00       	mov    $0x16,%eax
 9e7:	cd 40                	int    $0x40
 9e9:	c3                   	ret    

000009ea <yield>:
SYSCALL(yield)
 9ea:	b8 17 00 00 00       	mov    $0x17,%eax
 9ef:	cd 40                	int    $0x40
 9f1:	c3                   	ret    

000009f2 <set_cpu_share>:
SYSCALL(set_cpu_share)
 9f2:	b8 18 00 00 00       	mov    $0x18,%eax
 9f7:	cd 40                	int    $0x40
 9f9:	c3                   	ret    

000009fa <thread_create>:
SYSCALL(thread_create)
 9fa:	b8 19 00 00 00       	mov    $0x19,%eax
 9ff:	cd 40                	int    $0x40
 a01:	c3                   	ret    

00000a02 <thread_exit>:
SYSCALL(thread_exit)
 a02:	b8 1a 00 00 00       	mov    $0x1a,%eax
 a07:	cd 40                	int    $0x40
 a09:	c3                   	ret    

00000a0a <thread_join>:
SYSCALL(thread_join)
 a0a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 a0f:	cd 40                	int    $0x40
 a11:	c3                   	ret    
 a12:	66 90                	xchg   %ax,%ax
 a14:	66 90                	xchg   %ax,%ax
 a16:	66 90                	xchg   %ax,%ax
 a18:	66 90                	xchg   %ax,%ax
 a1a:	66 90                	xchg   %ax,%ax
 a1c:	66 90                	xchg   %ax,%ax
 a1e:	66 90                	xchg   %ax,%ax

00000a20 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 a20:	55                   	push   %ebp
 a21:	89 e5                	mov    %esp,%ebp
 a23:	57                   	push   %edi
 a24:	56                   	push   %esi
 a25:	53                   	push   %ebx
 a26:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 a29:	85 d2                	test   %edx,%edx
{
 a2b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 a2e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 a30:	79 76                	jns    aa8 <printint+0x88>
 a32:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 a36:	74 70                	je     aa8 <printint+0x88>
    x = -xx;
 a38:	f7 d8                	neg    %eax
    neg = 1;
 a3a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 a41:	31 f6                	xor    %esi,%esi
 a43:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 a46:	eb 0a                	jmp    a52 <printint+0x32>
 a48:	90                   	nop
 a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 a50:	89 fe                	mov    %edi,%esi
 a52:	31 d2                	xor    %edx,%edx
 a54:	8d 7e 01             	lea    0x1(%esi),%edi
 a57:	f7 f1                	div    %ecx
 a59:	0f b6 92 ec 0e 00 00 	movzbl 0xeec(%edx),%edx
  }while((x /= base) != 0);
 a60:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 a62:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 a65:	75 e9                	jne    a50 <printint+0x30>
  if(neg)
 a67:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 a6a:	85 c0                	test   %eax,%eax
 a6c:	74 08                	je     a76 <printint+0x56>
    buf[i++] = '-';
 a6e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 a73:	8d 7e 02             	lea    0x2(%esi),%edi
 a76:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 a7a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 a7d:	8d 76 00             	lea    0x0(%esi),%esi
 a80:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 a83:	83 ec 04             	sub    $0x4,%esp
 a86:	83 ee 01             	sub    $0x1,%esi
 a89:	6a 01                	push   $0x1
 a8b:	53                   	push   %ebx
 a8c:	57                   	push   %edi
 a8d:	88 45 d7             	mov    %al,-0x29(%ebp)
 a90:	e8 cd fe ff ff       	call   962 <write>

  while(--i >= 0)
 a95:	83 c4 10             	add    $0x10,%esp
 a98:	39 de                	cmp    %ebx,%esi
 a9a:	75 e4                	jne    a80 <printint+0x60>
    putc(fd, buf[i]);
}
 a9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 a9f:	5b                   	pop    %ebx
 aa0:	5e                   	pop    %esi
 aa1:	5f                   	pop    %edi
 aa2:	5d                   	pop    %ebp
 aa3:	c3                   	ret    
 aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 aa8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 aaf:	eb 90                	jmp    a41 <printint+0x21>
 ab1:	eb 0d                	jmp    ac0 <printf>
 ab3:	90                   	nop
 ab4:	90                   	nop
 ab5:	90                   	nop
 ab6:	90                   	nop
 ab7:	90                   	nop
 ab8:	90                   	nop
 ab9:	90                   	nop
 aba:	90                   	nop
 abb:	90                   	nop
 abc:	90                   	nop
 abd:	90                   	nop
 abe:	90                   	nop
 abf:	90                   	nop

00000ac0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 ac0:	55                   	push   %ebp
 ac1:	89 e5                	mov    %esp,%ebp
 ac3:	57                   	push   %edi
 ac4:	56                   	push   %esi
 ac5:	53                   	push   %ebx
 ac6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 ac9:	8b 75 0c             	mov    0xc(%ebp),%esi
 acc:	0f b6 1e             	movzbl (%esi),%ebx
 acf:	84 db                	test   %bl,%bl
 ad1:	0f 84 b3 00 00 00    	je     b8a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 ad7:	8d 45 10             	lea    0x10(%ebp),%eax
 ada:	83 c6 01             	add    $0x1,%esi
  state = 0;
 add:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 adf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 ae2:	eb 2f                	jmp    b13 <printf+0x53>
 ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 ae8:	83 f8 25             	cmp    $0x25,%eax
 aeb:	0f 84 a7 00 00 00    	je     b98 <printf+0xd8>
  write(fd, &c, 1);
 af1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 af4:	83 ec 04             	sub    $0x4,%esp
 af7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 afa:	6a 01                	push   $0x1
 afc:	50                   	push   %eax
 afd:	ff 75 08             	pushl  0x8(%ebp)
 b00:	e8 5d fe ff ff       	call   962 <write>
 b05:	83 c4 10             	add    $0x10,%esp
 b08:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 b0b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 b0f:	84 db                	test   %bl,%bl
 b11:	74 77                	je     b8a <printf+0xca>
    if(state == 0){
 b13:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 b15:	0f be cb             	movsbl %bl,%ecx
 b18:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 b1b:	74 cb                	je     ae8 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 b1d:	83 ff 25             	cmp    $0x25,%edi
 b20:	75 e6                	jne    b08 <printf+0x48>
      if(c == 'd'){
 b22:	83 f8 64             	cmp    $0x64,%eax
 b25:	0f 84 05 01 00 00    	je     c30 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 b2b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 b31:	83 f9 70             	cmp    $0x70,%ecx
 b34:	74 72                	je     ba8 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 b36:	83 f8 73             	cmp    $0x73,%eax
 b39:	0f 84 99 00 00 00    	je     bd8 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 b3f:	83 f8 63             	cmp    $0x63,%eax
 b42:	0f 84 08 01 00 00    	je     c50 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 b48:	83 f8 25             	cmp    $0x25,%eax
 b4b:	0f 84 ef 00 00 00    	je     c40 <printf+0x180>
  write(fd, &c, 1);
 b51:	8d 45 e7             	lea    -0x19(%ebp),%eax
 b54:	83 ec 04             	sub    $0x4,%esp
 b57:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 b5b:	6a 01                	push   $0x1
 b5d:	50                   	push   %eax
 b5e:	ff 75 08             	pushl  0x8(%ebp)
 b61:	e8 fc fd ff ff       	call   962 <write>
 b66:	83 c4 0c             	add    $0xc,%esp
 b69:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 b6c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 b6f:	6a 01                	push   $0x1
 b71:	50                   	push   %eax
 b72:	ff 75 08             	pushl  0x8(%ebp)
 b75:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 b78:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 b7a:	e8 e3 fd ff ff       	call   962 <write>
  for(i = 0; fmt[i]; i++){
 b7f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 b83:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 b86:	84 db                	test   %bl,%bl
 b88:	75 89                	jne    b13 <printf+0x53>
    }
  }
}
 b8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 b8d:	5b                   	pop    %ebx
 b8e:	5e                   	pop    %esi
 b8f:	5f                   	pop    %edi
 b90:	5d                   	pop    %ebp
 b91:	c3                   	ret    
 b92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 b98:	bf 25 00 00 00       	mov    $0x25,%edi
 b9d:	e9 66 ff ff ff       	jmp    b08 <printf+0x48>
 ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 ba8:	83 ec 0c             	sub    $0xc,%esp
 bab:	b9 10 00 00 00       	mov    $0x10,%ecx
 bb0:	6a 00                	push   $0x0
 bb2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 bb5:	8b 45 08             	mov    0x8(%ebp),%eax
 bb8:	8b 17                	mov    (%edi),%edx
 bba:	e8 61 fe ff ff       	call   a20 <printint>
        ap++;
 bbf:	89 f8                	mov    %edi,%eax
 bc1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 bc4:	31 ff                	xor    %edi,%edi
        ap++;
 bc6:	83 c0 04             	add    $0x4,%eax
 bc9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 bcc:	e9 37 ff ff ff       	jmp    b08 <printf+0x48>
 bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 bd8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 bdb:	8b 08                	mov    (%eax),%ecx
        ap++;
 bdd:	83 c0 04             	add    $0x4,%eax
 be0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 be3:	85 c9                	test   %ecx,%ecx
 be5:	0f 84 8e 00 00 00    	je     c79 <printf+0x1b9>
        while(*s != 0){
 beb:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 bee:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 bf0:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 bf2:	84 c0                	test   %al,%al
 bf4:	0f 84 0e ff ff ff    	je     b08 <printf+0x48>
 bfa:	89 75 d0             	mov    %esi,-0x30(%ebp)
 bfd:	89 de                	mov    %ebx,%esi
 bff:	8b 5d 08             	mov    0x8(%ebp),%ebx
 c02:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 c05:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 c08:	83 ec 04             	sub    $0x4,%esp
          s++;
 c0b:	83 c6 01             	add    $0x1,%esi
 c0e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 c11:	6a 01                	push   $0x1
 c13:	57                   	push   %edi
 c14:	53                   	push   %ebx
 c15:	e8 48 fd ff ff       	call   962 <write>
        while(*s != 0){
 c1a:	0f b6 06             	movzbl (%esi),%eax
 c1d:	83 c4 10             	add    $0x10,%esp
 c20:	84 c0                	test   %al,%al
 c22:	75 e4                	jne    c08 <printf+0x148>
 c24:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 c27:	31 ff                	xor    %edi,%edi
 c29:	e9 da fe ff ff       	jmp    b08 <printf+0x48>
 c2e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 c30:	83 ec 0c             	sub    $0xc,%esp
 c33:	b9 0a 00 00 00       	mov    $0xa,%ecx
 c38:	6a 01                	push   $0x1
 c3a:	e9 73 ff ff ff       	jmp    bb2 <printf+0xf2>
 c3f:	90                   	nop
  write(fd, &c, 1);
 c40:	83 ec 04             	sub    $0x4,%esp
 c43:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 c46:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 c49:	6a 01                	push   $0x1
 c4b:	e9 21 ff ff ff       	jmp    b71 <printf+0xb1>
        putc(fd, *ap);
 c50:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 c53:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 c56:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 c58:	6a 01                	push   $0x1
        ap++;
 c5a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 c5d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 c60:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 c63:	50                   	push   %eax
 c64:	ff 75 08             	pushl  0x8(%ebp)
 c67:	e8 f6 fc ff ff       	call   962 <write>
        ap++;
 c6c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 c6f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 c72:	31 ff                	xor    %edi,%edi
 c74:	e9 8f fe ff ff       	jmp    b08 <printf+0x48>
          s = "(null)";
 c79:	bb e4 0e 00 00       	mov    $0xee4,%ebx
        while(*s != 0){
 c7e:	b8 28 00 00 00       	mov    $0x28,%eax
 c83:	e9 72 ff ff ff       	jmp    bfa <printf+0x13a>
 c88:	66 90                	xchg   %ax,%ax
 c8a:	66 90                	xchg   %ax,%ax
 c8c:	66 90                	xchg   %ax,%ax
 c8e:	66 90                	xchg   %ax,%ax

00000c90 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c90:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c91:	a1 98 13 00 00       	mov    0x1398,%eax
{
 c96:	89 e5                	mov    %esp,%ebp
 c98:	57                   	push   %edi
 c99:	56                   	push   %esi
 c9a:	53                   	push   %ebx
 c9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 c9e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ca8:	39 c8                	cmp    %ecx,%eax
 caa:	8b 10                	mov    (%eax),%edx
 cac:	73 32                	jae    ce0 <free+0x50>
 cae:	39 d1                	cmp    %edx,%ecx
 cb0:	72 04                	jb     cb6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 cb2:	39 d0                	cmp    %edx,%eax
 cb4:	72 32                	jb     ce8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 cb6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 cb9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 cbc:	39 fa                	cmp    %edi,%edx
 cbe:	74 30                	je     cf0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 cc0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 cc3:	8b 50 04             	mov    0x4(%eax),%edx
 cc6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 cc9:	39 f1                	cmp    %esi,%ecx
 ccb:	74 3a                	je     d07 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 ccd:	89 08                	mov    %ecx,(%eax)
  freep = p;
 ccf:	a3 98 13 00 00       	mov    %eax,0x1398
}
 cd4:	5b                   	pop    %ebx
 cd5:	5e                   	pop    %esi
 cd6:	5f                   	pop    %edi
 cd7:	5d                   	pop    %ebp
 cd8:	c3                   	ret    
 cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ce0:	39 d0                	cmp    %edx,%eax
 ce2:	72 04                	jb     ce8 <free+0x58>
 ce4:	39 d1                	cmp    %edx,%ecx
 ce6:	72 ce                	jb     cb6 <free+0x26>
{
 ce8:	89 d0                	mov    %edx,%eax
 cea:	eb bc                	jmp    ca8 <free+0x18>
 cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 cf0:	03 72 04             	add    0x4(%edx),%esi
 cf3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 cf6:	8b 10                	mov    (%eax),%edx
 cf8:	8b 12                	mov    (%edx),%edx
 cfa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 cfd:	8b 50 04             	mov    0x4(%eax),%edx
 d00:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 d03:	39 f1                	cmp    %esi,%ecx
 d05:	75 c6                	jne    ccd <free+0x3d>
    p->s.size += bp->s.size;
 d07:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 d0a:	a3 98 13 00 00       	mov    %eax,0x1398
    p->s.size += bp->s.size;
 d0f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 d12:	8b 53 f8             	mov    -0x8(%ebx),%edx
 d15:	89 10                	mov    %edx,(%eax)
}
 d17:	5b                   	pop    %ebx
 d18:	5e                   	pop    %esi
 d19:	5f                   	pop    %edi
 d1a:	5d                   	pop    %ebp
 d1b:	c3                   	ret    
 d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000d20 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 d20:	55                   	push   %ebp
 d21:	89 e5                	mov    %esp,%ebp
 d23:	57                   	push   %edi
 d24:	56                   	push   %esi
 d25:	53                   	push   %ebx
 d26:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d29:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 d2c:	8b 15 98 13 00 00    	mov    0x1398,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d32:	8d 78 07             	lea    0x7(%eax),%edi
 d35:	c1 ef 03             	shr    $0x3,%edi
 d38:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 d3b:	85 d2                	test   %edx,%edx
 d3d:	0f 84 9d 00 00 00    	je     de0 <malloc+0xc0>
 d43:	8b 02                	mov    (%edx),%eax
 d45:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 d48:	39 cf                	cmp    %ecx,%edi
 d4a:	76 6c                	jbe    db8 <malloc+0x98>
 d4c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 d52:	bb 00 10 00 00       	mov    $0x1000,%ebx
 d57:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 d5a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 d61:	eb 0e                	jmp    d71 <malloc+0x51>
 d63:	90                   	nop
 d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d68:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 d6a:	8b 48 04             	mov    0x4(%eax),%ecx
 d6d:	39 f9                	cmp    %edi,%ecx
 d6f:	73 47                	jae    db8 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 d71:	39 05 98 13 00 00    	cmp    %eax,0x1398
 d77:	89 c2                	mov    %eax,%edx
 d79:	75 ed                	jne    d68 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 d7b:	83 ec 0c             	sub    $0xc,%esp
 d7e:	56                   	push   %esi
 d7f:	e8 46 fc ff ff       	call   9ca <sbrk>
  if(p == (char*)-1)
 d84:	83 c4 10             	add    $0x10,%esp
 d87:	83 f8 ff             	cmp    $0xffffffff,%eax
 d8a:	74 1c                	je     da8 <malloc+0x88>
  hp->s.size = nu;
 d8c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 d8f:	83 ec 0c             	sub    $0xc,%esp
 d92:	83 c0 08             	add    $0x8,%eax
 d95:	50                   	push   %eax
 d96:	e8 f5 fe ff ff       	call   c90 <free>
  return freep;
 d9b:	8b 15 98 13 00 00    	mov    0x1398,%edx
      if((p = morecore(nunits)) == 0)
 da1:	83 c4 10             	add    $0x10,%esp
 da4:	85 d2                	test   %edx,%edx
 da6:	75 c0                	jne    d68 <malloc+0x48>
        return 0;
  }
}
 da8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 dab:	31 c0                	xor    %eax,%eax
}
 dad:	5b                   	pop    %ebx
 dae:	5e                   	pop    %esi
 daf:	5f                   	pop    %edi
 db0:	5d                   	pop    %ebp
 db1:	c3                   	ret    
 db2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 db8:	39 cf                	cmp    %ecx,%edi
 dba:	74 54                	je     e10 <malloc+0xf0>
        p->s.size -= nunits;
 dbc:	29 f9                	sub    %edi,%ecx
 dbe:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 dc1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 dc4:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 dc7:	89 15 98 13 00 00    	mov    %edx,0x1398
}
 dcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 dd0:	83 c0 08             	add    $0x8,%eax
}
 dd3:	5b                   	pop    %ebx
 dd4:	5e                   	pop    %esi
 dd5:	5f                   	pop    %edi
 dd6:	5d                   	pop    %ebp
 dd7:	c3                   	ret    
 dd8:	90                   	nop
 dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 de0:	c7 05 98 13 00 00 9c 	movl   $0x139c,0x1398
 de7:	13 00 00 
 dea:	c7 05 9c 13 00 00 9c 	movl   $0x139c,0x139c
 df1:	13 00 00 
    base.s.size = 0;
 df4:	b8 9c 13 00 00       	mov    $0x139c,%eax
 df9:	c7 05 a0 13 00 00 00 	movl   $0x0,0x13a0
 e00:	00 00 00 
 e03:	e9 44 ff ff ff       	jmp    d4c <malloc+0x2c>
 e08:	90                   	nop
 e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 e10:	8b 08                	mov    (%eax),%ecx
 e12:	89 0a                	mov    %ecx,(%edx)
 e14:	eb b1                	jmp    dc7 <malloc+0xa7>
