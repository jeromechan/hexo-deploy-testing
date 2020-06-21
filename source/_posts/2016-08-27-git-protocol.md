---
layout: post
title: "Git使用规范"
date: 2016-08-27 09:00:00
description: "Git使用规范,Git协议"
keywords: "git protocol"
permalink: /2016/08/27/git-protocol/
categories:
- 工具环境
tags:
- protocol
- specification
---

> 以下是关于源代码版本控制的一些共通的约定、协议。

#### 一、管理仓库

* 避免将自己开发环境中的内容添加到版本控制系统中；
* 每当merge完成之后，删除本地以及远程的相应的特性分支；
* 只在特性分支中完成编码工作；
* 经常性的执行Rebase，使得upstream的变更及时合并到本地内容中；
* 发起pull request，使得代码得以他人评审。

#### 二、在特性分支工作

基于master，在本地创建特性分支。

```
git checkout master
git pull
git checkout -b <branch-name>
```

经常性的执行Rebase，使得upstream的变更及时合并到本地内容中。

```
git fetch origin
git rebase origin/master
```

如果出现冲突，应在Rebase过程中及时解决。  
当特性分支编码完成、通过测试之后，这个时候，需要将内容提交到index storage，即index暂存区。

```
git add --all
```

当你完成了内容的暂存，即以上的add操作，这个时候你便可以提交它了。  

```
git status
git commit --verbose
```

这里有一个Tips，对阅读者友好的commit注释是非常必要的，例如以下，就是一则好的提交注释。  

```
Present-tense summary under 50 characters

* More information about commit (under 72 characters).
* More information about commit (under 72 characters).

http://project.management-system.com/ticket/123
```

如果你之前创建了多个commit，那么你应该使用交互式的Rebase操作，以更好地进行代码的合并，并且生成更为友好的提交注释。  

```
git rebase -i origin/master
```

代码提交完成之后，便是要将你提交的内容share给大家。

```
git push origin <branch-name>
```

这个时候，便是向你的团队小伙伴们提交pull request的时候了，请团队成员们帮忙评审自己所编写的代码。

#### 三、评审代码

邀请一个团队成员来评审自己的代码，是一个很好的发现缺陷issues的良策，还可以避免沟通上的遗漏和错误的传达。

通过pull request的评审，可以使得评审的工作不仅限于项目组的讨论会议。

另外，评审人员也可以自行作出代码变更和修改，只需要将变更内容检出到自己本地的分支。

```
git checkout <branch-name>
./bin/setup
git diff staging/master..HEAD
```

当评审人员在自己的branch上修改完毕，测试通过，提交commit并且push到远程origin分支中。  
对所有变更满意之后，就可以在pull request中备注注释：`Ready to merge`。

#### 四、代码合并

使用交互式的Rebase进行代码的衍合，在每一项衍合所产生的提交中，必要的时候将注释丰富，例如增加message`Fix whitespace`的备注。

```
git fetch origin
git rebase -i origin/master
```

倘若你force push你的commit(s)到master，倘若你所使用的平台是GitHub，那么GitHub将自动地关闭你的pull request，同时标记该pull request为"Merged"状态。

```
git push --force-with-lease origin <branch-name>
```

说到这里，可能各位看官会疑惑，为什么这里引用了`--force-with-lease`这么一个git push的option呢？  

下面介绍下这个参数是什么用途：  

```
--[no-]force-with-lease
--force-with-lease=<refname>
--force-with-lease=<refname>:<expect>
Usually, "git push" refuses to update a remote ref that is not an ancestor of the local ref used to overwrite it.

This option overrides this restriction if the current value of the remote ref is the expected value. "git push" fails otherwise.

Imagine that you have to rebase what you have already published. You will have to bypass the "must fast-forward" rule in order to replace the history you originally published with the rebased history. If somebody else built on top of your original history while you are rebasing, the tip of the branch at the remote may advance with her commit, and blindly pushing with --force will lose her work.

This option allows you to say that you expect the history you are updating is what you rebased and want to replace. If the remote ref still points at the commit you specified, you can be sure that no other people did anything to the ref. It is like taking a "lease" on the ref without explicitly locking it, and the remote ref is updated only if the "lease" is still valid.

--force-with-lease alone, without specifying the details, will protect all remote refs that are going to be updated by requiring their current value to be the same as the remote-tracking branch we have for them.

--force-with-lease=<refname>, without specifying the expected value, will protect the named ref (alone), if it is going to be updated, by requiring its current value to be the same as the remote-tracking branch we have for it.

--force-with-lease=<refname>:<expect> will protect the named ref (alone), if it is going to be updated, by requiring its current value to be the same as the specified value <expect> (which is allowed to be different from the remote-tracking branch we have for the refname, or we do not even have to have such a remote-tracking branch when this form is used).

Note that all forms other than --force-with-lease=<refname>:<expect> that specifies the expected current value of the ref explicitly are still experimental and their semantics may change as we gain experience with this feature.

"--no-force-with-lease" will cancel all the previous --force-with-lease on the command line.

-f
--force
Usually, the command refuses to update a remote ref that is not an ancestor of the local ref used to overwrite it. Also, when --force-with-lease option is used, the command refuses to update a remote ref whose current value does not match what is expected.

This flag disables these checks, and can cause the remote repository to lose commits; use it with care.

Note that --force applies to all the refs that are pushed, hence using it with push.default set to matching or with multiple push destinations configured with remote.*.push may overwrite refs other than the current branch (including local refs that are strictly behind their remote counterpart). To force a push to only one branch, use a + in front of the refspec to push (e.g git push origin +master to force a push to the master branch). See the <refspec>... section above for details.
```

以上大致的意思是指，在执行git push之时，增加`--force-with-lease`参数，可以避免覆盖其他开发者在你fetch了之后，对目标分支做了其他的更新，然后你简单的`git push -f`的操作强制覆盖了他人的commits内容。  
如果想要了解`--force-with-lease`参数更多的相关知识，可以查看这里Stack Overflow的例子: [How do I properly force a Git push?](http://stackoverflow.com/questions/5509543/how-do-i-properly-force-a-git-push)

想要查看新提交的commit(s)列表，想要查看变更的文件列表，以及合并开发分支代码到master，以下命令可以实现这些目的：

```
git log origin/master..<branch-name>

git diff --stat origin/master

git checkout master
git merge <branch-name> --ff-only
git push
```

特性分支代码既然都已然成功合并到master上，这个时候我们需要去删除特性分支，无论是本地工程目录，还是远程仓库。

```
# Delete your remote feature branch.
git push origin --delete <branch-name>

# Delete your local feature branch.
git branch --delete <branch-name>
```

#### 五、参考资料

* [Git Protocol](https://github.com/thoughtbot/guides/tree/master/protocol/git)
* [How do I properly force a Git push?](http://stackoverflow.com/questions/5509543/how-do-i-properly-force-a-git-push)

