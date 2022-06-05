
_my_test_scheduler:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    return;
}

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
  11:	83 ec 24             	sub    $0x24,%esp
	struct workload *workloads;
    int i, j, k;
    
    workloads = malloc(sizeof(struct workload) * MAX_WORKLOAD_NUM);
  14:	6a 50                	push   $0x50
  16:	e8 e5 0b 00 00       	call   c00 <malloc>
  1b:	8d 70 08             	lea    0x8(%eax),%esi
  1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  21:	83 c4 10             	add    $0x10,%esp
  24:	c7 45 dc 09 00 00 00 	movl   $0x9,-0x24(%ebp)

    for (i = 1; i < MAX_WORKLOAD_NUM; i++) {
  2b:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        for (j = 0; j < MAX_WORKLOAD_NUM - i; j++) {
  38:	31 db                	xor    %ebx,%ebx
  3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  40:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  43:	90                   	nop
  44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            for (k = 0; k < i; k++) {
                workloads[k].func = test_mlfq;
  48:	c7 01 70 01 00 00    	movl   $0x170,(%ecx)
                workloads[k].arg = MLFQ_NONE;
  4e:	c7 41 04 00 00 00 00 	movl   $0x0,0x4(%ecx)
  55:	83 c1 08             	add    $0x8,%ecx
            for (k = 0; k < i; k++) {
  58:	39 f1                	cmp    %esi,%ecx
  5a:	75 ec                	jne    48 <main+0x48>
  5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  5f:	8d 3c 03             	lea    (%ebx,%eax,1),%edi
            }
            for (k = i; k < i + j; k++) {
  62:	39 f8                	cmp    %edi,%eax
  64:	7d 22                	jge    88 <main+0x88>
                workloads[k].func = test_stride;
                workloads[k].arg = 80 / j;
  66:	b8 50 00 00 00       	mov    $0x50,%eax
  6b:	99                   	cltd   
  6c:	f7 fb                	idiv   %ebx
  6e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  71:	8d 14 fa             	lea    (%edx,%edi,8),%edx
  74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                workloads[k].func = test_stride;
  78:	c7 01 00 01 00 00    	movl   $0x100,(%ecx)
                workloads[k].arg = 80 / j;
  7e:	89 41 04             	mov    %eax,0x4(%ecx)
  81:	83 c1 08             	add    $0x8,%ecx
            for (k = i; k < i + j; k++) {
  84:	39 d1                	cmp    %edx,%ecx
  86:	75 f0                	jne    78 <main+0x78>
            }

            printf(1, "+-----------------------------------------------------------\n");
  88:	83 ec 08             	sub    $0x8,%esp
  8b:	68 c8 0d 00 00       	push   $0xdc8
  90:	6a 01                	push   $0x1
  92:	e8 09 09 00 00       	call   9a0 <printf>
            printf(1, "<mlfq(%d) + stride(%d)>\n", i, j);
  97:	53                   	push   %ebx
  98:	ff 75 e0             	pushl  -0x20(%ebp)
        for (j = 0; j < MAX_WORKLOAD_NUM - i; j++) {
  9b:	83 c3 01             	add    $0x1,%ebx
            printf(1, "<mlfq(%d) + stride(%d)>\n", i, j);
  9e:	68 43 0d 00 00       	push   $0xd43
  a3:	6a 01                	push   $0x1
  a5:	e8 f6 08 00 00       	call   9a0 <printf>
            set_process(i + j, workloads);
  aa:	83 c4 18             	add    $0x18,%esp
  ad:	ff 75 e4             	pushl  -0x1c(%ebp)
  b0:	57                   	push   %edi
  b1:	e8 9a 02 00 00       	call   350 <set_process>
            printf(1, "+-----------------------------------------------------------\n\n");
  b6:	5a                   	pop    %edx
  b7:	59                   	pop    %ecx
  b8:	68 08 0e 00 00       	push   $0xe08
  bd:	6a 01                	push   $0x1
  bf:	e8 dc 08 00 00       	call   9a0 <printf>
        for (j = 0; j < MAX_WORKLOAD_NUM - i; j++) {
  c4:	83 c4 10             	add    $0x10,%esp
  c7:	39 5d dc             	cmp    %ebx,-0x24(%ebp)
  ca:	0f 85 70 ff ff ff    	jne    40 <main+0x40>
    for (i = 1; i < MAX_WORKLOAD_NUM; i++) {
  d0:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  d4:	83 c6 08             	add    $0x8,%esi
  d7:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
  db:	0f 85 57 ff ff ff    	jne    38 <main+0x38>
        }
    }
    printf(1, "\n");
  e1:	83 ec 08             	sub    $0x8,%esp
  e4:	68 10 0d 00 00       	push   $0xd10
  e9:	6a 01                	push   $0x1
  eb:	e8 b0 08 00 00       	call   9a0 <printf>

    free(workloads);
  f0:	58                   	pop    %eax
  f1:	ff 75 e4             	pushl  -0x1c(%ebp)
  f4:	e8 77 0a 00 00       	call   b70 <free>

	exit();
  f9:	e8 24 07 00 00       	call   822 <exit>
  fe:	66 90                	xchg   %ax,%ax

00000100 <test_stride>:
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	57                   	push   %edi
 104:	56                   	push   %esi
 105:	53                   	push   %ebx
 106:	83 ec 18             	sub    $0x18,%esp
	if (set_cpu_share(portion) != 0) {
 109:	ff 75 08             	pushl  0x8(%ebp)
{
 10c:	8b 75 0c             	mov    0xc(%ebp),%esi
	if (set_cpu_share(portion) != 0) {
 10f:	e8 be 07 00 00       	call   8d2 <set_cpu_share>
 114:	83 c4 10             	add    $0x10,%esp
 117:	85 c0                	test   %eax,%eax
 119:	75 35                	jne    150 <test_stride+0x50>
 11b:	89 c7                	mov    %eax,%edi
	start_tick = uptime();
 11d:	e8 98 07 00 00       	call   8ba <uptime>
 122:	89 c3                	mov    %eax,%ebx
 124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			curr_tick = uptime();
 128:	e8 8d 07 00 00       	call   8ba <uptime>
			if (curr_tick - start_tick > LIFETIME) {
 12d:	29 d8                	sub    %ebx,%eax
			cnt++;
 12f:	83 c7 01             	add    $0x1,%edi
			if (curr_tick - start_tick > LIFETIME) {
 132:	3d e8 03 00 00       	cmp    $0x3e8,%eax
 137:	7e ef                	jle    128 <test_stride+0x28>
    value[1] = portion;
 139:	8b 45 08             	mov    0x8(%ebp),%eax
    value[0] = STRIDE_SCHEDULER;
 13c:	c7 06 01 00 00 00    	movl   $0x1,(%esi)
    value[2] = cnt;
 142:	89 7e 08             	mov    %edi,0x8(%esi)
    value[1] = portion;
 145:	89 46 04             	mov    %eax,0x4(%esi)
}
 148:	8d 65 f4             	lea    -0xc(%ebp),%esp
 14b:	5b                   	pop    %ebx
 14c:	5e                   	pop    %esi
 14d:	5f                   	pop    %edi
 14e:	5d                   	pop    %ebp
 14f:	c3                   	ret    
		printf(1, "FAIL : set_cpu_share(%d)\n", portion);
 150:	83 ec 04             	sub    $0x4,%esp
 153:	ff 75 08             	pushl  0x8(%ebp)
	int cnt = 0;
 156:	31 ff                	xor    %edi,%edi
		printf(1, "FAIL : set_cpu_share(%d)\n", portion);
 158:	68 f8 0c 00 00       	push   $0xcf8
 15d:	6a 01                	push   $0x1
 15f:	e8 3c 08 00 00       	call   9a0 <printf>
        goto end;
 164:	83 c4 10             	add    $0x10,%esp
 167:	eb d0                	jmp    139 <test_stride+0x39>
 169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000170 <test_mlfq>:
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	57                   	push   %edi
 174:	56                   	push   %esi
 175:	53                   	push   %ebx
	int cnt = 0;
 176:	31 db                	xor    %ebx,%ebx
{
 178:	83 ec 1c             	sub    $0x1c,%esp
	start_tick = uptime();
 17b:	e8 3a 07 00 00       	call   8ba <uptime>
 180:	89 c7                	mov    %eax,%edi
			if (type == MLFQ_YIELD || type == MLFQ_LEVCNT_YIELD) {
 182:	8b 45 08             	mov    0x8(%ebp),%eax
 185:	8b 75 08             	mov    0x8(%ebp),%esi
 188:	83 e8 02             	sub    $0x2,%eax
 18b:	83 e6 fd             	and    $0xfffffffd,%esi
 18e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
			cnt++;
 198:	83 c3 01             	add    $0x1,%ebx
			if (type == MLFQ_LEVCNT || type == MLFQ_LEVCNT_YIELD ) {
 19b:	83 fe 01             	cmp    $0x1,%esi
 19e:	74 28                	je     1c8 <test_mlfq+0x58>
			curr_tick = uptime();
 1a0:	e8 15 07 00 00       	call   8ba <uptime>
			if (curr_tick - start_tick > LIFETIME) {
 1a5:	29 f8                	sub    %edi,%eax
 1a7:	3d e8 03 00 00       	cmp    $0x3e8,%eax
 1ac:	7f 2d                	jg     1db <test_mlfq+0x6b>
			if (type == MLFQ_YIELD || type == MLFQ_LEVCNT_YIELD) {
 1ae:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
 1b2:	77 e4                	ja     198 <test_mlfq+0x28>
				yield();
 1b4:	e8 09 07 00 00       	call   8c2 <yield>
			cnt++;
 1b9:	83 c3 01             	add    $0x1,%ebx
			if (type == MLFQ_LEVCNT || type == MLFQ_LEVCNT_YIELD ) {
 1bc:	83 fe 01             	cmp    $0x1,%esi
 1bf:	75 df                	jne    1a0 <test_mlfq+0x30>
 1c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
				curr_mlfq_level = getlev(); /* getlev : system call */
 1c8:	e8 fd 06 00 00       	call   8ca <getlev>
			curr_tick = uptime();
 1cd:	e8 e8 06 00 00       	call   8ba <uptime>
			if (curr_tick - start_tick > LIFETIME) {
 1d2:	29 f8                	sub    %edi,%eax
 1d4:	3d e8 03 00 00       	cmp    $0x3e8,%eax
 1d9:	7e d3                	jle    1ae <test_mlfq+0x3e>
    value[0] = MLFQ_SCHEDULER;
 1db:	8b 45 0c             	mov    0xc(%ebp),%eax
    value[1] = type;
 1de:	8b 55 08             	mov    0x8(%ebp),%edx
    value[0] = MLFQ_SCHEDULER;
 1e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    value[1] = type;
 1e7:	89 50 04             	mov    %edx,0x4(%eax)
    value[2] = cnt;
 1ea:	89 58 08             	mov    %ebx,0x8(%eax)
}
 1ed:	83 c4 1c             	add    $0x1c,%esp
 1f0:	5b                   	pop    %ebx
 1f1:	5e                   	pop    %esi
 1f2:	5f                   	pop    %edi
 1f3:	5d                   	pop    %ebp
 1f4:	c3                   	ret    
 1f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000200 <report>:
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	57                   	push   %edi
 204:	56                   	push   %esi
 205:	53                   	push   %ebx
 206:	83 ec 2c             	sub    $0x2c,%esp
 209:	8b 45 08             	mov    0x8(%ebp),%eax
    for (i = 0; i < n; i++) {
 20c:	85 c0                	test   %eax,%eax
 20e:	0f 8e 34 01 00 00    	jle    348 <report+0x148>
 214:	8b 75 0c             	mov    0xc(%ebp),%esi
    mlfq_share = 100;
 217:	c7 45 e0 64 00 00 00 	movl   $0x64,-0x20(%ebp)
    total_cnt = mlfq_cnt = 0;
 21e:	31 d2                	xor    %edx,%edx
 220:	8d 0c 86             	lea    (%esi,%eax,4),%ecx
 223:	31 c0                	xor    %eax,%eax
    for (i = 0; i < n; i++) {
 225:	89 f7                	mov    %esi,%edi
    total_cnt = mlfq_cnt = 0;
 227:	89 75 e4             	mov    %esi,-0x1c(%ebp)
 22a:	89 c6                	mov    %eax,%esi
 22c:	eb 0c                	jmp    23a <report+0x3a>
 22e:	66 90                	xchg   %ax,%ax
 230:	83 c7 04             	add    $0x4,%edi
            mlfq_cnt++;
 233:	83 c6 01             	add    $0x1,%esi
    for (i = 0; i < n; i++) {
 236:	39 f9                	cmp    %edi,%ecx
 238:	74 19                	je     253 <report+0x53>
        total_cnt += list[i][2];
 23a:	8b 07                	mov    (%edi),%eax
 23c:	03 50 08             	add    0x8(%eax),%edx
        if (list[i][0] == STRIDE_SCHEDULER) {
 23f:	83 38 01             	cmpl   $0x1,(%eax)
        total_cnt += list[i][2];
 242:	89 d3                	mov    %edx,%ebx
        if (list[i][0] == STRIDE_SCHEDULER) {
 244:	75 ea                	jne    230 <report+0x30>
 246:	83 c7 04             	add    $0x4,%edi
            mlfq_share -= list[i][1];
 249:	8b 40 04             	mov    0x4(%eax),%eax
 24c:	29 45 e0             	sub    %eax,-0x20(%ebp)
    for (i = 0; i < n; i++) {
 24f:	39 f9                	cmp    %edi,%ecx
 251:	75 e7                	jne    23a <report+0x3a>
            loss = (mlfq_share * 10 / mlfq_cnt) - real_share;
 253:	8b 45 e0             	mov    -0x20(%ebp),%eax
 256:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 259:	8b 75 e4             	mov    -0x1c(%ebp),%esi
        loss_exp = loss / 10;
 25c:	89 7d d8             	mov    %edi,-0x28(%ebp)
            loss = (mlfq_share * 10 / mlfq_cnt) - real_share;
 25f:	8d 04 80             	lea    (%eax,%eax,4),%eax
 262:	89 5d dc             	mov    %ebx,-0x24(%ebp)
 265:	01 c0                	add    %eax,%eax
        loss_exp = loss / 10;
 267:	89 f7                	mov    %esi,%edi
            loss = (mlfq_share * 10 / mlfq_cnt) - real_share;
 269:	89 45 d0             	mov    %eax,-0x30(%ebp)
 26c:	eb 5a                	jmp    2c8 <report+0xc8>
 26e:	66 90                	xchg   %ax,%ax
 270:	8b 45 d0             	mov    -0x30(%ebp),%eax
 273:	99                   	cltd   
 274:	f7 7d d4             	idivl  -0x2c(%ebp)
 277:	29 d8                	sub    %ebx,%eax
 279:	89 c3                	mov    %eax,%ebx
 27b:	c1 f8 1f             	sar    $0x1f,%eax
 27e:	31 c3                	xor    %eax,%ebx
 280:	29 c3                	sub    %eax,%ebx
        loss_exp = loss / 10;
 282:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
 287:	f7 e3                	mul    %ebx
 289:	c1 ea 03             	shr    $0x3,%edx
        loss_frac = loss % 10;
 28c:	8d 04 92             	lea    (%edx,%edx,4),%eax
 28f:	01 c0                	add    %eax,%eax
 291:	29 c3                	sub    %eax,%ebx
        	printf(1, "| MLFQ(%s:%d%%), real_share : %d.%d%%, loss : %d.%d\n",
 293:	83 fe 01             	cmp    $0x1,%esi
 296:	b8 12 0d 00 00       	mov    $0xd12,%eax
 29b:	be 1a 0d 00 00       	mov    $0xd1a,%esi
 2a0:	53                   	push   %ebx
 2a1:	52                   	push   %edx
 2a2:	0f 46 f0             	cmovbe %eax,%esi
 2a5:	ff 75 e4             	pushl  -0x1c(%ebp)
 2a8:	51                   	push   %ecx
 2a9:	ff 75 e0             	pushl  -0x20(%ebp)
 2ac:	56                   	push   %esi
 2ad:	83 c7 04             	add    $0x4,%edi
 2b0:	68 90 0d 00 00       	push   $0xd90
 2b5:	6a 01                	push   $0x1
 2b7:	e8 e4 06 00 00       	call   9a0 <printf>
 2bc:	83 c4 20             	add    $0x20,%esp
    for (i = 0; i < n; i++) {
 2bf:	39 7d d8             	cmp    %edi,-0x28(%ebp)
 2c2:	0f 84 80 00 00 00    	je     348 <report+0x148>
        real_share = list[i][2] * 1000 / total_cnt;
 2c8:	8b 07                	mov    (%edi),%eax
 2ca:	69 40 08 e8 03 00 00 	imul   $0x3e8,0x8(%eax),%eax
 2d1:	99                   	cltd   
 2d2:	f7 7d dc             	idivl  -0x24(%ebp)
 2d5:	89 c3                	mov    %eax,%ebx
 2d7:	8b 07                	mov    (%edi),%eax
 2d9:	8b 70 04             	mov    0x4(%eax),%esi
 2dc:	b8 67 66 66 66       	mov    $0x66666667,%eax
 2e1:	f7 eb                	imul   %ebx
 2e3:	89 d8                	mov    %ebx,%eax
 2e5:	c1 f8 1f             	sar    $0x1f,%eax
 2e8:	c1 fa 02             	sar    $0x2,%edx
 2eb:	89 d1                	mov    %edx,%ecx
 2ed:	89 da                	mov    %ebx,%edx
 2ef:	29 c1                	sub    %eax,%ecx
 2f1:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
 2f4:	01 c0                	add    %eax,%eax
 2f6:	29 c2                	sub    %eax,%edx
        if (list[i][0] == STRIDE_SCHEDULER) {
 2f8:	8b 07                	mov    (%edi),%eax
 2fa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 2fd:	83 38 01             	cmpl   $0x1,(%eax)
 300:	0f 85 6a ff ff ff    	jne    270 <report+0x70>
            loss = list[i][1] * 10 - real_share;
 306:	8d 04 b6             	lea    (%esi,%esi,4),%eax
        	printf(1, "| STRIDE(%d%%), real_share : %d.%d%%, loss : %d.%d\n", list[i][1], exp, frac, loss_exp, loss_frac);
 309:	83 ec 04             	sub    $0x4,%esp
 30c:	83 c7 04             	add    $0x4,%edi
            loss = list[i][1] * 10 - real_share;
 30f:	01 c0                	add    %eax,%eax
 311:	29 d8                	sub    %ebx,%eax
 313:	89 c3                	mov    %eax,%ebx
 315:	c1 f8 1f             	sar    $0x1f,%eax
 318:	31 c3                	xor    %eax,%ebx
 31a:	29 c3                	sub    %eax,%ebx
        loss_frac = loss % 10;
 31c:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
 321:	f7 e3                	mul    %ebx
 323:	c1 ea 03             	shr    $0x3,%edx
 326:	8d 04 92             	lea    (%edx,%edx,4),%eax
 329:	01 c0                	add    %eax,%eax
 32b:	29 c3                	sub    %eax,%ebx
        	printf(1, "| STRIDE(%d%%), real_share : %d.%d%%, loss : %d.%d\n", list[i][1], exp, frac, loss_exp, loss_frac);
 32d:	53                   	push   %ebx
 32e:	52                   	push   %edx
 32f:	ff 75 e4             	pushl  -0x1c(%ebp)
 332:	51                   	push   %ecx
 333:	56                   	push   %esi
 334:	68 5c 0d 00 00       	push   $0xd5c
 339:	6a 01                	push   $0x1
 33b:	e8 60 06 00 00       	call   9a0 <printf>
 340:	83 c4 20             	add    $0x20,%esp
    for (i = 0; i < n; i++) {
 343:	39 7d d8             	cmp    %edi,-0x28(%ebp)
 346:	75 80                	jne    2c8 <report+0xc8>
}
 348:	8d 65 f4             	lea    -0xc(%ebp),%esp
 34b:	5b                   	pop    %ebx
 34c:	5e                   	pop    %esi
 34d:	5f                   	pop    %edi
 34e:	5d                   	pop    %ebp
 34f:	c3                   	ret    

00000350 <set_process>:
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	57                   	push   %edi
 354:	56                   	push   %esi
 355:	53                   	push   %ebx
    if (pipe(fd) == -1) {
 356:	8d 85 e0 fb ff ff    	lea    -0x420(%ebp),%eax
{
 35c:	81 ec 38 04 00 00    	sub    $0x438,%esp
 362:	8b 75 08             	mov    0x8(%ebp),%esi
    if (pipe(fd) == -1) {
 365:	50                   	push   %eax
 366:	e8 c7 04 00 00       	call   832 <pipe>
 36b:	83 c4 10             	add    $0x10,%esp
 36e:	83 f8 ff             	cmp    $0xffffffff,%eax
 371:	0f 84 3c 02 00 00    	je     5b3 <set_process+0x263>
	for (i = 0; i < n; i++) {
 377:	31 db                	xor    %ebx,%ebx
 379:	85 f6                	test   %esi,%esi
 37b:	0f 8e d7 01 00 00    	jle    558 <set_process+0x208>
		pid = fork();
 381:	e8 94 04 00 00       	call   81a <fork>
		if (pid > 0) {
 386:	83 f8 00             	cmp    $0x0,%eax
 389:	7f 4d                	jg     3d8 <set_process+0x88>
		} else if (pid == 0) {
 38b:	0f 85 af 01 00 00    	jne    540 <set_process+0x1f0>
			void (*func)(int, int *) = workloads[i].func;
 391:	8b 45 0c             	mov    0xc(%ebp),%eax
			func(arg, value);
 394:	8d 95 e8 fb ff ff    	lea    -0x418(%ebp),%edx
 39a:	83 ec 08             	sub    $0x8,%esp
 39d:	52                   	push   %edx
			void (*func)(int, int *) = workloads[i].func;
 39e:	8d 04 d8             	lea    (%eax,%ebx,8),%eax
			func(arg, value);
 3a1:	ff 70 04             	pushl  0x4(%eax)
 3a4:	ff 10                	call   *(%eax)
            printf(fd[WRITE], "%d,%d,%d\n", value[0], value[1], value[2]);
 3a6:	58                   	pop    %eax
 3a7:	ff b5 f0 fb ff ff    	pushl  -0x410(%ebp)
 3ad:	ff b5 ec fb ff ff    	pushl  -0x414(%ebp)
 3b3:	ff b5 e8 fb ff ff    	pushl  -0x418(%ebp)
 3b9:	68 2c 0d 00 00       	push   $0xd2c
 3be:	ff b5 e4 fb ff ff    	pushl  -0x41c(%ebp)
 3c4:	e8 d7 05 00 00       	call   9a0 <printf>
			exit();
 3c9:	83 c4 20             	add    $0x20,%esp
 3cc:	e8 51 04 00 00       	call   822 <exit>
 3d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	for (i = 0; i < n; i++) {
 3d8:	83 c3 01             	add    $0x1,%ebx
 3db:	39 de                	cmp    %ebx,%esi
 3dd:	75 a2                	jne    381 <set_process+0x31>
	for (i = 0; i < n; i++) {
 3df:	31 f6                	xor    %esi,%esi
 3e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3e8:	83 c6 01             	add    $0x1,%esi
		wait();
 3eb:	e8 3a 04 00 00       	call   82a <wait>
	for (i = 0; i < n; i++) {
 3f0:	39 de                	cmp    %ebx,%esi
 3f2:	75 f4                	jne    3e8 <set_process+0x98>
    list = malloc(sizeof(int *) * n);
 3f4:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
 3fb:	83 ec 0c             	sub    $0xc,%esp
 3fe:	57                   	push   %edi
 3ff:	e8 fc 07 00 00       	call   c00 <malloc>
 404:	89 9d cc fb ff ff    	mov    %ebx,-0x434(%ebp)
 40a:	89 85 d0 fb ff ff    	mov    %eax,-0x430(%ebp)
 410:	89 c6                	mov    %eax,%esi
 412:	01 c7                	add    %eax,%edi
 414:	83 c4 10             	add    $0x10,%esp
 417:	89 c3                	mov    %eax,%ebx
 419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        list[i] = malloc(sizeof(int) * 3);
 420:	83 ec 0c             	sub    $0xc,%esp
 423:	83 c3 04             	add    $0x4,%ebx
 426:	6a 0c                	push   $0xc
 428:	e8 d3 07 00 00       	call   c00 <malloc>
 42d:	89 43 fc             	mov    %eax,-0x4(%ebx)
    for (i = 0; i < n; i++) {
 430:	83 c4 10             	add    $0x10,%esp
 433:	39 fb                	cmp    %edi,%ebx
 435:	75 e9                	jne    420 <set_process+0xd0>
    read(fd[READ], buf, MAX_BUF);
 437:	8d bd e8 fb ff ff    	lea    -0x418(%ebp),%edi
 43d:	83 ec 04             	sub    $0x4,%esp
 440:	89 9d d4 fb ff ff    	mov    %ebx,-0x42c(%ebp)
 446:	8b 9d cc fb ff ff    	mov    -0x434(%ebp),%ebx
 44c:	68 00 04 00 00       	push   $0x400
 451:	57                   	push   %edi
 452:	ff b5 e0 fb ff ff    	pushl  -0x420(%ebp)
 458:	e8 dd 03 00 00       	call   83a <read>
 45d:	89 9d cc fb ff ff    	mov    %ebx,-0x434(%ebp)
 463:	83 c4 10             	add    $0x10,%esp
 466:	89 fb                	mov    %edi,%ebx
 468:	90                   	nop
 469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        list[i][0] = atoi(tmp);
 470:	8b 3e                	mov    (%esi),%edi
 472:	83 ec 0c             	sub    $0xc,%esp
 475:	53                   	push   %ebx
 476:	e8 35 03 00 00       	call   7b0 <atoi>
        while (*(tmp++) != ',');
 47b:	83 c4 10             	add    $0x10,%esp
        list[i][0] = atoi(tmp);
 47e:	89 07                	mov    %eax,(%edi)
        while (*(tmp++) != ',');
 480:	83 c3 01             	add    $0x1,%ebx
 483:	80 7b ff 2c          	cmpb   $0x2c,-0x1(%ebx)
 487:	75 f7                	jne    480 <set_process+0x130>
        list[i][1] = atoi(tmp);
 489:	8b 3e                	mov    (%esi),%edi
 48b:	83 ec 0c             	sub    $0xc,%esp
 48e:	53                   	push   %ebx
 48f:	e8 1c 03 00 00       	call   7b0 <atoi>
        while (*(tmp++) != ',');
 494:	83 c4 10             	add    $0x10,%esp
        list[i][1] = atoi(tmp);
 497:	89 47 04             	mov    %eax,0x4(%edi)
 49a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        while (*(tmp++) != ',');
 4a0:	83 c3 01             	add    $0x1,%ebx
 4a3:	80 7b ff 2c          	cmpb   $0x2c,-0x1(%ebx)
 4a7:	75 f7                	jne    4a0 <set_process+0x150>
        list[i][2] = atoi(tmp);
 4a9:	8b 3e                	mov    (%esi),%edi
 4ab:	83 ec 0c             	sub    $0xc,%esp
 4ae:	53                   	push   %ebx
 4af:	e8 fc 02 00 00       	call   7b0 <atoi>
        while (*(tmp++) != '\n');
 4b4:	83 c4 10             	add    $0x10,%esp
        list[i][2] = atoi(tmp);
 4b7:	89 47 08             	mov    %eax,0x8(%edi)
 4ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        while (*(tmp++) != '\n');
 4c0:	83 c3 01             	add    $0x1,%ebx
 4c3:	80 7b ff 0a          	cmpb   $0xa,-0x1(%ebx)
 4c7:	75 f7                	jne    4c0 <set_process+0x170>
 4c9:	83 c6 04             	add    $0x4,%esi
    for (i = 0; i < n; i++) {
 4cc:	39 b5 d4 fb ff ff    	cmp    %esi,-0x42c(%ebp)
 4d2:	75 9c                	jne    470 <set_process+0x120>
 4d4:	8b 9d cc fb ff ff    	mov    -0x434(%ebp),%ebx
    report(n, list);
 4da:	8b bd d0 fb ff ff    	mov    -0x430(%ebp),%edi
 4e0:	83 ec 08             	sub    $0x8,%esp
    close(fd[WRITE]);
 4e3:	31 f6                	xor    %esi,%esi
    report(n, list);
 4e5:	57                   	push   %edi
 4e6:	53                   	push   %ebx
 4e7:	e8 14 fd ff ff       	call   200 <report>
    close(fd[READ]);
 4ec:	58                   	pop    %eax
 4ed:	ff b5 e0 fb ff ff    	pushl  -0x420(%ebp)
 4f3:	e8 52 03 00 00       	call   84a <close>
    close(fd[WRITE]);
 4f8:	5a                   	pop    %edx
 4f9:	ff b5 e4 fb ff ff    	pushl  -0x41c(%ebp)
 4ff:	e8 46 03 00 00       	call   84a <close>
 504:	83 c4 10             	add    $0x10,%esp
 507:	89 f6                	mov    %esi,%esi
 509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        free(list[i]);
 510:	83 ec 0c             	sub    $0xc,%esp
 513:	ff 34 b7             	pushl  (%edi,%esi,4)
    for (i = 0; i < n; i++) {
 516:	83 c6 01             	add    $0x1,%esi
        free(list[i]);
 519:	e8 52 06 00 00       	call   b70 <free>
    for (i = 0; i < n; i++) {
 51e:	83 c4 10             	add    $0x10,%esp
 521:	39 de                	cmp    %ebx,%esi
 523:	7c eb                	jl     510 <set_process+0x1c0>
    free(list);
 525:	83 ec 0c             	sub    $0xc,%esp
 528:	ff b5 d0 fb ff ff    	pushl  -0x430(%ebp)
 52e:	e8 3d 06 00 00       	call   b70 <free>
}
 533:	8d 65 f4             	lea    -0xc(%ebp),%esp
 536:	5b                   	pop    %ebx
 537:	5e                   	pop    %esi
 538:	5f                   	pop    %edi
 539:	5d                   	pop    %ebp
 53a:	c3                   	ret    
 53b:	90                   	nop
 53c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			printf(1, "FAIL : fork\n");
 540:	83 ec 08             	sub    $0x8,%esp
 543:	68 36 0d 00 00       	push   $0xd36
 548:	6a 01                	push   $0x1
 54a:	e8 51 04 00 00       	call   9a0 <printf>
			exit();
 54f:	e8 ce 02 00 00       	call   822 <exit>
 554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    list = malloc(sizeof(int *) * n);
 558:	8d 04 b5 00 00 00 00 	lea    0x0(,%esi,4),%eax
 55f:	83 ec 0c             	sub    $0xc,%esp
 562:	50                   	push   %eax
 563:	e8 98 06 00 00       	call   c00 <malloc>
 568:	89 c7                	mov    %eax,%edi
 56a:	89 85 d0 fb ff ff    	mov    %eax,-0x430(%ebp)
    read(fd[READ], buf, MAX_BUF);
 570:	8d 85 e8 fb ff ff    	lea    -0x418(%ebp),%eax
 576:	83 c4 0c             	add    $0xc,%esp
 579:	68 00 04 00 00       	push   $0x400
 57e:	50                   	push   %eax
 57f:	ff b5 e0 fb ff ff    	pushl  -0x420(%ebp)
 585:	e8 b0 02 00 00       	call   83a <read>
    report(n, list);
 58a:	59                   	pop    %ecx
 58b:	5b                   	pop    %ebx
 58c:	57                   	push   %edi
 58d:	56                   	push   %esi
 58e:	e8 6d fc ff ff       	call   200 <report>
    close(fd[READ]);
 593:	5e                   	pop    %esi
 594:	ff b5 e0 fb ff ff    	pushl  -0x420(%ebp)
 59a:	e8 ab 02 00 00       	call   84a <close>
    close(fd[WRITE]);
 59f:	5f                   	pop    %edi
 5a0:	ff b5 e4 fb ff ff    	pushl  -0x41c(%ebp)
 5a6:	e8 9f 02 00 00       	call   84a <close>
 5ab:	83 c4 10             	add    $0x10,%esp
 5ae:	e9 72 ff ff ff       	jmp    525 <set_process+0x1d5>
        printf(1, "FAIL: pipe\n");
 5b3:	50                   	push   %eax
 5b4:	50                   	push   %eax
 5b5:	68 20 0d 00 00       	push   $0xd20
 5ba:	6a 01                	push   $0x1
 5bc:	e8 df 03 00 00       	call   9a0 <printf>
        exit();
 5c1:	e8 5c 02 00 00       	call   822 <exit>
 5c6:	66 90                	xchg   %ax,%ax
 5c8:	66 90                	xchg   %ax,%ax
 5ca:	66 90                	xchg   %ax,%ax
 5cc:	66 90                	xchg   %ax,%ax
 5ce:	66 90                	xchg   %ax,%ax

000005d0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 5d0:	55                   	push   %ebp
 5d1:	89 e5                	mov    %esp,%ebp
 5d3:	53                   	push   %ebx
 5d4:	8b 45 08             	mov    0x8(%ebp),%eax
 5d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 5da:	89 c2                	mov    %eax,%edx
 5dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5e0:	83 c1 01             	add    $0x1,%ecx
 5e3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 5e7:	83 c2 01             	add    $0x1,%edx
 5ea:	84 db                	test   %bl,%bl
 5ec:	88 5a ff             	mov    %bl,-0x1(%edx)
 5ef:	75 ef                	jne    5e0 <strcpy+0x10>
    ;
  return os;
}
 5f1:	5b                   	pop    %ebx
 5f2:	5d                   	pop    %ebp
 5f3:	c3                   	ret    
 5f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 5fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000600 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 600:	55                   	push   %ebp
 601:	89 e5                	mov    %esp,%ebp
 603:	53                   	push   %ebx
 604:	8b 55 08             	mov    0x8(%ebp),%edx
 607:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 60a:	0f b6 02             	movzbl (%edx),%eax
 60d:	0f b6 19             	movzbl (%ecx),%ebx
 610:	84 c0                	test   %al,%al
 612:	75 1c                	jne    630 <strcmp+0x30>
 614:	eb 2a                	jmp    640 <strcmp+0x40>
 616:	8d 76 00             	lea    0x0(%esi),%esi
 619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 620:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 623:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 626:	83 c1 01             	add    $0x1,%ecx
 629:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 62c:	84 c0                	test   %al,%al
 62e:	74 10                	je     640 <strcmp+0x40>
 630:	38 d8                	cmp    %bl,%al
 632:	74 ec                	je     620 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 634:	29 d8                	sub    %ebx,%eax
}
 636:	5b                   	pop    %ebx
 637:	5d                   	pop    %ebp
 638:	c3                   	ret    
 639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 640:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 642:	29 d8                	sub    %ebx,%eax
}
 644:	5b                   	pop    %ebx
 645:	5d                   	pop    %ebp
 646:	c3                   	ret    
 647:	89 f6                	mov    %esi,%esi
 649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000650 <strlen>:

uint
strlen(const char *s)
{
 650:	55                   	push   %ebp
 651:	89 e5                	mov    %esp,%ebp
 653:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 656:	80 39 00             	cmpb   $0x0,(%ecx)
 659:	74 15                	je     670 <strlen+0x20>
 65b:	31 d2                	xor    %edx,%edx
 65d:	8d 76 00             	lea    0x0(%esi),%esi
 660:	83 c2 01             	add    $0x1,%edx
 663:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 667:	89 d0                	mov    %edx,%eax
 669:	75 f5                	jne    660 <strlen+0x10>
    ;
  return n;
}
 66b:	5d                   	pop    %ebp
 66c:	c3                   	ret    
 66d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 670:	31 c0                	xor    %eax,%eax
}
 672:	5d                   	pop    %ebp
 673:	c3                   	ret    
 674:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 67a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000680 <memset>:

void*
memset(void *dst, int c, uint n)
{
 680:	55                   	push   %ebp
 681:	89 e5                	mov    %esp,%ebp
 683:	57                   	push   %edi
 684:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 687:	8b 4d 10             	mov    0x10(%ebp),%ecx
 68a:	8b 45 0c             	mov    0xc(%ebp),%eax
 68d:	89 d7                	mov    %edx,%edi
 68f:	fc                   	cld    
 690:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 692:	89 d0                	mov    %edx,%eax
 694:	5f                   	pop    %edi
 695:	5d                   	pop    %ebp
 696:	c3                   	ret    
 697:	89 f6                	mov    %esi,%esi
 699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000006a0 <strchr>:

char*
strchr(const char *s, char c)
{
 6a0:	55                   	push   %ebp
 6a1:	89 e5                	mov    %esp,%ebp
 6a3:	53                   	push   %ebx
 6a4:	8b 45 08             	mov    0x8(%ebp),%eax
 6a7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 6aa:	0f b6 10             	movzbl (%eax),%edx
 6ad:	84 d2                	test   %dl,%dl
 6af:	74 1d                	je     6ce <strchr+0x2e>
    if(*s == c)
 6b1:	38 d3                	cmp    %dl,%bl
 6b3:	89 d9                	mov    %ebx,%ecx
 6b5:	75 0d                	jne    6c4 <strchr+0x24>
 6b7:	eb 17                	jmp    6d0 <strchr+0x30>
 6b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6c0:	38 ca                	cmp    %cl,%dl
 6c2:	74 0c                	je     6d0 <strchr+0x30>
  for(; *s; s++)
 6c4:	83 c0 01             	add    $0x1,%eax
 6c7:	0f b6 10             	movzbl (%eax),%edx
 6ca:	84 d2                	test   %dl,%dl
 6cc:	75 f2                	jne    6c0 <strchr+0x20>
      return (char*)s;
  return 0;
 6ce:	31 c0                	xor    %eax,%eax
}
 6d0:	5b                   	pop    %ebx
 6d1:	5d                   	pop    %ebp
 6d2:	c3                   	ret    
 6d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 6d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000006e0 <gets>:

char*
gets(char *buf, int max)
{
 6e0:	55                   	push   %ebp
 6e1:	89 e5                	mov    %esp,%ebp
 6e3:	57                   	push   %edi
 6e4:	56                   	push   %esi
 6e5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 6e6:	31 f6                	xor    %esi,%esi
 6e8:	89 f3                	mov    %esi,%ebx
{
 6ea:	83 ec 1c             	sub    $0x1c,%esp
 6ed:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 6f0:	eb 2f                	jmp    721 <gets+0x41>
 6f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 6f8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 6fb:	83 ec 04             	sub    $0x4,%esp
 6fe:	6a 01                	push   $0x1
 700:	50                   	push   %eax
 701:	6a 00                	push   $0x0
 703:	e8 32 01 00 00       	call   83a <read>
    if(cc < 1)
 708:	83 c4 10             	add    $0x10,%esp
 70b:	85 c0                	test   %eax,%eax
 70d:	7e 1c                	jle    72b <gets+0x4b>
      break;
    buf[i++] = c;
 70f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 713:	83 c7 01             	add    $0x1,%edi
 716:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 719:	3c 0a                	cmp    $0xa,%al
 71b:	74 23                	je     740 <gets+0x60>
 71d:	3c 0d                	cmp    $0xd,%al
 71f:	74 1f                	je     740 <gets+0x60>
  for(i=0; i+1 < max; ){
 721:	83 c3 01             	add    $0x1,%ebx
 724:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 727:	89 fe                	mov    %edi,%esi
 729:	7c cd                	jl     6f8 <gets+0x18>
 72b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 72d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 730:	c6 03 00             	movb   $0x0,(%ebx)
}
 733:	8d 65 f4             	lea    -0xc(%ebp),%esp
 736:	5b                   	pop    %ebx
 737:	5e                   	pop    %esi
 738:	5f                   	pop    %edi
 739:	5d                   	pop    %ebp
 73a:	c3                   	ret    
 73b:	90                   	nop
 73c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 740:	8b 75 08             	mov    0x8(%ebp),%esi
 743:	8b 45 08             	mov    0x8(%ebp),%eax
 746:	01 de                	add    %ebx,%esi
 748:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 74a:	c6 03 00             	movb   $0x0,(%ebx)
}
 74d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 750:	5b                   	pop    %ebx
 751:	5e                   	pop    %esi
 752:	5f                   	pop    %edi
 753:	5d                   	pop    %ebp
 754:	c3                   	ret    
 755:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000760 <stat>:

int
stat(const char *n, struct stat *st)
{
 760:	55                   	push   %ebp
 761:	89 e5                	mov    %esp,%ebp
 763:	56                   	push   %esi
 764:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 765:	83 ec 08             	sub    $0x8,%esp
 768:	6a 00                	push   $0x0
 76a:	ff 75 08             	pushl  0x8(%ebp)
 76d:	e8 f0 00 00 00       	call   862 <open>
  if(fd < 0)
 772:	83 c4 10             	add    $0x10,%esp
 775:	85 c0                	test   %eax,%eax
 777:	78 27                	js     7a0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 779:	83 ec 08             	sub    $0x8,%esp
 77c:	ff 75 0c             	pushl  0xc(%ebp)
 77f:	89 c3                	mov    %eax,%ebx
 781:	50                   	push   %eax
 782:	e8 f3 00 00 00       	call   87a <fstat>
  close(fd);
 787:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 78a:	89 c6                	mov    %eax,%esi
  close(fd);
 78c:	e8 b9 00 00 00       	call   84a <close>
  return r;
 791:	83 c4 10             	add    $0x10,%esp
}
 794:	8d 65 f8             	lea    -0x8(%ebp),%esp
 797:	89 f0                	mov    %esi,%eax
 799:	5b                   	pop    %ebx
 79a:	5e                   	pop    %esi
 79b:	5d                   	pop    %ebp
 79c:	c3                   	ret    
 79d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 7a0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 7a5:	eb ed                	jmp    794 <stat+0x34>
 7a7:	89 f6                	mov    %esi,%esi
 7a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000007b0 <atoi>:

int
atoi(const char *s)
{
 7b0:	55                   	push   %ebp
 7b1:	89 e5                	mov    %esp,%ebp
 7b3:	53                   	push   %ebx
 7b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 7b7:	0f be 11             	movsbl (%ecx),%edx
 7ba:	8d 42 d0             	lea    -0x30(%edx),%eax
 7bd:	3c 09                	cmp    $0x9,%al
  n = 0;
 7bf:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 7c4:	77 1f                	ja     7e5 <atoi+0x35>
 7c6:	8d 76 00             	lea    0x0(%esi),%esi
 7c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 7d0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 7d3:	83 c1 01             	add    $0x1,%ecx
 7d6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 7da:	0f be 11             	movsbl (%ecx),%edx
 7dd:	8d 5a d0             	lea    -0x30(%edx),%ebx
 7e0:	80 fb 09             	cmp    $0x9,%bl
 7e3:	76 eb                	jbe    7d0 <atoi+0x20>
  return n;
}
 7e5:	5b                   	pop    %ebx
 7e6:	5d                   	pop    %ebp
 7e7:	c3                   	ret    
 7e8:	90                   	nop
 7e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000007f0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 7f0:	55                   	push   %ebp
 7f1:	89 e5                	mov    %esp,%ebp
 7f3:	56                   	push   %esi
 7f4:	53                   	push   %ebx
 7f5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 7f8:	8b 45 08             	mov    0x8(%ebp),%eax
 7fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 7fe:	85 db                	test   %ebx,%ebx
 800:	7e 14                	jle    816 <memmove+0x26>
 802:	31 d2                	xor    %edx,%edx
 804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 808:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 80c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 80f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 812:	39 d3                	cmp    %edx,%ebx
 814:	75 f2                	jne    808 <memmove+0x18>
  return vdst;
}
 816:	5b                   	pop    %ebx
 817:	5e                   	pop    %esi
 818:	5d                   	pop    %ebp
 819:	c3                   	ret    

0000081a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 81a:	b8 01 00 00 00       	mov    $0x1,%eax
 81f:	cd 40                	int    $0x40
 821:	c3                   	ret    

00000822 <exit>:
SYSCALL(exit)
 822:	b8 02 00 00 00       	mov    $0x2,%eax
 827:	cd 40                	int    $0x40
 829:	c3                   	ret    

0000082a <wait>:
SYSCALL(wait)
 82a:	b8 03 00 00 00       	mov    $0x3,%eax
 82f:	cd 40                	int    $0x40
 831:	c3                   	ret    

00000832 <pipe>:
SYSCALL(pipe)
 832:	b8 04 00 00 00       	mov    $0x4,%eax
 837:	cd 40                	int    $0x40
 839:	c3                   	ret    

0000083a <read>:
SYSCALL(read)
 83a:	b8 05 00 00 00       	mov    $0x5,%eax
 83f:	cd 40                	int    $0x40
 841:	c3                   	ret    

00000842 <write>:
SYSCALL(write)
 842:	b8 10 00 00 00       	mov    $0x10,%eax
 847:	cd 40                	int    $0x40
 849:	c3                   	ret    

0000084a <close>:
SYSCALL(close)
 84a:	b8 15 00 00 00       	mov    $0x15,%eax
 84f:	cd 40                	int    $0x40
 851:	c3                   	ret    

00000852 <kill>:
SYSCALL(kill)
 852:	b8 06 00 00 00       	mov    $0x6,%eax
 857:	cd 40                	int    $0x40
 859:	c3                   	ret    

0000085a <exec>:
SYSCALL(exec)
 85a:	b8 07 00 00 00       	mov    $0x7,%eax
 85f:	cd 40                	int    $0x40
 861:	c3                   	ret    

00000862 <open>:
SYSCALL(open)
 862:	b8 0f 00 00 00       	mov    $0xf,%eax
 867:	cd 40                	int    $0x40
 869:	c3                   	ret    

0000086a <mknod>:
SYSCALL(mknod)
 86a:	b8 11 00 00 00       	mov    $0x11,%eax
 86f:	cd 40                	int    $0x40
 871:	c3                   	ret    

00000872 <unlink>:
SYSCALL(unlink)
 872:	b8 12 00 00 00       	mov    $0x12,%eax
 877:	cd 40                	int    $0x40
 879:	c3                   	ret    

0000087a <fstat>:
SYSCALL(fstat)
 87a:	b8 08 00 00 00       	mov    $0x8,%eax
 87f:	cd 40                	int    $0x40
 881:	c3                   	ret    

00000882 <link>:
SYSCALL(link)
 882:	b8 13 00 00 00       	mov    $0x13,%eax
 887:	cd 40                	int    $0x40
 889:	c3                   	ret    

0000088a <mkdir>:
SYSCALL(mkdir)
 88a:	b8 14 00 00 00       	mov    $0x14,%eax
 88f:	cd 40                	int    $0x40
 891:	c3                   	ret    

00000892 <chdir>:
SYSCALL(chdir)
 892:	b8 09 00 00 00       	mov    $0x9,%eax
 897:	cd 40                	int    $0x40
 899:	c3                   	ret    

0000089a <dup>:
SYSCALL(dup)
 89a:	b8 0a 00 00 00       	mov    $0xa,%eax
 89f:	cd 40                	int    $0x40
 8a1:	c3                   	ret    

000008a2 <getpid>:
SYSCALL(getpid)
 8a2:	b8 0b 00 00 00       	mov    $0xb,%eax
 8a7:	cd 40                	int    $0x40
 8a9:	c3                   	ret    

000008aa <sbrk>:
SYSCALL(sbrk)
 8aa:	b8 0c 00 00 00       	mov    $0xc,%eax
 8af:	cd 40                	int    $0x40
 8b1:	c3                   	ret    

000008b2 <sleep>:
SYSCALL(sleep)
 8b2:	b8 0d 00 00 00       	mov    $0xd,%eax
 8b7:	cd 40                	int    $0x40
 8b9:	c3                   	ret    

000008ba <uptime>:
SYSCALL(uptime)
 8ba:	b8 0e 00 00 00       	mov    $0xe,%eax
 8bf:	cd 40                	int    $0x40
 8c1:	c3                   	ret    

000008c2 <yield>:
SYSCALL(yield)
 8c2:	b8 16 00 00 00       	mov    $0x16,%eax
 8c7:	cd 40                	int    $0x40
 8c9:	c3                   	ret    

000008ca <getlev>:
SYSCALL(getlev)
 8ca:	b8 17 00 00 00       	mov    $0x17,%eax
 8cf:	cd 40                	int    $0x40
 8d1:	c3                   	ret    

000008d2 <set_cpu_share>:
SYSCALL(set_cpu_share)
 8d2:	b8 18 00 00 00       	mov    $0x18,%eax
 8d7:	cd 40                	int    $0x40
 8d9:	c3                   	ret    

000008da <thread_create>:
SYSCALL(thread_create)
 8da:	b8 19 00 00 00       	mov    $0x19,%eax
 8df:	cd 40                	int    $0x40
 8e1:	c3                   	ret    

000008e2 <thread_exit>:
SYSCALL(thread_exit)
 8e2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 8e7:	cd 40                	int    $0x40
 8e9:	c3                   	ret    

000008ea <thread_join>:
SYSCALL(thread_join)
 8ea:	b8 1b 00 00 00       	mov    $0x1b,%eax
 8ef:	cd 40                	int    $0x40
 8f1:	c3                   	ret    
 8f2:	66 90                	xchg   %ax,%ax
 8f4:	66 90                	xchg   %ax,%ax
 8f6:	66 90                	xchg   %ax,%ax
 8f8:	66 90                	xchg   %ax,%ax
 8fa:	66 90                	xchg   %ax,%ax
 8fc:	66 90                	xchg   %ax,%ax
 8fe:	66 90                	xchg   %ax,%ax

00000900 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 900:	55                   	push   %ebp
 901:	89 e5                	mov    %esp,%ebp
 903:	57                   	push   %edi
 904:	56                   	push   %esi
 905:	53                   	push   %ebx
 906:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 909:	85 d2                	test   %edx,%edx
{
 90b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 90e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 910:	79 76                	jns    988 <printint+0x88>
 912:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 916:	74 70                	je     988 <printint+0x88>
    x = -xx;
 918:	f7 d8                	neg    %eax
    neg = 1;
 91a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 921:	31 f6                	xor    %esi,%esi
 923:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 926:	eb 0a                	jmp    932 <printint+0x32>
 928:	90                   	nop
 929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 930:	89 fe                	mov    %edi,%esi
 932:	31 d2                	xor    %edx,%edx
 934:	8d 7e 01             	lea    0x1(%esi),%edi
 937:	f7 f1                	div    %ecx
 939:	0f b6 92 50 0e 00 00 	movzbl 0xe50(%edx),%edx
  }while((x /= base) != 0);
 940:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 942:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 945:	75 e9                	jne    930 <printint+0x30>
  if(neg)
 947:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 94a:	85 c0                	test   %eax,%eax
 94c:	74 08                	je     956 <printint+0x56>
    buf[i++] = '-';
 94e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 953:	8d 7e 02             	lea    0x2(%esi),%edi
 956:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 95a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 95d:	8d 76 00             	lea    0x0(%esi),%esi
 960:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 963:	83 ec 04             	sub    $0x4,%esp
 966:	83 ee 01             	sub    $0x1,%esi
 969:	6a 01                	push   $0x1
 96b:	53                   	push   %ebx
 96c:	57                   	push   %edi
 96d:	88 45 d7             	mov    %al,-0x29(%ebp)
 970:	e8 cd fe ff ff       	call   842 <write>

  while(--i >= 0)
 975:	83 c4 10             	add    $0x10,%esp
 978:	39 de                	cmp    %ebx,%esi
 97a:	75 e4                	jne    960 <printint+0x60>
    putc(fd, buf[i]);
}
 97c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 97f:	5b                   	pop    %ebx
 980:	5e                   	pop    %esi
 981:	5f                   	pop    %edi
 982:	5d                   	pop    %ebp
 983:	c3                   	ret    
 984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 988:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 98f:	eb 90                	jmp    921 <printint+0x21>
 991:	eb 0d                	jmp    9a0 <printf>
 993:	90                   	nop
 994:	90                   	nop
 995:	90                   	nop
 996:	90                   	nop
 997:	90                   	nop
 998:	90                   	nop
 999:	90                   	nop
 99a:	90                   	nop
 99b:	90                   	nop
 99c:	90                   	nop
 99d:	90                   	nop
 99e:	90                   	nop
 99f:	90                   	nop

000009a0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 9a0:	55                   	push   %ebp
 9a1:	89 e5                	mov    %esp,%ebp
 9a3:	57                   	push   %edi
 9a4:	56                   	push   %esi
 9a5:	53                   	push   %ebx
 9a6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 9a9:	8b 75 0c             	mov    0xc(%ebp),%esi
 9ac:	0f b6 1e             	movzbl (%esi),%ebx
 9af:	84 db                	test   %bl,%bl
 9b1:	0f 84 b3 00 00 00    	je     a6a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 9b7:	8d 45 10             	lea    0x10(%ebp),%eax
 9ba:	83 c6 01             	add    $0x1,%esi
  state = 0;
 9bd:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 9bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 9c2:	eb 2f                	jmp    9f3 <printf+0x53>
 9c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 9c8:	83 f8 25             	cmp    $0x25,%eax
 9cb:	0f 84 a7 00 00 00    	je     a78 <printf+0xd8>
  write(fd, &c, 1);
 9d1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 9d4:	83 ec 04             	sub    $0x4,%esp
 9d7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 9da:	6a 01                	push   $0x1
 9dc:	50                   	push   %eax
 9dd:	ff 75 08             	pushl  0x8(%ebp)
 9e0:	e8 5d fe ff ff       	call   842 <write>
 9e5:	83 c4 10             	add    $0x10,%esp
 9e8:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 9eb:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 9ef:	84 db                	test   %bl,%bl
 9f1:	74 77                	je     a6a <printf+0xca>
    if(state == 0){
 9f3:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 9f5:	0f be cb             	movsbl %bl,%ecx
 9f8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 9fb:	74 cb                	je     9c8 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 9fd:	83 ff 25             	cmp    $0x25,%edi
 a00:	75 e6                	jne    9e8 <printf+0x48>
      if(c == 'd'){
 a02:	83 f8 64             	cmp    $0x64,%eax
 a05:	0f 84 05 01 00 00    	je     b10 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 a0b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 a11:	83 f9 70             	cmp    $0x70,%ecx
 a14:	74 72                	je     a88 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 a16:	83 f8 73             	cmp    $0x73,%eax
 a19:	0f 84 99 00 00 00    	je     ab8 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 a1f:	83 f8 63             	cmp    $0x63,%eax
 a22:	0f 84 08 01 00 00    	je     b30 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 a28:	83 f8 25             	cmp    $0x25,%eax
 a2b:	0f 84 ef 00 00 00    	je     b20 <printf+0x180>
  write(fd, &c, 1);
 a31:	8d 45 e7             	lea    -0x19(%ebp),%eax
 a34:	83 ec 04             	sub    $0x4,%esp
 a37:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 a3b:	6a 01                	push   $0x1
 a3d:	50                   	push   %eax
 a3e:	ff 75 08             	pushl  0x8(%ebp)
 a41:	e8 fc fd ff ff       	call   842 <write>
 a46:	83 c4 0c             	add    $0xc,%esp
 a49:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 a4c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 a4f:	6a 01                	push   $0x1
 a51:	50                   	push   %eax
 a52:	ff 75 08             	pushl  0x8(%ebp)
 a55:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 a58:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 a5a:	e8 e3 fd ff ff       	call   842 <write>
  for(i = 0; fmt[i]; i++){
 a5f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 a63:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 a66:	84 db                	test   %bl,%bl
 a68:	75 89                	jne    9f3 <printf+0x53>
    }
  }
}
 a6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 a6d:	5b                   	pop    %ebx
 a6e:	5e                   	pop    %esi
 a6f:	5f                   	pop    %edi
 a70:	5d                   	pop    %ebp
 a71:	c3                   	ret    
 a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 a78:	bf 25 00 00 00       	mov    $0x25,%edi
 a7d:	e9 66 ff ff ff       	jmp    9e8 <printf+0x48>
 a82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 a88:	83 ec 0c             	sub    $0xc,%esp
 a8b:	b9 10 00 00 00       	mov    $0x10,%ecx
 a90:	6a 00                	push   $0x0
 a92:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 a95:	8b 45 08             	mov    0x8(%ebp),%eax
 a98:	8b 17                	mov    (%edi),%edx
 a9a:	e8 61 fe ff ff       	call   900 <printint>
        ap++;
 a9f:	89 f8                	mov    %edi,%eax
 aa1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 aa4:	31 ff                	xor    %edi,%edi
        ap++;
 aa6:	83 c0 04             	add    $0x4,%eax
 aa9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 aac:	e9 37 ff ff ff       	jmp    9e8 <printf+0x48>
 ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 ab8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 abb:	8b 08                	mov    (%eax),%ecx
        ap++;
 abd:	83 c0 04             	add    $0x4,%eax
 ac0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 ac3:	85 c9                	test   %ecx,%ecx
 ac5:	0f 84 8e 00 00 00    	je     b59 <printf+0x1b9>
        while(*s != 0){
 acb:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 ace:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 ad0:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 ad2:	84 c0                	test   %al,%al
 ad4:	0f 84 0e ff ff ff    	je     9e8 <printf+0x48>
 ada:	89 75 d0             	mov    %esi,-0x30(%ebp)
 add:	89 de                	mov    %ebx,%esi
 adf:	8b 5d 08             	mov    0x8(%ebp),%ebx
 ae2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 ae5:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 ae8:	83 ec 04             	sub    $0x4,%esp
          s++;
 aeb:	83 c6 01             	add    $0x1,%esi
 aee:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 af1:	6a 01                	push   $0x1
 af3:	57                   	push   %edi
 af4:	53                   	push   %ebx
 af5:	e8 48 fd ff ff       	call   842 <write>
        while(*s != 0){
 afa:	0f b6 06             	movzbl (%esi),%eax
 afd:	83 c4 10             	add    $0x10,%esp
 b00:	84 c0                	test   %al,%al
 b02:	75 e4                	jne    ae8 <printf+0x148>
 b04:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 b07:	31 ff                	xor    %edi,%edi
 b09:	e9 da fe ff ff       	jmp    9e8 <printf+0x48>
 b0e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 b10:	83 ec 0c             	sub    $0xc,%esp
 b13:	b9 0a 00 00 00       	mov    $0xa,%ecx
 b18:	6a 01                	push   $0x1
 b1a:	e9 73 ff ff ff       	jmp    a92 <printf+0xf2>
 b1f:	90                   	nop
  write(fd, &c, 1);
 b20:	83 ec 04             	sub    $0x4,%esp
 b23:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 b26:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 b29:	6a 01                	push   $0x1
 b2b:	e9 21 ff ff ff       	jmp    a51 <printf+0xb1>
        putc(fd, *ap);
 b30:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 b33:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 b36:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 b38:	6a 01                	push   $0x1
        ap++;
 b3a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 b3d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 b40:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 b43:	50                   	push   %eax
 b44:	ff 75 08             	pushl  0x8(%ebp)
 b47:	e8 f6 fc ff ff       	call   842 <write>
        ap++;
 b4c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 b4f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 b52:	31 ff                	xor    %edi,%edi
 b54:	e9 8f fe ff ff       	jmp    9e8 <printf+0x48>
          s = "(null)";
 b59:	bb 48 0e 00 00       	mov    $0xe48,%ebx
        while(*s != 0){
 b5e:	b8 28 00 00 00       	mov    $0x28,%eax
 b63:	e9 72 ff ff ff       	jmp    ada <printf+0x13a>
 b68:	66 90                	xchg   %ax,%ax
 b6a:	66 90                	xchg   %ax,%ax
 b6c:	66 90                	xchg   %ax,%ax
 b6e:	66 90                	xchg   %ax,%ax

00000b70 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b70:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b71:	a1 bc 11 00 00       	mov    0x11bc,%eax
{
 b76:	89 e5                	mov    %esp,%ebp
 b78:	57                   	push   %edi
 b79:	56                   	push   %esi
 b7a:	53                   	push   %ebx
 b7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 b7e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b88:	39 c8                	cmp    %ecx,%eax
 b8a:	8b 10                	mov    (%eax),%edx
 b8c:	73 32                	jae    bc0 <free+0x50>
 b8e:	39 d1                	cmp    %edx,%ecx
 b90:	72 04                	jb     b96 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b92:	39 d0                	cmp    %edx,%eax
 b94:	72 32                	jb     bc8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b96:	8b 73 fc             	mov    -0x4(%ebx),%esi
 b99:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 b9c:	39 fa                	cmp    %edi,%edx
 b9e:	74 30                	je     bd0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 ba0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 ba3:	8b 50 04             	mov    0x4(%eax),%edx
 ba6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 ba9:	39 f1                	cmp    %esi,%ecx
 bab:	74 3a                	je     be7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 bad:	89 08                	mov    %ecx,(%eax)
  freep = p;
 baf:	a3 bc 11 00 00       	mov    %eax,0x11bc
}
 bb4:	5b                   	pop    %ebx
 bb5:	5e                   	pop    %esi
 bb6:	5f                   	pop    %edi
 bb7:	5d                   	pop    %ebp
 bb8:	c3                   	ret    
 bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bc0:	39 d0                	cmp    %edx,%eax
 bc2:	72 04                	jb     bc8 <free+0x58>
 bc4:	39 d1                	cmp    %edx,%ecx
 bc6:	72 ce                	jb     b96 <free+0x26>
{
 bc8:	89 d0                	mov    %edx,%eax
 bca:	eb bc                	jmp    b88 <free+0x18>
 bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 bd0:	03 72 04             	add    0x4(%edx),%esi
 bd3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 bd6:	8b 10                	mov    (%eax),%edx
 bd8:	8b 12                	mov    (%edx),%edx
 bda:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 bdd:	8b 50 04             	mov    0x4(%eax),%edx
 be0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 be3:	39 f1                	cmp    %esi,%ecx
 be5:	75 c6                	jne    bad <free+0x3d>
    p->s.size += bp->s.size;
 be7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 bea:	a3 bc 11 00 00       	mov    %eax,0x11bc
    p->s.size += bp->s.size;
 bef:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 bf2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 bf5:	89 10                	mov    %edx,(%eax)
}
 bf7:	5b                   	pop    %ebx
 bf8:	5e                   	pop    %esi
 bf9:	5f                   	pop    %edi
 bfa:	5d                   	pop    %ebp
 bfb:	c3                   	ret    
 bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000c00 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 c00:	55                   	push   %ebp
 c01:	89 e5                	mov    %esp,%ebp
 c03:	57                   	push   %edi
 c04:	56                   	push   %esi
 c05:	53                   	push   %ebx
 c06:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c09:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 c0c:	8b 15 bc 11 00 00    	mov    0x11bc,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c12:	8d 78 07             	lea    0x7(%eax),%edi
 c15:	c1 ef 03             	shr    $0x3,%edi
 c18:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 c1b:	85 d2                	test   %edx,%edx
 c1d:	0f 84 9d 00 00 00    	je     cc0 <malloc+0xc0>
 c23:	8b 02                	mov    (%edx),%eax
 c25:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 c28:	39 cf                	cmp    %ecx,%edi
 c2a:	76 6c                	jbe    c98 <malloc+0x98>
 c2c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 c32:	bb 00 10 00 00       	mov    $0x1000,%ebx
 c37:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 c3a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 c41:	eb 0e                	jmp    c51 <malloc+0x51>
 c43:	90                   	nop
 c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c48:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 c4a:	8b 48 04             	mov    0x4(%eax),%ecx
 c4d:	39 f9                	cmp    %edi,%ecx
 c4f:	73 47                	jae    c98 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c51:	39 05 bc 11 00 00    	cmp    %eax,0x11bc
 c57:	89 c2                	mov    %eax,%edx
 c59:	75 ed                	jne    c48 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 c5b:	83 ec 0c             	sub    $0xc,%esp
 c5e:	56                   	push   %esi
 c5f:	e8 46 fc ff ff       	call   8aa <sbrk>
  if(p == (char*)-1)
 c64:	83 c4 10             	add    $0x10,%esp
 c67:	83 f8 ff             	cmp    $0xffffffff,%eax
 c6a:	74 1c                	je     c88 <malloc+0x88>
  hp->s.size = nu;
 c6c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 c6f:	83 ec 0c             	sub    $0xc,%esp
 c72:	83 c0 08             	add    $0x8,%eax
 c75:	50                   	push   %eax
 c76:	e8 f5 fe ff ff       	call   b70 <free>
  return freep;
 c7b:	8b 15 bc 11 00 00    	mov    0x11bc,%edx
      if((p = morecore(nunits)) == 0)
 c81:	83 c4 10             	add    $0x10,%esp
 c84:	85 d2                	test   %edx,%edx
 c86:	75 c0                	jne    c48 <malloc+0x48>
        return 0;
  }
}
 c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 c8b:	31 c0                	xor    %eax,%eax
}
 c8d:	5b                   	pop    %ebx
 c8e:	5e                   	pop    %esi
 c8f:	5f                   	pop    %edi
 c90:	5d                   	pop    %ebp
 c91:	c3                   	ret    
 c92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 c98:	39 cf                	cmp    %ecx,%edi
 c9a:	74 54                	je     cf0 <malloc+0xf0>
        p->s.size -= nunits;
 c9c:	29 f9                	sub    %edi,%ecx
 c9e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 ca1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 ca4:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 ca7:	89 15 bc 11 00 00    	mov    %edx,0x11bc
}
 cad:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 cb0:	83 c0 08             	add    $0x8,%eax
}
 cb3:	5b                   	pop    %ebx
 cb4:	5e                   	pop    %esi
 cb5:	5f                   	pop    %edi
 cb6:	5d                   	pop    %ebp
 cb7:	c3                   	ret    
 cb8:	90                   	nop
 cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 cc0:	c7 05 bc 11 00 00 c0 	movl   $0x11c0,0x11bc
 cc7:	11 00 00 
 cca:	c7 05 c0 11 00 00 c0 	movl   $0x11c0,0x11c0
 cd1:	11 00 00 
    base.s.size = 0;
 cd4:	b8 c0 11 00 00       	mov    $0x11c0,%eax
 cd9:	c7 05 c4 11 00 00 00 	movl   $0x0,0x11c4
 ce0:	00 00 00 
 ce3:	e9 44 ff ff ff       	jmp    c2c <malloc+0x2c>
 ce8:	90                   	nop
 ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 cf0:	8b 08                	mov    (%eax),%ecx
 cf2:	89 0a                	mov    %ecx,(%edx)
 cf4:	eb b1                	jmp    ca7 <malloc+0xa7>
