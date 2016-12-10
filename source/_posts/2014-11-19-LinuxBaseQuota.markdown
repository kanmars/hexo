---
layout: post
title:  "[KANMARS原创] - Linux Quota简介"
desc: "这是一个Linux Quota的简介"
date: 2014-11-19 23:13:00
tags: [it,server,architecture]
---
<p>          linux  (centos) quota配置  在网络管理的工作中，由于硬盘的资源是有限的，常常需要为多用户的服务器设定用户的linux磁盘配额。这个功能对公用的多用户服务器（免费的或者收费的）来说，更是非常必要的。Quota就是在RedHatlinux下实现linux磁盘配额的工具。  quota只支持单独的挂载文件系统  不是某一个目录。 </p>
<p> </p>
<p><strong>1. 挂载目录加入 quota </strong> <br />
</p>
<table border="0" width="653">
  <tbody>
    <tr>
      <td bgcolor="#000000"><p><br />
              <span class="STYLE1"><strong>查看/home目录挂载情况 </strong> <br />
        [root@bogon ~]# <strong>df -h /home </strong> <br />
        Filesystem            Size  Used Avail Use% Mounted on<br />
        /dev/sda3             2.0G   35M  1.8G   2% /home<br />
        <br />
        [root@bogon ~]# <strong>mount | grep home </strong> <br />
        /dev/sda3 on /home type ext4 (rw)<br />
        <br />
        <strong>使用者与群组的 quota 文件系统支持参数：usrquota, grpquota </strong> <br />
        [root@bogon ~]# <strong>mount -o remount,usrquota,grpquota /home </strong> <br />
        <br />
        <strong>查看 </strong> <strong> 确定加了  usrquota,grpquota </strong> <br />
        [root@bogon ~]# <strong>mount | grep home</strong> <br />
        /dev/sda3 on /home type ext4 (rw,usrquota,grpquota)<br />
        <br />
        <strong>编辑 fstab文件让系统启动时挂载quota</strong> <br />
        [root@bogon ~]# <strong>vi /etc/fstab    </strong> <strong> 重启后生效</strong> <br />
        LABEL=/home   /home  ext4   defaults,usrquota,grpquota  1 2 </span></p>
          <p class="STYLE1"><strong>重新挂载<br />
            </strong> [root@bogon ~]# <strong>umount /home<br />
            </strong> [root@bogon ~]# <strong>mount -a<br />
        </strong> [root@bogon ~]# <strong>mount | grep home </strong> </p></td>
    </tr>
  </tbody>
</table>
<p><br />
    <br />
  <strong>2. quota安装  </strong> <strong> 生成usrquota, grpquota两个目录 </strong> <br />
</p>
<table border="0" width="653">
  <tbody>
    <tr>
      <td bgcolor="#000000"><p><span class="STYLE1"><strong>对整个系统含有 usrquota, grpquota 参数的文件系统进行 quotacheck 扫瞄 </strong> <br />
        [root@bogon ~]# <strong>quotacheck -avug </strong> <br />
        <br />
        -bash: command not found<br />
        <br />
        [root@bogon ~]# <strong>yum install quota 安装quota </strong> <br />
        <br />
        [root@bogon ~]# <strong>quotacheck -avug</strong> <br />
        <strong>自动创建 usrquota, grpquota两个目录 </strong> <br />
        [root@bogon ~]# <strong>ll -d /home/ </strong> <br />
        -rw------- 1 root root 8192 Mar  6 11:58 /home/aquota.group<br />
        -rw------- 1 root root 9216 Mar  6 11:58 /home/aquota.user<br />
      </span></p>
          <p class="STYLE1"> </p>
        <p class="STYLE1"><strong>这时， 由于某种需要，或者在某种情况，“不得不”运行这个命令  ： </strong> </p>
        <p class="STYLE1">[root@bogon ~]# <strong>quotacheck -avug -mf </strong> </p>
        <p class="STYLE1"><strong>参数 -m[M] 意思是：强迫在“读、写”模式下检查硬盘的 quota  （有一定的“正在写”的数据丢失可能，应确保没有进程在写这个分区。建议在单用户模式下进行。）。 </strong> </p>
        <p class="STYLE1"><br />
          [root@bogon ~]# <strong>quotaon -auvg   </strong> <strong>启动 quota </strong> <br />
          /dev/sda3 [/home]: group quotas turned on<br />
      /dev/sda3 [/home]: user quotas turned on </p></td>
    </tr>
  </tbody>
</table>
<p><br />
    <br />
  <strong>3. quota限制大小设置 </strong> <br />
