<div class="site-meta {% if theme.custom_logo.enabled %}custom-logo{% endif %}">
  {% if theme.custom_logo.image and theme.scheme === 'Muse' %}
    <div class="site-meta-headline">
      <a>
        <img class="custom-logo-image" src="{{ theme.custom_logo.image }}"
             alt="{{ config.title }}"/>
      </a>
    </div>
  {% endif %}

  <div class="custom-logo-site-title">
    <a href="{{ config.root }}"  class="brand" rel="start">
      <span class="logo-line-before"><i></i></span>
      <span class="site-title">{{ config.title }}</span>
      <span class="logo-line-after"><i></i></span>
    </a>
  </div>
  <p class="site-subtitle">{{ config.subtitle }}</p>
</div>

<div class="site-nav-toggle">
  <button>
    <span class="btn-bar"></span>
    <span class="btn-bar"></span>
    <span class="btn-bar"></span>
  </button>
</div>

<nav class="site-nav">
  {% set hasSearch = theme.swiftype_key || theme.tinysou_Key || config.search %}

  {% if theme.menu %}
    <ul id="menu" class="menu">
      {% for name, path in theme.menu %}
        {% set itemName = name.toLowerCase() %}
        <li class="menu-item menu-item-{{ itemName }}">
          <a href="{{ url_for(path) }}" rel="section">
            {% if theme.menu_icons.enable %}
              <i class="menu-item-icon fa fa-{{theme.menu_icons[itemName] || 'question-circle'}} fa-fw"></i> <br />
            {% endif %}
            {{ __('menu.' + itemName) }}
          </a>
        </li>
      {% endfor %}

      {% if hasSearch %}
        <li class="menu-item menu-item-search">
          {% if theme.swiftype_key %}
            <a href="#" class="st-search-show-outputs">
          {% elseif config.search %}
            <a href="#" class="popup-trigger">
          {% endif %}
            {% if theme.menu_icons.enable %}
              <i class="menu-item-icon fa fa-search fa-fw"></i> <br />
            {% endif %}
            {{ __('menu.search') }}
          </a>
        </li>
      {% endif %}
	  <li class="menu-item menu-item-search">
	  <a href="javascript:void(0)" id="shareThisPage_bth" rel="section">
		  <i class="menu-item-icon fa fa-thumbs-o-up fa-fw"></i> <br />
		  <span id="shareThisPage_text">分享</span>
	  </a>
	  </li>
    </ul>
  {% endif %}
	  
	  <script type="text/javascript" src="/js/jquery-1.7.1.min.js"></script>
	  <script type="text/javascript" src="/js/jquery.qrcode.min.js"></script>
	  <script type="text/javascript">
	  
	    jQuery.getScript("/js/jquery.qrcode.min.js",function(data, textStatus, jqXHR){
			// data 是该请求返回的数据(可能经过处理)
			// textStatus 可能是"success"、 "notmodified"等
			// jqXHR 是经过jQuery封装的XMLHttpRequest对象(保留其本身的所有属性和方法)
			eval(data);
			console.log("加载成功");
		});
		$("#shareThisPage_bth").toggle(function(){
			$("#shareThisPage_canvas").empty();
			
			if(typeof $("#shareThisPage_canvas").qrcode !="undefined"){
				$("#shareThisPage_canvas").qrcode({ 
					render: "canvas", //table方式 
					width: 100, //宽度 
					height:100, //高度
					correctLevel:0,
					text: window.location.href //任意内容 
				})
				$("#shareThisPage_canvas").show();
				$("#shareThisPage").show();
				$("#shareThisPage_text").text("关闭分享");
			}else{
				jQuery.getScript("/js/jquery.qrcode.min.js",function(data, textStatus, jqXHR){
					// data 是该请求返回的数据(可能经过处理)
					// textStatus 可能是"success"、 "notmodified"等
					// jqXHR 是经过jQuery封装的XMLHttpRequest对象(保留其本身的所有属性和方法)
					eval(data);
					console.log("加载成功");
					$("#shareThisPage_canvas").qrcode({ 
						render: "canvas", //table方式 
						width: 100, //宽度 
						height:100, //高度
						correctLevel:0,
						text: window.location.href //任意内容 
					})
					$("#shareThisPage_canvas").show();
					$("#shareThisPage").show();
					$("#shareThisPage_text").text("关闭分享");
				});
			}
		},function(){
			$("#shareThisPage_canvas").empty();
			$("#shareThisPage_canvas").hide();
			$("#shareThisPage").hide();
			$("#shareThisPage_text").text("分享");
		});
	  </script>
	  <div id="shareThisPage" class="site-meta" style="display:none;">
		<div id="shareThisPage_canvas" style="display:none;"></div>
	  </div>
  {% if hasSearch %}
    <div class="site-search">
      {% include 'search.swig' %}
    </div>
  {% endif %}
</nav>

