<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<h1 class="p-4 text-center">회원 가입</h1>

<div class="d-flex justify-content-center align-items-center">
	<div class="col-4">
		
		<form id="signUpForm" method="post" action="/user/sign_up_for_submit">
			<label for="loginId" class="m-0 font-weight-bold">아이디</label>
			<div class="d-flex">
				<input type="text" id="loginId" name="loginId" class="form-control mr-2">
				<button type="button" id="loginIdCheckBtn" class="btn btn-danger">
					중복확인
				</button>
			</div>
			<div id="idCheckLength" class="small text-danger d-none">
				ID를 4자 이상 입력해주세요.
			</div>
			<div id="idCheckBlank" class="small text-danger d-none">
				ID에 공백이 포함될 수 없습니다.
			</div>
			<div id="idCheckDuplicated" class="small text-danger d-none">
				이미 사용중인 ID 입니다.
			</div>
			<div id="idCheckOk" class="small text-success d-none">
				사용가능한 ID 입니다.
			</div>

			<label for="password" class="m-0 mt-2 font-weight-bold">비밀번호</label> 
			<input type="password" id="password" name="password" class="form-control"> 
			
			<label for="confirmPassword" class="m-0 mt-2 font-weight-bold">비밀번호 확인</label> 
			<input type="password" id="confirmPassword" name="confirmPassword" class="form-control">

			<label for="name" class="m-0 mt-2 font-weight-bold">이름</label> 
			<input type="text" id="name" name="name" class="form-control">

			<label for="email" class="m-0 mt-2 font-weight-bold">이메일 주소</label> 
			<input type="text" id="email" name="email" class="form-control">

			<button type="submit" id="signUpBtn" class="btn btn-primary w-100 mt-3">회원가입</button>
		</form>
	</div>
</div>


<script>
	$(document).ready(function() {
		// 아이디 중복확인
		$('#loginIdCheckBtn').on('click', function() {
			// validation
			let loginId = $('#loginId').val().trim();
			// ID가 4자 이상이 아니면 경고 문구 노출
			if (loginId.length < 4) {
				// idCheckLength -> d-none remove
				// idCheckDuplicated -> d-none add
				// idCheckOk -> d-none add
				$('#idCheckLength').removeClass('d-none'); // 4자 이상 입력 경고 문구 노출
				$('#idCheckDuplicated').addClass('d-none'); // 숨김
				$('#idCheckOk').addClass('d-none'); // 숨김
				return;
			}
			// ID에 공백이 포함되어 있으면 경고 문구 노출
			if (loginId.length != $('#loginId').val()) {
				$('#idCheckBlank').removeClass('d-none');
				return;
			}

			// 중복 확인 여부는 DB를 조회해야 하므로 서버에 묻는다.
			// 화면을 이동시키지 않고 AJAX 통신으로 중복 여부 확인하고
			// 동적으로 문구 노출
			$.ajax({
				url : '/user/is_duplicated_id',
				type : 'get',
				data : {
					'loginId' : loginId
				},
				success : function(data) {
					if (data.result) { // 중복인 경우
						$('#idCheckDuplicated').removeClass('d-none'); // 중복 경고 문구 노출
						$('#idCheckLength').addClass('d-none'); // 숨김
						$('#idCheckBlank').addClass('d-none'); // 숨김
						$('#idCheckOk').addClass('d-none'); // 숨김
					} else { // 사용 가능한 경우
						$('#idCheckOk').removeClass('d-none'); // 사용 가능 문구 노출
						$('#idCheckDuplicated').addClass('d-none'); // 숨김
						$('#idCheckLength').addClass('d-none'); // 숨김
						$('#idCheckBlank').addClass('d-none'); // 숨김
					}
				},
				error : function(e) {
					alert("아이디 중복확인에 실패했습니다. 관리자에게 문의해주세요.");
				}
			});
		});

		// 회원가입 버튼 동작
		$('#signUpForm').submit(function(e) {
			e.preventDefault(); // submit의 기본 동작을 중단시킴

			// validation
			let loginId = $('#loginId').val();
			if (loginId == '') {
				alert("아이디를 입력하세요");
				return;
			}

			let password = $('#password').val();
			let confirmPassword = $('#confirmPassword').val();
			if (password == '' || confirmPassword == '') {
				alert("비밀번호를 입력하세요");
				return;
			}

			// 비밀번호 확인 일치 여부
			if (password != confirmPassword) {
				alert("비밀번호가 일치하지 않습니다. 다시 입력하세요.");

				// 텍스트 초기화
				$('#password').val('');
				$('#confirmPassword').val('');
				return;
			}

			let name = $('#name').val().trim();
			if (name == '') {
				alert("이름을 입력하세요.");
				return;
			}

			let email = $('#email').val().trim();
			if (email == '') {
				alert("이메일을 입력하세요.");
				return;
			}

			// 아이디 중복확인이 완료됐는지 확인
			// -- idCheckOk -> d-none이 없으면 사용가능한 아이디라고 가정한다.
			if ($('#idCheckOk').hasClass('d-none')) {
				alert("아이디 중복확인을 해주세요.");
				return;
			}

			// 서버로 보내는 방법
			// -- 1) submit
			// -- 2) ajax

			// 1) submit -> name속성에 있는 값들이 서버로 넘어간다.(request param)
			// $(this)[0].submit(); // $(this)는 $('#signUpForm') 이것을 가리킴. // 서브밋은 서브밋 후 전체 화면을 이동시키는 경우에 사용함. 

			// 2) AJAX
			let url = '/user/sign_up_for_ajax';
			let data = $(this).serialize(); // 폼태그에 들어있는 name input(request param)이 구성된다. 만약 이것을 사용하지 않으면, data json을 임의로 구성해야 한다.
			// console.log(data);

			$.post(url, data).done(function(data) {
				if (data.result == "success") {
					alert("회원 가입을 환영합니다! 로그인을 해주세요.");
					location.href = "/user/sign_in_view";
				} else {
					alert("가입에 실패했습니다. 다시 시도해주세요.");
				}
			});
		});

	});
</script>
