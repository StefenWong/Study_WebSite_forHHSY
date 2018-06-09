<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%><!-- 判断el表达式是否为空的标准函数声明 -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %><!-- 判断el集合是否为空的声明 -->
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="com.studyplatform.web.utils.*" %>
<%@ page import="com.studyplatform.web.bean.*" %>
<%@ page import="com.studyplatform.web.system.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.*" %>
<%@ page import="com.google.gson.*" %>
<%@ page import="com.studyplatform.web.servlet.formbean.*" %>
<!-- html5 -->
<!DOCTYPE HTML>
<html>
  <head>
    <!-- 编码设置 -->
		<meta http-equiv="content-type" content="text/html;charset=UTF-8"/>
		<meta charset="utf-8"/>
		<base href="<%=basePath%>">

		<!-- 设置jsp地址栏小图标 -->
		<link rel="icon" href="<%=basePath%>images/logo_icon.ico" type="image/x-icon">
		<link rel="shortcut icon" href="<%=basePath%>images/logo_icon.ico" type="image/x-icon">
		<title>测试详解</title>
		
		<!-- 移动端兼容设置 -->
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
		<meta content="" name="description" />
		<meta content="" name="author" />  
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/plugins/owl-carousel/owl.carousel.css" />
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/plugins/owl-carousel/owl.theme.css" />
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/plugins/onescroll/css/demo.css" />
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/plugins/onescroll/css/component.css" />
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/plugins/headereffects/css/component.css">
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/plugins/headereffects/css/normalize.css" />
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/plugins/pace/pace-theme-flash.css" media="screen" />
		<!-- bootstrap支持 -->
		<link href="${pageContext.request.contextPath }/plugins/boostrapv3/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
		<link href="${pageContext.request.contextPath }/plugins/boostrapv3/css/bootstrap-theme.min.css" rel="stylesheet" type="text/css" />
		<link href="${pageContext.request.contextPath }/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
		<!-- css样式 -->
		<link href="${pageContext.request.contextPath }/css/style.css" rel="stylesheet" type="text/css" />
		<link href="${pageContext.request.contextPath }/css/magic_space.css" rel="stylesheet" type="text/css" />
		<link href="${pageContext.request.contextPath }/css/responsive.css" rel="stylesheet" type="text/css" />
		<link href="${pageContext.request.contextPath }/css/animate.css" rel="stylesheet" type="text/css" />
  </head>
  
  <body>
		<div class="main-wrapper">
			<!-- 导航栏 -->
			<div role="navigation" class="navbar navbar-default navbar-static-top">
				<div class="container">
					<div class="compressed">
						<div class="navbar-header">
							<button data-target=".navbar-collapse" data-toggle="collapse" class="navbar-toggle"
							type="button">
							<span class="sr-only">T</span> <span class="icon-bar"></span><span
							class="icon-bar"></span><span class="icon-bar"></span>
						</button>
						<a href="#" class="navbar-brand compressed">
							<img src="images/logo_black.png" alt="" data-src="images/logo_black.png"
							data-src-retina="images/logo_black.png" width="270" height="38"/></a>
						</div>
						<div class="navbar-collapse collapse">
							<ul class="nav navbar-nav navbar-right">
								<li><a href="${pageContext.request.contextPath }/default.jsp">首&nbsp;页</a></li>
								<li><a href="#">专&nbsp;业&nbsp;大&nbsp;类</a></li>
								<li><a href="#">推&nbsp;荐&nbsp;资&nbsp;源</a></li>
								<li><a href="${pageContext.request.contextPath }/app_download.jsp">移&nbsp;动&nbsp;课&nbsp;堂</a></li>
								<li><a href="${pageContext.request.contextPath }/login.jsp">登&nbsp;录/注&nbsp;册</a></li>
							</ul>
						</div>
					</div>
				</div>
			</div>
			
			<div class="section first white">
				<!-- 大标题 -->
				<div class="section grey p-t-20  p-b-20">
					<div class="container">
						<div class="row">
							<div class="col-md-6">
								<h2 class="semi-bold">
								课程测试</h2>
							</div>
						</div>
					</div>
				</div>
			</div>

            <%
                String user_answer_json = (String)request.getAttribute("user_answer_json");
                
                Gson gson = new Gson();
                JsonObject answer_json = new JsonParser().parse(user_answer_json).getAsJsonObject();
                JsonArray question_list = answer_json.get("root").getAsJsonArray();
                ArrayList<ReplayQuestion> single_questions = new ArrayList<ReplayQuestion>();
                ArrayList<ReplayQuestion> multi_questions = new ArrayList<ReplayQuestion>();
                ArrayList<ReplayQuestion> judge_questions = new ArrayList<ReplayQuestion>();
                for(JsonElement jsonElement : question_list){
                    JsonObject jo = jsonElement.getAsJsonObject();
                    ReplayQuestion question = gson.fromJson(jo, ReplayQuestion.class);
                    switch(question.getQuestion_type()){
                        case SystemCommonValue.EXAM_QUESTION_TYPE_SINGLE:
                            single_questions.add(question);
                            break;
                            
                        case SystemCommonValue.EXAM_QUESTION_TYPE_MULTI:
                            multi_questions.add(question);
                            break;
                            
                        case SystemCommonValue.EXAM_QUESTION_TYPE_JUDGE:
                            judge_questions.add(question);
                            break;
                            
                       default:
                            break;
                    }
                }
                
               /*  for(JsonElement jsonElement : user_answer_list){
                    JsonObject jo = jsonElement.getAsJsonObject();
                    String answer = gson.fromJson(jo, String.class);
                    user_answers.add(answer);
                } */
                
             %>

			<div class="container">
				<div class="white bg-white padding-30">
                <div id="testomonials" class="owl-carousel row">
                    <%  
	                    int num = 0;
	                    if(single_questions.size()!=0){
	                        for(ReplayQuestion bean:single_questions){
	                           num++;
	                           OptionBean option = bean.getOption();
	                           String stem = "第" + num + "题：" + bean.getQuestion_stem();
	                            %>  
	                                <!--题目-->
				                    <div class="item">
				                        <h4><span class="semi-bold">第<%=num %>题</span>：<%=bean.getQuestion_stem() %></h4>
				                        <div class="middle">
				                            A、<%=option.getOption_a()%><br>
				                        </div>
				                        <div class="middle">
				                            B、<%=option.getOption_b()%><br>
				                        </div>
				                        <div class="middle">
				                            C、<%=option.getOption_c()%><br>
				                        </div>
				                        <div class="middle">
				                            D、<%=option.getOption_d()%><br>
				                        </div>
				                        <br>
										<div class="middle">
											<%
											    if (bean.getUser_answer().isEmpty()) {
											%>
											<span class="semi-bold">您的答案为：<%=bean.getUser_answer()%>未填写</span><br>
											<%
											    } else {
											%>
											<span class="semi-bold">您的答案为：<%=bean.getUser_answer()%></span><br>
											<%
											    }
											%>
										</div>
				
										<div class="middle">
				                            <span class="semi-bold">正确答案为：<%=bean.getQuestion_answer()%></span><br>
				                        </div>
				                        <div class="middle">
				                            <span class="semi-bold">解析：</span><%=bean.getQuestion_analysis()%><br>
				                        </div>
				                    </div>
	                            <%                                             
	                        } 
                        }
                    %>
              </div>
            </div>
        </div>

        <div class="p-t-10 p-b-20 text-center">
        	
        </div>

        <!-- footer块 -->
        <div class="section white footer">
        	<div class="container">
        		<div class="p-t-30 p-b-50">
        			<div class="row">
        				<div class="col-md-2 col-lg-2 col-sm-2 col-xs-12 xs-m-b-20">
        					<img src="images/logo_black.png" alt="" data-src="images/logo_black.png"
        					data-src-retina="images/logo_black.png" width="119" height="22" />
        					<br />
        					<br />
        					© 知识森林网络事业部
        					<br />
        				</div>
        				<div class="col-md-4 col-lg-3 col-sm-4  col-xs-12 xs-m-b-20">
        					<address class="xs-no-padding  col-md-6 col-lg-6 col-sm-6  col-xs-12">
        						北京市 海淀区<br>
        						中关村<br>
        						中国(China)
        					</address>
        					<div class="xs-no-padding col-md-6 col-lg-6 col-sm-6">
        						<div>
        							<a href="http://www.beian.gov.cn/portal/index?token=cc32e26d-5cfa-4df2-bb3c-93484830be8d">京公安网备005xxxXxxxxx774号</a></div>
        							<a href="http://www.miitbeian.gov.cn/publish/query/indexFirst.action">京ICP备xxx0xxx2号</a>
        						</div>
        						<div class="clearfix">
        						</div>
        					</div>
        					<div class="col-md-2 col-lg-2 col-sm-2  col-xs-12 xs-m-b-20">
        						<div class="bold">
        						违法和不良信息举报电话：185-0130-1238</div>
        						<a href="javascript:">京网文[2018]XXX9-XXX9号 </a>
        					</div>
        					<div class="col-md-2 col-lg-2 col-sm-2  col-xs-12 ">
        						<div class="bold">
        						意见反馈</div>
        						<br />
        						<a href="#">联系我们</a>
        					</div>
        				</div>
        			</div>
        		</div>
        	</div>
        </div>
        <!-- jquery支持 -->
        <script type="text/javascript" src="${pageContext.request.contextPath }/js/jquery-2.1.3.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath }/plugins/boostrapv3/js/bootstrap.min.js"></script>
        <script src="${pageContext.request.contextPath }/plugins/pace/pace.min.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath }/plugins/jquery-unveil/jquery.unveil.min.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath }/plugins/owl-carousel/owl.carousel.min.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath }/plugins/modernizr.custom.js"></script>
        <script src="${pageContext.request.contextPath }/plugins/waypoints.min.js"></script>
        <script src="${pageContext.request.contextPath }/plugins/onescroll/js/classie.js"></script>
        <script src="${pageContext.request.contextPath }/plugins/onescroll/js/cbpScroller.js"></script>
        <script src="${pageContext.request.contextPath }/plugins/jquery-nicescroll/jquery.nicescroll.min.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath }/js/jquery.parallax-1.1.3.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath }/js/core.js" type="text/javascript"></script>
    </body>
</html>
