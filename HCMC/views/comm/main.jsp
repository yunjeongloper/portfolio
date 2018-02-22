<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="t"%>
<fmt:requestEncoding value="UTF-8" />
<html>

<!-- head -->
<div id="head">
	<t:insertAttribute name="head" />
</div>
<body>
	<div class="body-wrapper">
		<!-- header -->
		<t:insertAttribute name="header" />
		<!-- body  -->
		<div style="margin-top: 60px; height: 50%;">
			<t:insertAttribute name="body" />
		</div>
		<!-- bottom -->
		<t:insertAttribute name="bottom" />
	</div>
</body>

   <!-- Bootstrap -->
	<script src="assets/js/webtoolkit.base64.js"></script>
	<script src="assets/lib/bootstrap/js/bootstrap.min.js"></script>
	<!-- Lightbox -->
	<script src="assets/lib/lightbox2-master/dist/js/lightbox.min.js"></script>
	<!-- Typing Effect -->
	<script src="assets/lib/typed.js-master/dist/typed.min.js"></script>
	<!-- Dragging Scroll to Listing Gallery -->
	<script src="assets/lib/jquery.dragscroll.js"></script>
	<!-- Horizontal Mousewheel Scroll to Listing Gallery -->
	<script src="assets/lib/jquery-mousewheel-master/jquery.mousewheel.min.js"></script>
	<!-- Listing Filter -->
	<script src="assets/lib/bootstrap-select-master/js/bootstrap-select.js"></script>
	<!-- To Self Hosted Hero Video -->
	<script src="assets/lib/bideo.js-master/bideo.js"></script>
	<!-- Map -->
	<script src="assets/lib/Leaflet-1.0.2/build/deps.js"></script>
	<script src="assets/lib/Leaflet-1.0.2/debug/leaflet-include.js"></script>
	<script src="assets/js/map-markers-samples/sampleMapSingleListingMarker.js"></script>
	<script src="assets/js/map-markers-samples/sampleMapContactMarker.js"></script>
	<script src="assets/js/map-markers-samples/sampleMapListingMarkers.js"></script>	
    
    
    <!-- Daum map -->
    <script type="text/javascript" src="//apis.daum.net/maps/maps3.js?apikey=10d44bdc22885a555686cd67fdb5b69b&libraries=services,clusterer"></script>
    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9] for blog-option>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
    <!--[if lt IE 9] for cities-option>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
    <!--[if lt IE 9] for contact, fag, forgot-password, etc...>
      <script src="assets/lib/html5shiv-master/dist/html5shiv.min.js"></script>
      <script src="assets/lib/Respond-master/dest/respond.min.js"></script>
    <![endif]-->

<script>
	$(document).ready(function() {
		
		console.log("layout");
	})
</script>

</html>