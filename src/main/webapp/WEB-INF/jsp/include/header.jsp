<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="d-flex bg-primary">
	<h1 class="logo text-white font-weight-bold m-0 p-2 pl-4">MEMO</h1>
	<div class="login-info d-flex justify-content-end">
		
		<%-- 로그인이 된 경우 --%>
		<c:if test="${not empty userName}">
			<div class="mt-5">
				<span class="text-white"><b>${userName}</b>님 안녕하세요</span>
				<small><a href="/user/sign_out" id="isLoggedIn">로그아웃</a></small>
			</div>
		</c:if>
		
		<%-- 로그인이 안 된 경우 --%>
		<c:if test="${empty userName}">
			<div class="mt-5">
				<a href="/user/sign_in_view">로그인</a>
			</div>
		</c:if>
	</div>
</div>