</p>
<table width="653" border="0" bordercolor="#000000" bgcolor="#000000">
  <tbody>
    <tr>
      <td bgcolor="#000000"><p><span class="STYLE1"><strong>myquota1账号加入quota 限制使用 在这里固定每个用户使用的磁盘大小为500M </strong> <br />
        [root@bogon ~]# <strong>useradd myquota1</strong> <br />
        [root@bogon ~]# <strong>edquota -u myquota1</strong> <br />
        Filesystem    blocks    soft    hard  inodes  soft  hard<br />
        /dev/sda3         80  500000  600000      10     0     0<br />
        <br />
        <strong>复制myquota1用户的信息给 myquota2 </strong> <br />
        [root@bogon ~]# <strong>edquota -p myquota1 -u myquota2</strong> <br />
        <br />
        [root@bogon ~]# <strong>edquota -g myquotagrp </strong> <strong>编辑myquotagrp组的总共使用大小 </strong> <br />
        Filesystem    blocks    soft     hard  inodes  soft  hard<br />
        /dev/sda3        160  10000000  12000000       20     0     0<br />
        <br />
      </span></p>
          <p><span class="STYLE1">[root@bogon ~]# <strong>edquota -t   </strong> <strong>修改宽限时间  当使用者文件超过大小时 </strong> <br />
          <br />
          [root@bogon ~]# <strong>quota -uvs myquota1 myquota2 </strong> <strong>查询使用情况 </strong> <br />
          Filesystem  blocks   quota   limit   grace   files   quota   limit   grace<br />
          /dev/sda3      80    495M    595M              10       0       0<br />
          Disk quotas for user myquota2 (uid 501):<br />
          Filesystem  blocks   quota   limit   grace   files   quota   limit   grace<br />
          /dev/sda3      80    495M    595M              10       0       0<br />
          <br />
          [root@bogon ~]# <strong>quota -gvs myquotagrp  </strong> <strong>查询myquotagrp组使用情况 </strong> <br />
          <br />
          edquota -g myquotagrp<br />
          Filesystem    blocks    soft     hard  inodes  soft  hard<br />
          /dev/sda3        160   1000M     1200M      20     0     0<br />
          <br />
          [root@bogon ~]# <strong>repquota -auvs </strong> <strong>查询所有用户使用情况 </strong> <br />
          <br />
          User            used    soft    hard  grace    used  soft  hard  grace<br />
          ----------------------------------------------------------------------<br />
          root      --      20       0       0              2     0     0<br />
          myquota1  --      32       495M    595M           10     0     0<br />
          myquota2  --      32       495M    595M           10     0     0<br />
          myquotagrp --      64      1000M   1200M          20     0     0<br />
          <br />
          Statistics:<br />
          Total blocks: 7<br />
          Data blocks: 1<br />
          Entries: 4<br />
          Used average: 4.000000</span><br />
        </p></td>
    </tr>
  </tbody>
</table>
<p><br />
    <br />
  <strong>4. quota </strong> <strong>测试 </strong> <br />
</p>
<table width="653" border="0" bordercolor="#000000" bgcolor="#000000">
  <tbody>
    <tr>
      <td bgcolor="#000000"><p><span class="STYLE1"><strong>利用 myquota1 的身份，建置一个 550MB 的大文件，并观察 quota 结果！ </strong> <br />
        [root@bogon ~]# <strong>dd if=/dev/zero of=bigfile bs=1M count=550 </strong> <br />
        [root@bogon ~]# <strong>repquota -auv </strong> <br />
        Block limits                File limits<br />
        User            used    soft    hard  grace    used  soft  hard  grace<br />
        ----------------------------------------------------------------------<br />
        myquota1  +-  556840  500000  600000 13days      11     0     0<br />
        <br />
        <strong>你可以发现 myquota1 的 grace 出现！ </strong> <br />
        <strong><br />
          再创建另外一个大文件，让总容量超过 600M ！ </strong> <br />
        [root@bogon ~]# <strong>dd if=/dev/zero of=bigfile2 bs=1M count=600</strong> <br />
        du -sk<br />
        600000  .  <strong>文件大小已经查过了设置的大小  操作失败 </strong> <br />
        <br />
        [root@bogon ~]# <strong>warnquota  </strong> <strong>查看是否有警告信息 </strong> </span></p>
          <p class="STYLE1"> </p>
        <p class="STYLE1"> </p>
        <p class="STYLE1"><strong>您如果要取消磁盘空间的限制,可用以下命令，请看:</strong> <br />
          [root@bogon ~]# <strong> quotaoff /home </strong> <strong>（取消磁盘空间限制。） </strong> <br />
      [root@bogon ~]# <strong>quotaon /home </strong> <strong>（现在启动磁盘空间限制。） </strong> </p></td>
    </tr>
  </tbody>
</table>
<p>&nbsp;</p>
<blockquote>&nbsp;</blockquote>
