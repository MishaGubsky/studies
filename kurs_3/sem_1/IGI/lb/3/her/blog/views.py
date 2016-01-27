from django.contrib import auth
from django.contrib.auth.decorators import login_required
from django.contrib.auth.forms import UserCreationForm
from django.shortcuts import render, get_object_or_404, redirect
from blog.forms import *
from .models import *


def post_list(request):
	posts = Post.objects.all()  # Post.objects.filter(published_date__lte=datetime.now()).order_by('published_date')
	return render(request, 'post_list.html', {'posts': posts})


def post_detail(request, pk):
	post = get_object_or_404(Post, pk=pk)
	return render(request, 'post_detail.html', {'post': post})


@login_required
def post_new(request):
	if request.method == "POST":
		form = PostForm(request.POST)
		if form.is_valid():
			post = form.save(commit=False)
			post.author = request.user
			post.published_date = datetime.datetime.now()
			post.save()
			return redirect('blog.views.post_detail', pk=post.pk)
	else:
		form = PostForm()
	return render(request, 'post_edit.html', {'form': form})


@login_required
def post_edit(request, pk):
	post = get_object_or_404(Post, pk=pk)
	if (request.user == post.author or request.user.is_superuser) and post:
		if request.method == "POST":
			form = PostForm(request.POST, instance=post)
			if form.is_valid():
				post = form.save(commit=False)

				category = Category()
				category.post = post
				category.category = request.POST.get('category', '')
				category.save()
				# post.categories = [category]
				post.author = request.user
				post.published_date = datetime.datetime.now()
				post.save()
				return redirect('blog.views.post_detail', pk=post.pk)
		else:
			form = PostForm(instance=post)
		return render(request, 'post_edit.html', {'form': form})

	return redirect('blog.views.post_detail', pk=post.pk)


@login_required
def add_comment_to_post(request, pk):
	post = get_object_or_404(Post, pk=pk)

	if request.method == "POST":
		form = CommentForm(request.POST)
		if form.is_valid():
			comment = form.save(commit=False)
			comment.post = post
			comment.save()
			return redirect('blog.views.post_detail', pk=post.pk)
	else:
		form = CommentForm()
	return render(request, 'add_comment_to_post.html', {'form': form})


@login_required
def comment_approve(request, pk):
	comment = get_object_or_404(Comment, pk=pk)
	comment.approve()
	return redirect('blog.views.post_detail', pk=comment.post.pk)


@login_required
def comment_remove(request, pk):
	comment = get_object_or_404(Comment, pk=pk)
	if comment:
		post_pk = comment.post.pk
		comment.delete()
		return redirect('blog.views.post_detail', pk=post_pk)
	else:
		return redirect('blog.views.post_detail', pk=comment.post.pk)


def registration(request):
	if request.POST:
		form = UserCreationForm(request.POST)
		if form.is_valid():
			form.save()
			new_user = auth.authenticate(username=form.cleaned_data['username'],
			                             password=form.cleaned_data['password1'])
			auth.login(request, new_user)
			return redirect('/')
	else:
		form = UserCreationForm()
	if request.GET:
		return redirect('/')
	return render(request, 'register.html', {'form': form})


def login(request):
	if request.POST:
		user_name = request.POST.get('username', '')
		user_pass = request.POST.get('password', '')
		user = auth.authenticate(username=user_name, password=user_pass)
		if user is not None:
			auth.login(request, user)
			return redirect('/')
		else:
			return render(request, 'login.html', {'login_error': "User not found"})
	return render(request, 'login.html', {})


def logout(request):
	auth.logout(request)
	return redirect("/")


@login_required
def add_like(request, pk):
	post = get_object_or_404(Post, pk=pk)
	like = Like()
	like.author = request.user
	like.post = post
	like.save()
	return redirect('blog.views.post_detail', pk=pk)


@login_required
def add_dislike(request, pk):
	post = get_object_or_404(Post, pk=pk)
	dislike = Dislike()
	dislike.author = request.user
	dislike.post = post
	dislike.save()
	return redirect('blog.views.post_detail', pk=pk)


def add_category(request, pk):
	post = get_object_or_404(Post, pk=pk)
	if post and post.author == request.user:
		form = Category(request.POST)
		post.category = form
		post.save()
	return post
