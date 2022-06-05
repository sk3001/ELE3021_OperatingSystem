
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
  3f:	e8 16 09 00 00       	call   95a <fork>
  44:	85 c0                	test   %eax,%eax
  46:	0f 88 10 01 00 00    	js     15c <main+0x15c>
    if (pid == 0){
  4c:	0f 84 1d 01 00 00    	je     16f <main+0x16f>
      close(gpipe[1]);
  52:	83 ec 0c             	sub    $0xc,%esp
  55:	ff 35 e4 13 00 00    	pushl  0x13e4
  5b:	e8 2a 09 00 00       	call   98a <close>
      if (wait() == -1 || read(gpipe[0], (char*)&ret, sizeof(ret)) == -1 || ret != 0){
  60:	e8 05 09 00 00       	call   96a <wait>
  65:	83 c4 10             	add    $0x10,%esp
  68:	83 f8 ff             	cmp    $0xffffffff,%eax
  6b:	0f 84 d2 00 00 00    	je     143 <main+0x143>
  71:	83 ec 04             	sub    $0x4,%esp
  74:	6a 04                	push   $0x4
  76:	57                   	push   %edi
  77:	ff 35 e0 13 00 00    	pushl  0x13e0
  7d:	e8 f8 08 00 00       	call   97a <read>
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
  9c:	ff 35 e0 13 00 00    	pushl  0x13e0
  a2:	e8 e3 08 00 00       	call   98a <close>
    }
    printf(1,"%d. %s finish\n", i, testname[i]);
  a7:	ff 34 9d a8 13 00 00 	pushl  0x13a8(,%ebx,4)
  ae:	53                   	push   %ebx
  for (i = start; i <= end; i++){
  af:	83 c3 01             	add    $0x1,%ebx
    printf(1,"%d. %s finish\n", i, testname[i]);
  b2:	68 c1 0e 00 00       	push   $0xec1
  b7:	6a 01                	push   $0x1
  b9:	e8 22 0a 00 00       	call   ae0 <printf>
    sleep(100);
  be:	83 c4 14             	add    $0x14,%esp
  c1:	6a 64                	push   $0x64
  c3:	e8 2a 09 00 00       	call   9f2 <sleep>
  for (i = start; i <= end; i++){
  c8:	83 c4 10             	add    $0x10,%esp
  cb:	39 f3                	cmp    %esi,%ebx
  cd:	7f 6f                	jg     13e <main+0x13e>
    printf(1,"%d. %s start\n", i, testname[i]);
  cf:	ff 34 9d a8 13 00 00 	pushl  0x13a8(,%ebx,4)
  d6:	53                   	push   %ebx
  d7:	68 8d 0e 00 00       	push   $0xe8d
  dc:	6a 01                	push   $0x1
  de:	e8 fd 09 00 00       	call   ae0 <printf>
    if (pipe(gpipe) < 0){
  e3:	c7 04 24 e0 13 00 00 	movl   $0x13e0,(%esp)
  ea:	e8 83 08 00 00       	call   972 <pipe>
  ef:	83 c4 10             	add    $0x10,%esp
  f2:	85 c0                	test   %eax,%eax
  f4:	0f 89 3e ff ff ff    	jns    38 <main+0x38>
      printf(1,"pipe panic\n");
  fa:	53                   	push   %ebx
  fb:	53                   	push   %ebx
  fc:	68 9b 0e 00 00       	push   $0xe9b
 101:	6a 01                	push   $0x1
 103:	e8 d8 09 00 00       	call   ae0 <printf>
      exit();
 108:	e8 55 08 00 00       	call   962 <exit>
    start = atoi(argv[1]);
 10d:	83 ec 0c             	sub    $0xc,%esp
 110:	ff 77 04             	pushl  0x4(%edi)
 113:	e8 d8 07 00 00       	call   8f0 <atoi>
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
 12c:	e8 bf 07 00 00       	call   8f0 <atoi>
 131:	83 c4 10             	add    $0x10,%esp
 134:	89 c6                	mov    %eax,%esi
  for (i = start; i <= end; i++){
 136:	39 de                	cmp    %ebx,%esi
 138:	0f 8d eb fe ff ff    	jge    29 <main+0x29>
  }
  exit();
 13e:	e8 1f 08 00 00       	call   962 <exit>
        printf(1,"%d. %s panic\n", i, testname[i]);
 143:	ff 34 9d a8 13 00 00 	pushl  0x13a8(,%ebx,4)
 14a:	53                   	push   %ebx
 14b:	68 b3 0e 00 00       	push   $0xeb3
 150:	6a 01                	push   $0x1
 152:	e8 89 09 00 00       	call   ae0 <printf>
        exit();
 157:	e8 06 08 00 00       	call   962 <exit>
      printf(1,"fork panic\n");
 15c:	51                   	push   %ecx
 15d:	51                   	push   %ecx
 15e:	68 a7 0e 00 00       	push   $0xea7
 163:	6a 01                	push   $0x1
 165:	e8 76 09 00 00       	call   ae0 <printf>
      exit();
 16a:	e8 f3 07 00 00       	call   962 <exit>
      close(gpipe[0]);
 16f:	83 ec 0c             	sub    $0xc,%esp
 172:	ff 35 e0 13 00 00    	pushl  0x13e0
 178:	e8 0d 08 00 00       	call   98a <close>
      ret = testfunc[i]();
 17d:	ff 14 9d bc 13 00 00 	call   *0x13bc(,%ebx,4)
 184:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      write(gpipe[1], (char*)&ret, sizeof(ret));
 187:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 18a:	83 c4 0c             	add    $0xc,%esp
 18d:	6a 04                	push   $0x4
 18f:	50                   	push   %eax
 190:	ff 35 e4 13 00 00    	pushl  0x13e4
 196:	e8 e7 07 00 00       	call   982 <write>
      close(gpipe[1]);
 19b:	5a                   	pop    %edx
 19c:	ff 35 e4 13 00 00    	pushl  0x13e4
 1a2:	e8 e3 07 00 00       	call   98a <close>
      exit();
 1a7:	e8 b6 07 00 00       	call   962 <exit>
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
 1e0:	a1 dc 13 00 00       	mov    0x13dc,%eax
    tmp++;
 1e5:	83 c0 01             	add    $0x1,%eax
	asm volatile("call %P0"::"i"(nop));
 1e8:	e8 d3 ff ff ff       	call   1c0 <nop>
  for (i = 0; i < 10000000; i++){
 1ed:	83 ea 01             	sub    $0x1,%edx
    gcnt = tmp;
 1f0:	a3 dc 13 00 00       	mov    %eax,0x13dc
  for (i = 0; i < 10000000; i++){
 1f5:	75 e9                	jne    1e0 <racingthreadmain+0x10>
  }
  thread_exit((void *)(tid+1));
 1f7:	8b 45 08             	mov    0x8(%ebp),%eax
 1fa:	83 ec 0c             	sub    $0xc,%esp
 1fd:	83 c0 01             	add    $0x1,%eax
 200:	50                   	push   %eax
 201:	e8 1c 08 00 00       	call   a22 <thread_exit>

  return 0;
}
 206:	31 c0                	xor    %eax,%eax
 208:	c9                   	leave  
 209:	c3                   	ret    
 20a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

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
 24b:	68 38 0e 00 00       	push   $0xe38
 250:	6a 01                	push   $0x1
 252:	e8 89 08 00 00       	call   ae0 <printf>
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
 269:	e8 b4 07 00 00       	call   a22 <thread_exit>

  return 0;
}
 26e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 271:	31 c0                	xor    %eax,%eax
 273:	5b                   	pop    %ebx
 274:	5e                   	pop    %esi
 275:	5f                   	pop    %edi
 276:	5d                   	pop    %ebp
 277:	c3                   	ret    
 278:	90                   	nop
 279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000280 <jointhreadmain>:

// ============================================================================

void*
jointhreadmain(void *arg)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	83 ec 14             	sub    $0x14,%esp
  int val = (int)arg;
  sleep(200);
 286:	68 c8 00 00 00       	push   $0xc8
 28b:	e8 62 07 00 00       	call   9f2 <sleep>
  printf(1, "thread_exit...\n");
 290:	58                   	pop    %eax
 291:	5a                   	pop    %edx
 292:	68 3b 0e 00 00       	push   $0xe3b
 297:	6a 01                	push   $0x1
 299:	e8 42 08 00 00       	call   ae0 <printf>
  thread_exit((void *)(val*2));
 29e:	8b 45 08             	mov    0x8(%ebp),%eax
 2a1:	01 c0                	add    %eax,%eax
 2a3:	89 04 24             	mov    %eax,(%esp)
 2a6:	e8 77 07 00 00       	call   a22 <thread_exit>

  return 0;
}
 2ab:	31 c0                	xor    %eax,%eax
 2ad:	c9                   	leave  
 2ae:	c3                   	ret    
 2af:	90                   	nop

000002b0 <stressthreadmain>:

// ============================================================================

void*
stressthreadmain(void *arg)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	83 ec 14             	sub    $0x14,%esp
  thread_exit(0);
 2b6:	6a 00                	push   $0x0
 2b8:	e8 65 07 00 00       	call   a22 <thread_exit>

  return 0;
}
 2bd:	31 c0                	xor    %eax,%eax
 2bf:	c9                   	leave  
 2c0:	c3                   	ret    
 2c1:	eb 0d                	jmp    2d0 <jointest2>
 2c3:	90                   	nop
 2c4:	90                   	nop
 2c5:	90                   	nop
 2c6:	90                   	nop
 2c7:	90                   	nop
 2c8:	90                   	nop
 2c9:	90                   	nop
 2ca:	90                   	nop
 2cb:	90                   	nop
 2cc:	90                   	nop
 2cd:	90                   	nop
 2ce:	90                   	nop
 2cf:	90                   	nop

000002d0 <jointest2>:
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	56                   	push   %esi
 2d4:	53                   	push   %ebx
 2d5:	8d 75 cc             	lea    -0x34(%ebp),%esi
  for (i = 1; i <= NUM_THREAD; i++){
 2d8:	bb 01 00 00 00       	mov    $0x1,%ebx
{
 2dd:	83 ec 40             	sub    $0x40,%esp
    if (thread_create(&threads[i-1], jointhreadmain, (void*)(i)) != 0){
 2e0:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
 2e3:	83 ec 04             	sub    $0x4,%esp
 2e6:	53                   	push   %ebx
 2e7:	68 80 02 00 00       	push   $0x280
 2ec:	50                   	push   %eax
 2ed:	e8 28 07 00 00       	call   a1a <thread_create>
 2f2:	83 c4 10             	add    $0x10,%esp
 2f5:	85 c0                	test   %eax,%eax
 2f7:	75 77                	jne    370 <jointest2+0xa0>
  for (i = 1; i <= NUM_THREAD; i++){
 2f9:	83 c3 01             	add    $0x1,%ebx
 2fc:	83 fb 0b             	cmp    $0xb,%ebx
 2ff:	75 df                	jne    2e0 <jointest2+0x10>
  sleep(500);
 301:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "thread_join!!!\n");
 304:	bb 02 00 00 00       	mov    $0x2,%ebx
  sleep(500);
 309:	68 f4 01 00 00       	push   $0x1f4
 30e:	e8 df 06 00 00       	call   9f2 <sleep>
  printf(1, "thread_join!!!\n");
 313:	58                   	pop    %eax
 314:	5a                   	pop    %edx
 315:	68 63 0e 00 00       	push   $0xe63
 31a:	6a 01                	push   $0x1
 31c:	e8 bf 07 00 00       	call   ae0 <printf>
 321:	83 c4 10             	add    $0x10,%esp
 324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
 328:	83 ec 08             	sub    $0x8,%esp
 32b:	56                   	push   %esi
 32c:	ff 74 5d cc          	pushl  -0x34(%ebp,%ebx,2)
 330:	e8 f5 06 00 00       	call   a2a <thread_join>
 335:	83 c4 10             	add    $0x10,%esp
 338:	85 c0                	test   %eax,%eax
 33a:	75 54                	jne    390 <jointest2+0xc0>
 33c:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
 33f:	75 4f                	jne    390 <jointest2+0xc0>
 341:	83 c3 02             	add    $0x2,%ebx
  for (i = 1; i <= NUM_THREAD; i++){
 344:	83 fb 16             	cmp    $0x16,%ebx
 347:	75 df                	jne    328 <jointest2+0x58>
  printf(1,"\n");
 349:	83 ec 08             	sub    $0x8,%esp
 34c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 34f:	68 71 0e 00 00       	push   $0xe71
 354:	6a 01                	push   $0x1
 356:	e8 85 07 00 00       	call   ae0 <printf>
  return 0;
 35b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 35e:	83 c4 10             	add    $0x10,%esp
}
 361:	8d 65 f8             	lea    -0x8(%ebp),%esp
 364:	5b                   	pop    %ebx
 365:	5e                   	pop    %esi
 366:	5d                   	pop    %ebp
 367:	c3                   	ret    
 368:	90                   	nop
 369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "panic at thread_create\n");
 370:	83 ec 08             	sub    $0x8,%esp
 373:	68 4b 0e 00 00       	push   $0xe4b
 378:	6a 01                	push   $0x1
 37a:	e8 61 07 00 00       	call   ae0 <printf>
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
      printf(1, "panic at thread_join\n");
 390:	83 ec 08             	sub    $0x8,%esp
 393:	68 73 0e 00 00       	push   $0xe73
 398:	6a 01                	push   $0x1
 39a:	e8 41 07 00 00       	call   ae0 <printf>
      return -1;
 39f:	83 c4 10             	add    $0x10,%esp
}
 3a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return -1;
 3a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 3aa:	5b                   	pop    %ebx
 3ab:	5e                   	pop    %esi
 3ac:	5d                   	pop    %ebp
 3ad:	c3                   	ret    
 3ae:	66 90                	xchg   %ax,%ax

000003b0 <jointest1>:
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	56                   	push   %esi
 3b4:	53                   	push   %ebx
 3b5:	8d 75 cc             	lea    -0x34(%ebp),%esi
  for (i = 1; i <= NUM_THREAD; i++){
 3b8:	bb 01 00 00 00       	mov    $0x1,%ebx
{
 3bd:	83 ec 40             	sub    $0x40,%esp
    if (thread_create(&threads[i-1], jointhreadmain, (void*)i) != 0){
 3c0:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
 3c3:	83 ec 04             	sub    $0x4,%esp
 3c6:	53                   	push   %ebx
 3c7:	68 80 02 00 00       	push   $0x280
 3cc:	50                   	push   %eax
 3cd:	e8 48 06 00 00       	call   a1a <thread_create>
 3d2:	83 c4 10             	add    $0x10,%esp
 3d5:	85 c0                	test   %eax,%eax
 3d7:	75 67                	jne    440 <jointest1+0x90>
  for (i = 1; i <= NUM_THREAD; i++){
 3d9:	83 c3 01             	add    $0x1,%ebx
 3dc:	83 fb 0b             	cmp    $0xb,%ebx
 3df:	75 df                	jne    3c0 <jointest1+0x10>
  printf(1, "thread_join!!!\n");
 3e1:	83 ec 08             	sub    $0x8,%esp
 3e4:	bb 02 00 00 00       	mov    $0x2,%ebx
 3e9:	68 63 0e 00 00       	push   $0xe63
 3ee:	6a 01                	push   $0x1
 3f0:	e8 eb 06 00 00       	call   ae0 <printf>
 3f5:	83 c4 10             	add    $0x10,%esp
 3f8:	90                   	nop
 3f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
 400:	83 ec 08             	sub    $0x8,%esp
 403:	56                   	push   %esi
 404:	ff 74 5d cc          	pushl  -0x34(%ebp,%ebx,2)
 408:	e8 1d 06 00 00       	call   a2a <thread_join>
 40d:	83 c4 10             	add    $0x10,%esp
 410:	85 c0                	test   %eax,%eax
 412:	75 4c                	jne    460 <jointest1+0xb0>
 414:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
 417:	75 47                	jne    460 <jointest1+0xb0>
 419:	83 c3 02             	add    $0x2,%ebx
  for (i = 1; i <= NUM_THREAD; i++){
 41c:	83 fb 16             	cmp    $0x16,%ebx
 41f:	75 df                	jne    400 <jointest1+0x50>
  printf(1,"\n");
 421:	83 ec 08             	sub    $0x8,%esp
 424:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 427:	68 71 0e 00 00       	push   $0xe71
 42c:	6a 01                	push   $0x1
 42e:	e8 ad 06 00 00       	call   ae0 <printf>
  return 0;
 433:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 436:	83 c4 10             	add    $0x10,%esp
}
 439:	8d 65 f8             	lea    -0x8(%ebp),%esp
 43c:	5b                   	pop    %ebx
 43d:	5e                   	pop    %esi
 43e:	5d                   	pop    %ebp
 43f:	c3                   	ret    
      printf(1, "panic at thread_create\n");
 440:	83 ec 08             	sub    $0x8,%esp
 443:	68 4b 0e 00 00       	push   $0xe4b
 448:	6a 01                	push   $0x1
 44a:	e8 91 06 00 00       	call   ae0 <printf>
      return -1;
 44f:	83 c4 10             	add    $0x10,%esp
}
 452:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return -1;
 455:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 45a:	5b                   	pop    %ebx
 45b:	5e                   	pop    %esi
 45c:	5d                   	pop    %ebp
 45d:	c3                   	ret    
 45e:	66 90                	xchg   %ax,%ax
      printf(1, "panic at thread_join\n");
 460:	83 ec 08             	sub    $0x8,%esp
 463:	68 73 0e 00 00       	push   $0xe73
 468:	6a 01                	push   $0x1
 46a:	e8 71 06 00 00       	call   ae0 <printf>
 46f:	83 c4 10             	add    $0x10,%esp
}
 472:	8d 65 f8             	lea    -0x8(%ebp),%esp
      printf(1, "panic at thread_join\n");
 475:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 47a:	5b                   	pop    %ebx
 47b:	5e                   	pop    %esi
 47c:	5d                   	pop    %ebp
 47d:	c3                   	ret    
 47e:	66 90                	xchg   %ax,%ax

00000480 <stresstest>:

int
stresstest(void)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	57                   	push   %edi
 484:	56                   	push   %esi
 485:	53                   	push   %ebx
 486:	8d 75 bc             	lea    -0x44(%ebp),%esi
 489:	83 ec 4c             	sub    $0x4c,%esp
  const int nstress = 35000;
  thread_t threads[NUM_THREAD];
  int i, n;
  void *retval;

  for (n = 1; n <= nstress; n++){
 48c:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
 493:	31 ff                	xor    %edi,%edi
 495:	8d 76 00             	lea    0x0(%esi),%esi
    if (n % 1000 == 0)
      printf(1, "%d\n", n);
    for (i = 0; i < NUM_THREAD; i++){
      if (thread_create(&threads[i], stressthreadmain, (void*)i) != 0){
 498:	8d 44 bd c0          	lea    -0x40(%ebp,%edi,4),%eax
 49c:	83 ec 04             	sub    $0x4,%esp
 49f:	8d 5d c0             	lea    -0x40(%ebp),%ebx
 4a2:	57                   	push   %edi
 4a3:	68 b0 02 00 00       	push   $0x2b0
 4a8:	50                   	push   %eax
 4a9:	e8 6c 05 00 00       	call   a1a <thread_create>
 4ae:	83 c4 10             	add    $0x10,%esp
 4b1:	85 c0                	test   %eax,%eax
 4b3:	75 6b                	jne    520 <stresstest+0xa0>
    for (i = 0; i < NUM_THREAD; i++){
 4b5:	83 c7 01             	add    $0x1,%edi
 4b8:	83 ff 0a             	cmp    $0xa,%edi
 4bb:	75 db                	jne    498 <stresstest+0x18>
 4bd:	8d 76 00             	lea    0x0(%esi),%esi
        printf(1, "panic at thread_create\n");
        return -1;
      }
    }
    for (i = 0; i < NUM_THREAD; i++){
      if (thread_join(threads[i], &retval) != 0){
 4c0:	83 ec 08             	sub    $0x8,%esp
 4c3:	56                   	push   %esi
 4c4:	ff 33                	pushl  (%ebx)
 4c6:	e8 5f 05 00 00       	call   a2a <thread_join>
 4cb:	83 c4 10             	add    $0x10,%esp
 4ce:	85 c0                	test   %eax,%eax
 4d0:	75 6e                	jne    540 <stresstest+0xc0>
    for (i = 0; i < NUM_THREAD; i++){
 4d2:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 4d5:	83 c3 04             	add    $0x4,%ebx
 4d8:	39 cb                	cmp    %ecx,%ebx
 4da:	75 e4                	jne    4c0 <stresstest+0x40>
  for (n = 1; n <= nstress; n++){
 4dc:	83 45 b4 01          	addl   $0x1,-0x4c(%ebp)
 4e0:	8b 55 b4             	mov    -0x4c(%ebp),%edx
 4e3:	81 fa b9 88 00 00    	cmp    $0x88b9,%edx
 4e9:	74 74                	je     55f <stresstest+0xdf>
    if (n % 1000 == 0)
 4eb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 4ee:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
 4f3:	f7 e2                	mul    %edx
 4f5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 4f8:	c1 ea 06             	shr    $0x6,%edx
 4fb:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
 501:	39 d0                	cmp    %edx,%eax
 503:	75 8e                	jne    493 <stresstest+0x13>
      printf(1, "%d\n", n);
 505:	83 ec 04             	sub    $0x4,%esp
 508:	50                   	push   %eax
 509:	68 89 0e 00 00       	push   $0xe89
 50e:	6a 01                	push   $0x1
 510:	e8 cb 05 00 00       	call   ae0 <printf>
 515:	83 c4 10             	add    $0x10,%esp
 518:	e9 76 ff ff ff       	jmp    493 <stresstest+0x13>
 51d:	8d 76 00             	lea    0x0(%esi),%esi
        printf(1, "panic at thread_create\n");
 520:	83 ec 08             	sub    $0x8,%esp
 523:	68 4b 0e 00 00       	push   $0xe4b
 528:	6a 01                	push   $0x1
 52a:	e8 b1 05 00 00       	call   ae0 <printf>
        return -1;
 52f:	83 c4 10             	add    $0x10,%esp
 532:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      }
    }
  }
  printf(1, "\n");
  return 0;
}
 537:	8d 65 f4             	lea    -0xc(%ebp),%esp
 53a:	5b                   	pop    %ebx
 53b:	5e                   	pop    %esi
 53c:	5f                   	pop    %edi
 53d:	5d                   	pop    %ebp
 53e:	c3                   	ret    
 53f:	90                   	nop
        printf(1, "panic at thread_join\n");
 540:	83 ec 08             	sub    $0x8,%esp
 543:	68 73 0e 00 00       	push   $0xe73
 548:	6a 01                	push   $0x1
 54a:	e8 91 05 00 00       	call   ae0 <printf>
        return -1;
 54f:	83 c4 10             	add    $0x10,%esp
}
 552:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
 555:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 55a:	5b                   	pop    %ebx
 55b:	5e                   	pop    %esi
 55c:	5f                   	pop    %edi
 55d:	5d                   	pop    %ebp
 55e:	c3                   	ret    
  printf(1, "\n");
 55f:	83 ec 08             	sub    $0x8,%esp
 562:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 565:	68 71 0e 00 00       	push   $0xe71
 56a:	6a 01                	push   $0x1
 56c:	e8 6f 05 00 00       	call   ae0 <printf>
 571:	83 c4 10             	add    $0x10,%esp
 574:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 577:	eb be                	jmp    537 <stresstest+0xb7>
 579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000580 <basictest>:
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
 583:	56                   	push   %esi
 584:	53                   	push   %ebx
  for (i = 0; i < NUM_THREAD; i++){
 585:	31 db                	xor    %ebx,%ebx
{
 587:	83 ec 40             	sub    $0x40,%esp
 58a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (thread_create(&threads[i], basicthreadmain, (void*)i) != 0){
 590:	8d 44 9d d0          	lea    -0x30(%ebp,%ebx,4),%eax
 594:	83 ec 04             	sub    $0x4,%esp
 597:	53                   	push   %ebx
 598:	68 10 02 00 00       	push   $0x210
 59d:	50                   	push   %eax
 59e:	e8 77 04 00 00       	call   a1a <thread_create>
 5a3:	83 c4 10             	add    $0x10,%esp
 5a6:	85 c0                	test   %eax,%eax
 5a8:	89 c6                	mov    %eax,%esi
 5aa:	75 54                	jne    600 <basictest+0x80>
  for (i = 0; i < NUM_THREAD; i++){
 5ac:	83 c3 01             	add    $0x1,%ebx
 5af:	83 fb 0a             	cmp    $0xa,%ebx
 5b2:	75 dc                	jne    590 <basictest+0x10>
 5b4:	8d 5d cc             	lea    -0x34(%ebp),%ebx
 5b7:	89 f6                	mov    %esi,%esi
 5b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
 5c0:	83 ec 08             	sub    $0x8,%esp
 5c3:	53                   	push   %ebx
 5c4:	ff 74 b5 d0          	pushl  -0x30(%ebp,%esi,4)
 5c8:	e8 5d 04 00 00       	call   a2a <thread_join>
 5cd:	83 c4 10             	add    $0x10,%esp
 5d0:	85 c0                	test   %eax,%eax
 5d2:	75 4c                	jne    620 <basictest+0xa0>
 5d4:	83 c6 01             	add    $0x1,%esi
 5d7:	39 75 cc             	cmp    %esi,-0x34(%ebp)
 5da:	75 44                	jne    620 <basictest+0xa0>
  for (i = 0; i < NUM_THREAD; i++){
 5dc:	83 fe 0a             	cmp    $0xa,%esi
 5df:	75 df                	jne    5c0 <basictest+0x40>
  printf(1,"\n");
 5e1:	83 ec 08             	sub    $0x8,%esp
 5e4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 5e7:	68 71 0e 00 00       	push   $0xe71
 5ec:	6a 01                	push   $0x1
 5ee:	e8 ed 04 00 00       	call   ae0 <printf>
  return 0;
 5f3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 5f6:	83 c4 10             	add    $0x10,%esp
}
 5f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
 5fc:	5b                   	pop    %ebx
 5fd:	5e                   	pop    %esi
 5fe:	5d                   	pop    %ebp
 5ff:	c3                   	ret    
      printf(1, "panic at thread_create\n");
 600:	83 ec 08             	sub    $0x8,%esp
 603:	68 4b 0e 00 00       	push   $0xe4b
 608:	6a 01                	push   $0x1
 60a:	e8 d1 04 00 00       	call   ae0 <printf>
      return -1;
 60f:	83 c4 10             	add    $0x10,%esp
}
 612:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return -1;
 615:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 61a:	5b                   	pop    %ebx
 61b:	5e                   	pop    %esi
 61c:	5d                   	pop    %ebp
 61d:	c3                   	ret    
 61e:	66 90                	xchg   %ax,%ax
      printf(1, "panic at thread_join\n");
 620:	83 ec 08             	sub    $0x8,%esp
 623:	68 73 0e 00 00       	push   $0xe73
 628:	6a 01                	push   $0x1
 62a:	e8 b1 04 00 00       	call   ae0 <printf>
 62f:	83 c4 10             	add    $0x10,%esp
}
 632:	8d 65 f8             	lea    -0x8(%ebp),%esp
      printf(1, "panic at thread_join\n");
 635:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 63a:	5b                   	pop    %ebx
 63b:	5e                   	pop    %esi
 63c:	5d                   	pop    %ebp
 63d:	c3                   	ret    
 63e:	66 90                	xchg   %ax,%ax

00000640 <racingtest>:
{
 640:	55                   	push   %ebp
 641:	89 e5                	mov    %esp,%ebp
 643:	56                   	push   %esi
 644:	53                   	push   %ebx
  for (i = 0; i < NUM_THREAD; i++){
 645:	31 db                	xor    %ebx,%ebx
{
 647:	83 ec 40             	sub    $0x40,%esp
  gcnt = 0;
 64a:	c7 05 dc 13 00 00 00 	movl   $0x0,0x13dc
 651:	00 00 00 
 654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (thread_create(&threads[i], racingthreadmain, (void*)i) != 0){
 658:	8d 44 9d d0          	lea    -0x30(%ebp,%ebx,4),%eax
 65c:	83 ec 04             	sub    $0x4,%esp
 65f:	53                   	push   %ebx
 660:	68 d0 01 00 00       	push   $0x1d0
 665:	50                   	push   %eax
 666:	e8 af 03 00 00       	call   a1a <thread_create>
 66b:	83 c4 10             	add    $0x10,%esp
 66e:	85 c0                	test   %eax,%eax
 670:	89 c6                	mov    %eax,%esi
 672:	75 5c                	jne    6d0 <racingtest+0x90>
  for (i = 0; i < NUM_THREAD; i++){
 674:	83 c3 01             	add    $0x1,%ebx
 677:	83 fb 0a             	cmp    $0xa,%ebx
 67a:	75 dc                	jne    658 <racingtest+0x18>
 67c:	8d 5d cc             	lea    -0x34(%ebp),%ebx
 67f:	90                   	nop
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
 680:	83 ec 08             	sub    $0x8,%esp
 683:	53                   	push   %ebx
 684:	ff 74 b5 d0          	pushl  -0x30(%ebp,%esi,4)
 688:	e8 9d 03 00 00       	call   a2a <thread_join>
 68d:	83 c4 10             	add    $0x10,%esp
 690:	85 c0                	test   %eax,%eax
 692:	75 5c                	jne    6f0 <racingtest+0xb0>
 694:	83 c6 01             	add    $0x1,%esi
 697:	39 75 cc             	cmp    %esi,-0x34(%ebp)
 69a:	75 54                	jne    6f0 <racingtest+0xb0>
  for (i = 0; i < NUM_THREAD; i++){
 69c:	83 fe 0a             	cmp    $0xa,%esi
 69f:	75 df                	jne    680 <racingtest+0x40>
  printf(1,"%d\n", gcnt);
 6a1:	8b 15 dc 13 00 00    	mov    0x13dc,%edx
 6a7:	83 ec 04             	sub    $0x4,%esp
 6aa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 6ad:	52                   	push   %edx
 6ae:	68 89 0e 00 00       	push   $0xe89
 6b3:	6a 01                	push   $0x1
 6b5:	e8 26 04 00 00       	call   ae0 <printf>
  return 0;
 6ba:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 6bd:	83 c4 10             	add    $0x10,%esp
}
 6c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
 6c3:	5b                   	pop    %ebx
 6c4:	5e                   	pop    %esi
 6c5:	5d                   	pop    %ebp
 6c6:	c3                   	ret    
 6c7:	89 f6                	mov    %esi,%esi
 6c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      printf(1, "panic at thread_create\n");
 6d0:	83 ec 08             	sub    $0x8,%esp
 6d3:	68 4b 0e 00 00       	push   $0xe4b
 6d8:	6a 01                	push   $0x1
 6da:	e8 01 04 00 00       	call   ae0 <printf>
      return -1;
 6df:	83 c4 10             	add    $0x10,%esp
}
 6e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return -1;
 6e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 6ea:	5b                   	pop    %ebx
 6eb:	5e                   	pop    %esi
 6ec:	5d                   	pop    %ebp
 6ed:	c3                   	ret    
 6ee:	66 90                	xchg   %ax,%ax
      printf(1, "panic at thread_join\n");
 6f0:	83 ec 08             	sub    $0x8,%esp
 6f3:	68 73 0e 00 00       	push   $0xe73
 6f8:	6a 01                	push   $0x1
 6fa:	e8 e1 03 00 00       	call   ae0 <printf>
 6ff:	83 c4 10             	add    $0x10,%esp
}
 702:	8d 65 f8             	lea    -0x8(%ebp),%esp
      printf(1, "panic at thread_join\n");
 705:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 70a:	5b                   	pop    %ebx
 70b:	5e                   	pop    %esi
 70c:	5d                   	pop    %ebp
 70d:	c3                   	ret    
 70e:	66 90                	xchg   %ax,%ax

00000710 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 710:	55                   	push   %ebp
 711:	89 e5                	mov    %esp,%ebp
 713:	53                   	push   %ebx
 714:	8b 45 08             	mov    0x8(%ebp),%eax
 717:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 71a:	89 c2                	mov    %eax,%edx
 71c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 720:	83 c1 01             	add    $0x1,%ecx
 723:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 727:	83 c2 01             	add    $0x1,%edx
 72a:	84 db                	test   %bl,%bl
 72c:	88 5a ff             	mov    %bl,-0x1(%edx)
 72f:	75 ef                	jne    720 <strcpy+0x10>
    ;
  return os;
}
 731:	5b                   	pop    %ebx
 732:	5d                   	pop    %ebp
 733:	c3                   	ret    
 734:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 73a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000740 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 740:	55                   	push   %ebp
 741:	89 e5                	mov    %esp,%ebp
 743:	53                   	push   %ebx
 744:	8b 55 08             	mov    0x8(%ebp),%edx
 747:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 74a:	0f b6 02             	movzbl (%edx),%eax
 74d:	0f b6 19             	movzbl (%ecx),%ebx
 750:	84 c0                	test   %al,%al
 752:	75 1c                	jne    770 <strcmp+0x30>
 754:	eb 2a                	jmp    780 <strcmp+0x40>
 756:	8d 76 00             	lea    0x0(%esi),%esi
 759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 760:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 763:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 766:	83 c1 01             	add    $0x1,%ecx
 769:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 76c:	84 c0                	test   %al,%al
 76e:	74 10                	je     780 <strcmp+0x40>
 770:	38 d8                	cmp    %bl,%al
 772:	74 ec                	je     760 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 774:	29 d8                	sub    %ebx,%eax
}
 776:	5b                   	pop    %ebx
 777:	5d                   	pop    %ebp
 778:	c3                   	ret    
 779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 780:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 782:	29 d8                	sub    %ebx,%eax
}
 784:	5b                   	pop    %ebx
 785:	5d                   	pop    %ebp
 786:	c3                   	ret    
 787:	89 f6                	mov    %esi,%esi
 789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000790 <strlen>:

uint
strlen(const char *s)
{
 790:	55                   	push   %ebp
 791:	89 e5                	mov    %esp,%ebp
 793:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 796:	80 39 00             	cmpb   $0x0,(%ecx)
 799:	74 15                	je     7b0 <strlen+0x20>
 79b:	31 d2                	xor    %edx,%edx
 79d:	8d 76 00             	lea    0x0(%esi),%esi
 7a0:	83 c2 01             	add    $0x1,%edx
 7a3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 7a7:	89 d0                	mov    %edx,%eax
 7a9:	75 f5                	jne    7a0 <strlen+0x10>
    ;
  return n;
}
 7ab:	5d                   	pop    %ebp
 7ac:	c3                   	ret    
 7ad:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 7b0:	31 c0                	xor    %eax,%eax
}
 7b2:	5d                   	pop    %ebp
 7b3:	c3                   	ret    
 7b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 7ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000007c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 7c0:	55                   	push   %ebp
 7c1:	89 e5                	mov    %esp,%ebp
 7c3:	57                   	push   %edi
 7c4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 7c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 7ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 7cd:	89 d7                	mov    %edx,%edi
 7cf:	fc                   	cld    
 7d0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 7d2:	89 d0                	mov    %edx,%eax
 7d4:	5f                   	pop    %edi
 7d5:	5d                   	pop    %ebp
 7d6:	c3                   	ret    
 7d7:	89 f6                	mov    %esi,%esi
 7d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000007e0 <strchr>:

char*
strchr(const char *s, char c)
{
 7e0:	55                   	push   %ebp
 7e1:	89 e5                	mov    %esp,%ebp
 7e3:	53                   	push   %ebx
 7e4:	8b 45 08             	mov    0x8(%ebp),%eax
 7e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 7ea:	0f b6 10             	movzbl (%eax),%edx
 7ed:	84 d2                	test   %dl,%dl
 7ef:	74 1d                	je     80e <strchr+0x2e>
    if(*s == c)
 7f1:	38 d3                	cmp    %dl,%bl
 7f3:	89 d9                	mov    %ebx,%ecx
 7f5:	75 0d                	jne    804 <strchr+0x24>
 7f7:	eb 17                	jmp    810 <strchr+0x30>
 7f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 800:	38 ca                	cmp    %cl,%dl
 802:	74 0c                	je     810 <strchr+0x30>
  for(; *s; s++)
 804:	83 c0 01             	add    $0x1,%eax
 807:	0f b6 10             	movzbl (%eax),%edx
 80a:	84 d2                	test   %dl,%dl
 80c:	75 f2                	jne    800 <strchr+0x20>
      return (char*)s;
  return 0;
 80e:	31 c0                	xor    %eax,%eax
}
 810:	5b                   	pop    %ebx
 811:	5d                   	pop    %ebp
 812:	c3                   	ret    
 813:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000820 <gets>:

char*
gets(char *buf, int max)
{
 820:	55                   	push   %ebp
 821:	89 e5                	mov    %esp,%ebp
 823:	57                   	push   %edi
 824:	56                   	push   %esi
 825:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 826:	31 f6                	xor    %esi,%esi
 828:	89 f3                	mov    %esi,%ebx
{
 82a:	83 ec 1c             	sub    $0x1c,%esp
 82d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 830:	eb 2f                	jmp    861 <gets+0x41>
 832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 838:	8d 45 e7             	lea    -0x19(%ebp),%eax
 83b:	83 ec 04             	sub    $0x4,%esp
 83e:	6a 01                	push   $0x1
 840:	50                   	push   %eax
 841:	6a 00                	push   $0x0
 843:	e8 32 01 00 00       	call   97a <read>
    if(cc < 1)
 848:	83 c4 10             	add    $0x10,%esp
 84b:	85 c0                	test   %eax,%eax
 84d:	7e 1c                	jle    86b <gets+0x4b>
      break;
    buf[i++] = c;
 84f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 853:	83 c7 01             	add    $0x1,%edi
 856:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 859:	3c 0a                	cmp    $0xa,%al
 85b:	74 23                	je     880 <gets+0x60>
 85d:	3c 0d                	cmp    $0xd,%al
 85f:	74 1f                	je     880 <gets+0x60>
  for(i=0; i+1 < max; ){
 861:	83 c3 01             	add    $0x1,%ebx
 864:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 867:	89 fe                	mov    %edi,%esi
 869:	7c cd                	jl     838 <gets+0x18>
 86b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 86d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 870:	c6 03 00             	movb   $0x0,(%ebx)
}
 873:	8d 65 f4             	lea    -0xc(%ebp),%esp
 876:	5b                   	pop    %ebx
 877:	5e                   	pop    %esi
 878:	5f                   	pop    %edi
 879:	5d                   	pop    %ebp
 87a:	c3                   	ret    
 87b:	90                   	nop
 87c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 880:	8b 75 08             	mov    0x8(%ebp),%esi
 883:	8b 45 08             	mov    0x8(%ebp),%eax
 886:	01 de                	add    %ebx,%esi
 888:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 88a:	c6 03 00             	movb   $0x0,(%ebx)
}
 88d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 890:	5b                   	pop    %ebx
 891:	5e                   	pop    %esi
 892:	5f                   	pop    %edi
 893:	5d                   	pop    %ebp
 894:	c3                   	ret    
 895:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000008a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 8a0:	55                   	push   %ebp
 8a1:	89 e5                	mov    %esp,%ebp
 8a3:	56                   	push   %esi
 8a4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 8a5:	83 ec 08             	sub    $0x8,%esp
 8a8:	6a 00                	push   $0x0
 8aa:	ff 75 08             	pushl  0x8(%ebp)
 8ad:	e8 f0 00 00 00       	call   9a2 <open>
  if(fd < 0)
 8b2:	83 c4 10             	add    $0x10,%esp
 8b5:	85 c0                	test   %eax,%eax
 8b7:	78 27                	js     8e0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 8b9:	83 ec 08             	sub    $0x8,%esp
 8bc:	ff 75 0c             	pushl  0xc(%ebp)
 8bf:	89 c3                	mov    %eax,%ebx
 8c1:	50                   	push   %eax
 8c2:	e8 f3 00 00 00       	call   9ba <fstat>
  close(fd);
 8c7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 8ca:	89 c6                	mov    %eax,%esi
  close(fd);
 8cc:	e8 b9 00 00 00       	call   98a <close>
  return r;
 8d1:	83 c4 10             	add    $0x10,%esp
}
 8d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 8d7:	89 f0                	mov    %esi,%eax
 8d9:	5b                   	pop    %ebx
 8da:	5e                   	pop    %esi
 8db:	5d                   	pop    %ebp
 8dc:	c3                   	ret    
 8dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 8e0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 8e5:	eb ed                	jmp    8d4 <stat+0x34>
 8e7:	89 f6                	mov    %esi,%esi
 8e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000008f0 <atoi>:

int
atoi(const char *s)
{
 8f0:	55                   	push   %ebp
 8f1:	89 e5                	mov    %esp,%ebp
 8f3:	53                   	push   %ebx
 8f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 8f7:	0f be 11             	movsbl (%ecx),%edx
 8fa:	8d 42 d0             	lea    -0x30(%edx),%eax
 8fd:	3c 09                	cmp    $0x9,%al
  n = 0;
 8ff:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 904:	77 1f                	ja     925 <atoi+0x35>
 906:	8d 76 00             	lea    0x0(%esi),%esi
 909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 910:	8d 04 80             	lea    (%eax,%eax,4),%eax
 913:	83 c1 01             	add    $0x1,%ecx
 916:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 91a:	0f be 11             	movsbl (%ecx),%edx
 91d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 920:	80 fb 09             	cmp    $0x9,%bl
 923:	76 eb                	jbe    910 <atoi+0x20>
  return n;
}
 925:	5b                   	pop    %ebx
 926:	5d                   	pop    %ebp
 927:	c3                   	ret    
 928:	90                   	nop
 929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000930 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 930:	55                   	push   %ebp
 931:	89 e5                	mov    %esp,%ebp
 933:	56                   	push   %esi
 934:	53                   	push   %ebx
 935:	8b 5d 10             	mov    0x10(%ebp),%ebx
 938:	8b 45 08             	mov    0x8(%ebp),%eax
 93b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 93e:	85 db                	test   %ebx,%ebx
 940:	7e 14                	jle    956 <memmove+0x26>
 942:	31 d2                	xor    %edx,%edx
 944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 948:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 94c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 94f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 952:	39 d3                	cmp    %edx,%ebx
 954:	75 f2                	jne    948 <memmove+0x18>
  return vdst;
}
 956:	5b                   	pop    %ebx
 957:	5e                   	pop    %esi
 958:	5d                   	pop    %ebp
 959:	c3                   	ret    

0000095a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 95a:	b8 01 00 00 00       	mov    $0x1,%eax
 95f:	cd 40                	int    $0x40
 961:	c3                   	ret    

00000962 <exit>:
SYSCALL(exit)
 962:	b8 02 00 00 00       	mov    $0x2,%eax
 967:	cd 40                	int    $0x40
 969:	c3                   	ret    

0000096a <wait>:
SYSCALL(wait)
 96a:	b8 03 00 00 00       	mov    $0x3,%eax
 96f:	cd 40                	int    $0x40
 971:	c3                   	ret    

00000972 <pipe>:
SYSCALL(pipe)
 972:	b8 04 00 00 00       	mov    $0x4,%eax
 977:	cd 40                	int    $0x40
 979:	c3                   	ret    

0000097a <read>:
SYSCALL(read)
 97a:	b8 05 00 00 00       	mov    $0x5,%eax
 97f:	cd 40                	int    $0x40
 981:	c3                   	ret    

00000982 <write>:
SYSCALL(write)
 982:	b8 10 00 00 00       	mov    $0x10,%eax
 987:	cd 40                	int    $0x40
 989:	c3                   	ret    

0000098a <close>:
SYSCALL(close)
 98a:	b8 15 00 00 00       	mov    $0x15,%eax
 98f:	cd 40                	int    $0x40
 991:	c3                   	ret    

00000992 <kill>:
SYSCALL(kill)
 992:	b8 06 00 00 00       	mov    $0x6,%eax
 997:	cd 40                	int    $0x40
 999:	c3                   	ret    

0000099a <exec>:
SYSCALL(exec)
 99a:	b8 07 00 00 00       	mov    $0x7,%eax
 99f:	cd 40                	int    $0x40
 9a1:	c3                   	ret    

000009a2 <open>:
SYSCALL(open)
 9a2:	b8 0f 00 00 00       	mov    $0xf,%eax
 9a7:	cd 40                	int    $0x40
 9a9:	c3                   	ret    

000009aa <mknod>:
SYSCALL(mknod)
 9aa:	b8 11 00 00 00       	mov    $0x11,%eax
 9af:	cd 40                	int    $0x40
 9b1:	c3                   	ret    

000009b2 <unlink>:
SYSCALL(unlink)
 9b2:	b8 12 00 00 00       	mov    $0x12,%eax
 9b7:	cd 40                	int    $0x40
 9b9:	c3                   	ret    

000009ba <fstat>:
SYSCALL(fstat)
 9ba:	b8 08 00 00 00       	mov    $0x8,%eax
 9bf:	cd 40                	int    $0x40
 9c1:	c3                   	ret    

000009c2 <link>:
SYSCALL(link)
 9c2:	b8 13 00 00 00       	mov    $0x13,%eax
 9c7:	cd 40                	int    $0x40
 9c9:	c3                   	ret    

000009ca <mkdir>:
SYSCALL(mkdir)
 9ca:	b8 14 00 00 00       	mov    $0x14,%eax
 9cf:	cd 40                	int    $0x40
 9d1:	c3                   	ret    

000009d2 <chdir>:
SYSCALL(chdir)
 9d2:	b8 09 00 00 00       	mov    $0x9,%eax
 9d7:	cd 40                	int    $0x40
 9d9:	c3                   	ret    

000009da <dup>:
SYSCALL(dup)
 9da:	b8 0a 00 00 00       	mov    $0xa,%eax
 9df:	cd 40                	int    $0x40
 9e1:	c3                   	ret    

000009e2 <getpid>:
SYSCALL(getpid)
 9e2:	b8 0b 00 00 00       	mov    $0xb,%eax
 9e7:	cd 40                	int    $0x40
 9e9:	c3                   	ret    

000009ea <sbrk>:
SYSCALL(sbrk)
 9ea:	b8 0c 00 00 00       	mov    $0xc,%eax
 9ef:	cd 40                	int    $0x40
 9f1:	c3                   	ret    

000009f2 <sleep>:
SYSCALL(sleep)
 9f2:	b8 0d 00 00 00       	mov    $0xd,%eax
 9f7:	cd 40                	int    $0x40
 9f9:	c3                   	ret    

000009fa <uptime>:
SYSCALL(uptime)
 9fa:	b8 0e 00 00 00       	mov    $0xe,%eax
 9ff:	cd 40                	int    $0x40
 a01:	c3                   	ret    

00000a02 <yield>:
SYSCALL(yield)
 a02:	b8 16 00 00 00       	mov    $0x16,%eax
 a07:	cd 40                	int    $0x40
 a09:	c3                   	ret    

00000a0a <getlev>:
SYSCALL(getlev)
 a0a:	b8 17 00 00 00       	mov    $0x17,%eax
 a0f:	cd 40                	int    $0x40
 a11:	c3                   	ret    

00000a12 <set_cpu_share>:
SYSCALL(set_cpu_share)
 a12:	b8 18 00 00 00       	mov    $0x18,%eax
 a17:	cd 40                	int    $0x40
 a19:	c3                   	ret    

00000a1a <thread_create>:
SYSCALL(thread_create)
 a1a:	b8 19 00 00 00       	mov    $0x19,%eax
 a1f:	cd 40                	int    $0x40
 a21:	c3                   	ret    

00000a22 <thread_exit>:
SYSCALL(thread_exit)
 a22:	b8 1a 00 00 00       	mov    $0x1a,%eax
 a27:	cd 40                	int    $0x40
 a29:	c3                   	ret    

00000a2a <thread_join>:
SYSCALL(thread_join)
 a2a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 a2f:	cd 40                	int    $0x40
 a31:	c3                   	ret    
 a32:	66 90                	xchg   %ax,%ax
 a34:	66 90                	xchg   %ax,%ax
 a36:	66 90                	xchg   %ax,%ax
 a38:	66 90                	xchg   %ax,%ax
 a3a:	66 90                	xchg   %ax,%ax
 a3c:	66 90                	xchg   %ax,%ax
 a3e:	66 90                	xchg   %ax,%ax

00000a40 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 a40:	55                   	push   %ebp
 a41:	89 e5                	mov    %esp,%ebp
 a43:	57                   	push   %edi
 a44:	56                   	push   %esi
 a45:	53                   	push   %ebx
 a46:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 a49:	85 d2                	test   %edx,%edx
{
 a4b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 a4e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 a50:	79 76                	jns    ac8 <printint+0x88>
 a52:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 a56:	74 70                	je     ac8 <printint+0x88>
    x = -xx;
 a58:	f7 d8                	neg    %eax
    neg = 1;
 a5a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 a61:	31 f6                	xor    %esi,%esi
 a63:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 a66:	eb 0a                	jmp    a72 <printint+0x32>
 a68:	90                   	nop
 a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 a70:	89 fe                	mov    %edi,%esi
 a72:	31 d2                	xor    %edx,%edx
 a74:	8d 7e 01             	lea    0x1(%esi),%edi
 a77:	f7 f1                	div    %ecx
 a79:	0f b6 92 0c 0f 00 00 	movzbl 0xf0c(%edx),%edx
  }while((x /= base) != 0);
 a80:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 a82:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 a85:	75 e9                	jne    a70 <printint+0x30>
  if(neg)
 a87:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 a8a:	85 c0                	test   %eax,%eax
 a8c:	74 08                	je     a96 <printint+0x56>
    buf[i++] = '-';
 a8e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 a93:	8d 7e 02             	lea    0x2(%esi),%edi
 a96:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 a9a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 a9d:	8d 76 00             	lea    0x0(%esi),%esi
 aa0:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 aa3:	83 ec 04             	sub    $0x4,%esp
 aa6:	83 ee 01             	sub    $0x1,%esi
 aa9:	6a 01                	push   $0x1
 aab:	53                   	push   %ebx
 aac:	57                   	push   %edi
 aad:	88 45 d7             	mov    %al,-0x29(%ebp)
 ab0:	e8 cd fe ff ff       	call   982 <write>

  while(--i >= 0)
 ab5:	83 c4 10             	add    $0x10,%esp
 ab8:	39 de                	cmp    %ebx,%esi
 aba:	75 e4                	jne    aa0 <printint+0x60>
    putc(fd, buf[i]);
}
 abc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 abf:	5b                   	pop    %ebx
 ac0:	5e                   	pop    %esi
 ac1:	5f                   	pop    %edi
 ac2:	5d                   	pop    %ebp
 ac3:	c3                   	ret    
 ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 ac8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 acf:	eb 90                	jmp    a61 <printint+0x21>
 ad1:	eb 0d                	jmp    ae0 <printf>
 ad3:	90                   	nop
 ad4:	90                   	nop
 ad5:	90                   	nop
 ad6:	90                   	nop
 ad7:	90                   	nop
 ad8:	90                   	nop
 ad9:	90                   	nop
 ada:	90                   	nop
 adb:	90                   	nop
 adc:	90                   	nop
 add:	90                   	nop
 ade:	90                   	nop
 adf:	90                   	nop

00000ae0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 ae0:	55                   	push   %ebp
 ae1:	89 e5                	mov    %esp,%ebp
 ae3:	57                   	push   %edi
 ae4:	56                   	push   %esi
 ae5:	53                   	push   %ebx
 ae6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 ae9:	8b 75 0c             	mov    0xc(%ebp),%esi
 aec:	0f b6 1e             	movzbl (%esi),%ebx
 aef:	84 db                	test   %bl,%bl
 af1:	0f 84 b3 00 00 00    	je     baa <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 af7:	8d 45 10             	lea    0x10(%ebp),%eax
 afa:	83 c6 01             	add    $0x1,%esi
  state = 0;
 afd:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 aff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 b02:	eb 2f                	jmp    b33 <printf+0x53>
 b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 b08:	83 f8 25             	cmp    $0x25,%eax
 b0b:	0f 84 a7 00 00 00    	je     bb8 <printf+0xd8>
  write(fd, &c, 1);
 b11:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 b14:	83 ec 04             	sub    $0x4,%esp
 b17:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 b1a:	6a 01                	push   $0x1
 b1c:	50                   	push   %eax
 b1d:	ff 75 08             	pushl  0x8(%ebp)
 b20:	e8 5d fe ff ff       	call   982 <write>
 b25:	83 c4 10             	add    $0x10,%esp
 b28:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 b2b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 b2f:	84 db                	test   %bl,%bl
 b31:	74 77                	je     baa <printf+0xca>
    if(state == 0){
 b33:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 b35:	0f be cb             	movsbl %bl,%ecx
 b38:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 b3b:	74 cb                	je     b08 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 b3d:	83 ff 25             	cmp    $0x25,%edi
 b40:	75 e6                	jne    b28 <printf+0x48>
      if(c == 'd'){
 b42:	83 f8 64             	cmp    $0x64,%eax
 b45:	0f 84 05 01 00 00    	je     c50 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 b4b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 b51:	83 f9 70             	cmp    $0x70,%ecx
 b54:	74 72                	je     bc8 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 b56:	83 f8 73             	cmp    $0x73,%eax
 b59:	0f 84 99 00 00 00    	je     bf8 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 b5f:	83 f8 63             	cmp    $0x63,%eax
 b62:	0f 84 08 01 00 00    	je     c70 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 b68:	83 f8 25             	cmp    $0x25,%eax
 b6b:	0f 84 ef 00 00 00    	je     c60 <printf+0x180>
  write(fd, &c, 1);
 b71:	8d 45 e7             	lea    -0x19(%ebp),%eax
 b74:	83 ec 04             	sub    $0x4,%esp
 b77:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 b7b:	6a 01                	push   $0x1
 b7d:	50                   	push   %eax
 b7e:	ff 75 08             	pushl  0x8(%ebp)
 b81:	e8 fc fd ff ff       	call   982 <write>
 b86:	83 c4 0c             	add    $0xc,%esp
 b89:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 b8c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 b8f:	6a 01                	push   $0x1
 b91:	50                   	push   %eax
 b92:	ff 75 08             	pushl  0x8(%ebp)
 b95:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 b98:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 b9a:	e8 e3 fd ff ff       	call   982 <write>
  for(i = 0; fmt[i]; i++){
 b9f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 ba3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 ba6:	84 db                	test   %bl,%bl
 ba8:	75 89                	jne    b33 <printf+0x53>
    }
  }
}
 baa:	8d 65 f4             	lea    -0xc(%ebp),%esp
 bad:	5b                   	pop    %ebx
 bae:	5e                   	pop    %esi
 baf:	5f                   	pop    %edi
 bb0:	5d                   	pop    %ebp
 bb1:	c3                   	ret    
 bb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 bb8:	bf 25 00 00 00       	mov    $0x25,%edi
 bbd:	e9 66 ff ff ff       	jmp    b28 <printf+0x48>
 bc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 bc8:	83 ec 0c             	sub    $0xc,%esp
 bcb:	b9 10 00 00 00       	mov    $0x10,%ecx
 bd0:	6a 00                	push   $0x0
 bd2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 bd5:	8b 45 08             	mov    0x8(%ebp),%eax
 bd8:	8b 17                	mov    (%edi),%edx
 bda:	e8 61 fe ff ff       	call   a40 <printint>
        ap++;
 bdf:	89 f8                	mov    %edi,%eax
 be1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 be4:	31 ff                	xor    %edi,%edi
        ap++;
 be6:	83 c0 04             	add    $0x4,%eax
 be9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 bec:	e9 37 ff ff ff       	jmp    b28 <printf+0x48>
 bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 bf8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 bfb:	8b 08                	mov    (%eax),%ecx
        ap++;
 bfd:	83 c0 04             	add    $0x4,%eax
 c00:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 c03:	85 c9                	test   %ecx,%ecx
 c05:	0f 84 8e 00 00 00    	je     c99 <printf+0x1b9>
        while(*s != 0){
 c0b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 c0e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 c10:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 c12:	84 c0                	test   %al,%al
 c14:	0f 84 0e ff ff ff    	je     b28 <printf+0x48>
 c1a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 c1d:	89 de                	mov    %ebx,%esi
 c1f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 c22:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 c25:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 c28:	83 ec 04             	sub    $0x4,%esp
          s++;
 c2b:	83 c6 01             	add    $0x1,%esi
 c2e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 c31:	6a 01                	push   $0x1
 c33:	57                   	push   %edi
 c34:	53                   	push   %ebx
 c35:	e8 48 fd ff ff       	call   982 <write>
        while(*s != 0){
 c3a:	0f b6 06             	movzbl (%esi),%eax
 c3d:	83 c4 10             	add    $0x10,%esp
 c40:	84 c0                	test   %al,%al
 c42:	75 e4                	jne    c28 <printf+0x148>
 c44:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 c47:	31 ff                	xor    %edi,%edi
 c49:	e9 da fe ff ff       	jmp    b28 <printf+0x48>
 c4e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 c50:	83 ec 0c             	sub    $0xc,%esp
 c53:	b9 0a 00 00 00       	mov    $0xa,%ecx
 c58:	6a 01                	push   $0x1
 c5a:	e9 73 ff ff ff       	jmp    bd2 <printf+0xf2>
 c5f:	90                   	nop
  write(fd, &c, 1);
 c60:	83 ec 04             	sub    $0x4,%esp
 c63:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 c66:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 c69:	6a 01                	push   $0x1
 c6b:	e9 21 ff ff ff       	jmp    b91 <printf+0xb1>
        putc(fd, *ap);
 c70:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 c73:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 c76:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 c78:	6a 01                	push   $0x1
        ap++;
 c7a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 c7d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 c80:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 c83:	50                   	push   %eax
 c84:	ff 75 08             	pushl  0x8(%ebp)
 c87:	e8 f6 fc ff ff       	call   982 <write>
        ap++;
 c8c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 c8f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 c92:	31 ff                	xor    %edi,%edi
 c94:	e9 8f fe ff ff       	jmp    b28 <printf+0x48>
          s = "(null)";
 c99:	bb 04 0f 00 00       	mov    $0xf04,%ebx
        while(*s != 0){
 c9e:	b8 28 00 00 00       	mov    $0x28,%eax
 ca3:	e9 72 ff ff ff       	jmp    c1a <printf+0x13a>
 ca8:	66 90                	xchg   %ax,%ax
 caa:	66 90                	xchg   %ax,%ax
 cac:	66 90                	xchg   %ax,%ax
 cae:	66 90                	xchg   %ax,%ax

00000cb0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 cb0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cb1:	a1 d0 13 00 00       	mov    0x13d0,%eax
{
 cb6:	89 e5                	mov    %esp,%ebp
 cb8:	57                   	push   %edi
 cb9:	56                   	push   %esi
 cba:	53                   	push   %ebx
 cbb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 cbe:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 cc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cc8:	39 c8                	cmp    %ecx,%eax
 cca:	8b 10                	mov    (%eax),%edx
 ccc:	73 32                	jae    d00 <free+0x50>
 cce:	39 d1                	cmp    %edx,%ecx
 cd0:	72 04                	jb     cd6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 cd2:	39 d0                	cmp    %edx,%eax
 cd4:	72 32                	jb     d08 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 cd6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 cd9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 cdc:	39 fa                	cmp    %edi,%edx
 cde:	74 30                	je     d10 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 ce0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 ce3:	8b 50 04             	mov    0x4(%eax),%edx
 ce6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 ce9:	39 f1                	cmp    %esi,%ecx
 ceb:	74 3a                	je     d27 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 ced:	89 08                	mov    %ecx,(%eax)
  freep = p;
 cef:	a3 d0 13 00 00       	mov    %eax,0x13d0
}
 cf4:	5b                   	pop    %ebx
 cf5:	5e                   	pop    %esi
 cf6:	5f                   	pop    %edi
 cf7:	5d                   	pop    %ebp
 cf8:	c3                   	ret    
 cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d00:	39 d0                	cmp    %edx,%eax
 d02:	72 04                	jb     d08 <free+0x58>
 d04:	39 d1                	cmp    %edx,%ecx
 d06:	72 ce                	jb     cd6 <free+0x26>
{
 d08:	89 d0                	mov    %edx,%eax
 d0a:	eb bc                	jmp    cc8 <free+0x18>
 d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 d10:	03 72 04             	add    0x4(%edx),%esi
 d13:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 d16:	8b 10                	mov    (%eax),%edx
 d18:	8b 12                	mov    (%edx),%edx
 d1a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 d1d:	8b 50 04             	mov    0x4(%eax),%edx
 d20:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 d23:	39 f1                	cmp    %esi,%ecx
 d25:	75 c6                	jne    ced <free+0x3d>
    p->s.size += bp->s.size;
 d27:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 d2a:	a3 d0 13 00 00       	mov    %eax,0x13d0
    p->s.size += bp->s.size;
 d2f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 d32:	8b 53 f8             	mov    -0x8(%ebx),%edx
 d35:	89 10                	mov    %edx,(%eax)
}
 d37:	5b                   	pop    %ebx
 d38:	5e                   	pop    %esi
 d39:	5f                   	pop    %edi
 d3a:	5d                   	pop    %ebp
 d3b:	c3                   	ret    
 d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000d40 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 d40:	55                   	push   %ebp
 d41:	89 e5                	mov    %esp,%ebp
 d43:	57                   	push   %edi
 d44:	56                   	push   %esi
 d45:	53                   	push   %ebx
 d46:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d49:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 d4c:	8b 15 d0 13 00 00    	mov    0x13d0,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d52:	8d 78 07             	lea    0x7(%eax),%edi
 d55:	c1 ef 03             	shr    $0x3,%edi
 d58:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 d5b:	85 d2                	test   %edx,%edx
 d5d:	0f 84 9d 00 00 00    	je     e00 <malloc+0xc0>
 d63:	8b 02                	mov    (%edx),%eax
 d65:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 d68:	39 cf                	cmp    %ecx,%edi
 d6a:	76 6c                	jbe    dd8 <malloc+0x98>
 d6c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 d72:	bb 00 10 00 00       	mov    $0x1000,%ebx
 d77:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 d7a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 d81:	eb 0e                	jmp    d91 <malloc+0x51>
 d83:	90                   	nop
 d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d88:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 d8a:	8b 48 04             	mov    0x4(%eax),%ecx
 d8d:	39 f9                	cmp    %edi,%ecx
 d8f:	73 47                	jae    dd8 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 d91:	39 05 d0 13 00 00    	cmp    %eax,0x13d0
 d97:	89 c2                	mov    %eax,%edx
 d99:	75 ed                	jne    d88 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 d9b:	83 ec 0c             	sub    $0xc,%esp
 d9e:	56                   	push   %esi
 d9f:	e8 46 fc ff ff       	call   9ea <sbrk>
  if(p == (char*)-1)
 da4:	83 c4 10             	add    $0x10,%esp
 da7:	83 f8 ff             	cmp    $0xffffffff,%eax
 daa:	74 1c                	je     dc8 <malloc+0x88>
  hp->s.size = nu;
 dac:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 daf:	83 ec 0c             	sub    $0xc,%esp
 db2:	83 c0 08             	add    $0x8,%eax
 db5:	50                   	push   %eax
 db6:	e8 f5 fe ff ff       	call   cb0 <free>
  return freep;
 dbb:	8b 15 d0 13 00 00    	mov    0x13d0,%edx
      if((p = morecore(nunits)) == 0)
 dc1:	83 c4 10             	add    $0x10,%esp
 dc4:	85 d2                	test   %edx,%edx
 dc6:	75 c0                	jne    d88 <malloc+0x48>
        return 0;
  }
}
 dc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 dcb:	31 c0                	xor    %eax,%eax
}
 dcd:	5b                   	pop    %ebx
 dce:	5e                   	pop    %esi
 dcf:	5f                   	pop    %edi
 dd0:	5d                   	pop    %ebp
 dd1:	c3                   	ret    
 dd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 dd8:	39 cf                	cmp    %ecx,%edi
 dda:	74 54                	je     e30 <malloc+0xf0>
        p->s.size -= nunits;
 ddc:	29 f9                	sub    %edi,%ecx
 dde:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 de1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 de4:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 de7:	89 15 d0 13 00 00    	mov    %edx,0x13d0
}
 ded:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 df0:	83 c0 08             	add    $0x8,%eax
}
 df3:	5b                   	pop    %ebx
 df4:	5e                   	pop    %esi
 df5:	5f                   	pop    %edi
 df6:	5d                   	pop    %ebp
 df7:	c3                   	ret    
 df8:	90                   	nop
 df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 e00:	c7 05 d0 13 00 00 d4 	movl   $0x13d4,0x13d0
 e07:	13 00 00 
 e0a:	c7 05 d4 13 00 00 d4 	movl   $0x13d4,0x13d4
 e11:	13 00 00 
    base.s.size = 0;
 e14:	b8 d4 13 00 00       	mov    $0x13d4,%eax
 e19:	c7 05 d8 13 00 00 00 	movl   $0x0,0x13d8
 e20:	00 00 00 
 e23:	e9 44 ff ff ff       	jmp    d6c <malloc+0x2c>
 e28:	90                   	nop
 e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 e30:	8b 08                	mov    (%eax),%ecx
 e32:	89 0a                	mov    %ecx,(%edx)
 e34:	eb b1                	jmp    de7 <malloc+0xa7>
