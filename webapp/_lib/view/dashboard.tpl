{include file="_header.tpl"}
{include file="_statusbar.tpl"}

<div class="container_24">
  <div class="clearfix">
    <!-- begin left nav -->
    <div class="grid_4 alpha omega">
        {if $instance}
      <div id="nav">
        <ul id="top-level-sidenav">
        {/if}
        {if $instance}
              <li{if $smarty.get.v eq ''} class="selected"{/if}>
                <a href="{$site_root_path}?u={$instance->network_username|urlencode}&n={$instance->network|urlencode}">Dashboard</a>
              </li>
        {/if}
        {if $sidebar_menu}
          {foreach from=$sidebar_menu key=smkey item=sidebar_menu_item name=smenuloop}
          {if !$sidebar_menu_item->parent}
                <li{if $smarty.get.v eq $smkey OR $parent eq $smkey} class="selected"{/if}>
                {* TODO: Remove this logic from the view *}
                {if $parent eq $smkey}{assign var="parent_name" value=$sidebar_menu_item->name}{/if}
                <a href="{$site_root_path}?v={$smkey}&u={$instance->network_username|urlencode}&n={$instance->network|urlencode}">{$sidebar_menu_item->name}</a></li>
             {/if}
            {/foreach}

        {/if}
        {if $instance}
        </ul>
      </div>
        {/if}
    </div>

    <div class="thinkup-canvas round-all grid_20 alpha omega prepend_20 append_20" style="min-height:340px">
      <div class="prefix_1 suffix_1">

        {include file="_usermessage.tpl"}
        {if $show_update_now_button eq true}
        <br>
        <a href="{$site_root_path}crawler/updatenow.php{if $developer_log}?log=full{/if}" class="linkbutton emphasized">Capture Data Now</a>
        {/if}

        {if $instance}
          {* begin public user dashboard *}
          {if $user_details}
            <div class="grid_18 alpha omega">
              <div class="clearfix alert stats round-all" id="">
                <div class="grid_2 alpha">
                  <div class="avatar-container">
                    <img src="{$user_details->avatar}" class="avatar2"/>
                    <img src="{$site_root_path}plugins/{$user_details->network|get_plugin_path}/assets/img/favicon.png" class="service-icon2"/>
                  </div>
                </div>
                <div class="grid_15 omega">
                  <span class="tweet">{$user_details->username} <span style="color:#ccc">{$user_details->network|capitalize}</span></span><br />
                  <div class="small">
                    {if $instance->crawler_last_run eq 'realtime'}<span style="color:green;">&#9679;</span> Updated in realtime{else}Updated {$instance->crawler_last_run|relative_datetime} ago{/if}{if !$instance->is_active} (paused){/if}
                  </div>
                </div>
              </div>
            </div>

          {if $data_template}
            {include file=$data_template}
          {else} {* else if no $data_template *}

              {if $instance->network eq 'foursquare'}
                 <!--  If the user has checkins from this day last year show them -->
                {if $checkins_one_year_ago|@count > 0 }
                <div class="section">
                    <h2>Remember These?</h2>
                    {foreach from=$checkins_one_year_ago item=current}
                        <div class="clearfix article"> 
                        <div class="individual-tweet post clearfix">
                        <div class="grid_5 alpha">
                        <a href="http://maps.google.co.uk/maps?q={$current->geo}"><img src="{$current->place_obj->map_image}"></a>
                        </div>    
                        <div class="grid_7"> 
                        <img src="{$current->place_obj->icon}"> {$current->place} <br> {$current->location} <br>
        
                         {foreach from=$current->links item=current_link}
                             <a href="{$current_link->url}"><img src="{$current_link->url}" width=100px height=100px}></a>
                         {/foreach}
                        </div>
                        <div class="grid_5 omega"/> {$current->post_text} <br> <br> {$current->pub_date} <br>
                        {if $current->reply_count_cache > 0}
                            <span class="reply-count">
                            <a href="{$site_root_path}post/?t={$current->post_id}&n={$current->network|urlencode}">{$current->reply_count_cache|number_format}</a></span>
                          {else}
                            &#160;
                          {/if}
                        </div>
                        </div>
                            <br>
                        </div>
                    {/foreach}
                </div>
               {/if} 
    
                {if $checkins_per_hour_last_week|@count > 3 }
                <div class="section">
                      <h2>Checkins Per Hour This Week</h2>
                      
                      <img width="680" height="280" src="https://chart.googleapis.com/chart?cht=bvs&amp;chco=7CC0D7&amp;chd=t:{foreach from=$checkins_per_hour_last_week name=foo item=lastweek}{$lastweek.counter|urlencode}{if !$smarty.foreach.foo.last}%2C{/if}{/foreach}&amp;chbh=a&amp;chxt=x,y&amp;chxl=0:|{foreach from=$checkins_per_hour_last_week name=foo item=lastweek2}{$lastweek2.hour|urlencode}{if !$smarty.foreach.foo.last}%7C{/if}{/foreach}&amp;chs=680x280&amp;chtt=Check-ins+Per+Hour+-+This+Week&amp;chds=a" >
                </div>
                {/if}
                {if $checkins_per_hour_all_time|@count > 3 }
                <div class="section">
                      <h2>Checkins Per Hour All Time</h2>
                      
                      <img width="680" height="280" src="https://chart.googleapis.com/chart?cht=bvs&amp;chco=7CC0D7&amp;chd=t:{foreach from=$checkins_per_hour_all_time name=foo item=alltime}{$alltime.counter|urlencode}{if !$smarty.foreach.foo.last}%2C{/if}{/foreach}&amp;chbh=a&amp;chxt=x,y&amp;chxl=0:|{foreach from=$checkins_per_hour_all_time name=foo item=alltime2}{$alltime2.hour|urlencode}{if !$smarty.foreach.foo.last}%7C{/if}{/foreach}&amp;chs=680x280&amp;chtt=Check-ins+Per+Hour+-+All+Time&amp;chds=a" >
                      
        
                </div>
                {/if}
                {if $checkins_by_type|@count > 0 }
                <div class="section">
                      <h2>The Types Of Places You Visit</h2>
                      
                      <img width="680" height="280" src="https://chart.googleapis.com/chart?chds=a&amp;chd=t:{foreach from=$checkins_by_type name=foo item=placecount}{$placecount.place_count|urlencode}{if !$smarty.foreach.foo.last}%2C{/if}{/foreach}&amp;cht=p&amp;chl={foreach from=$checkins_by_type name=foo item=placecount}{$placecount.place_type|urlencode}{if !$smarty.foreach.foo.last}%7C{/if}{/foreach}&amp;chtt=Types+of+Places+You+Visit&amp;chs=700x280&chco=7CC0D7,D5F0FC"> 
        
                </div>
                 {/if}
             {/if}

            {if $hot_posts_data}
                <div class="section">
                {include file="_dashboard.responserates.tpl"}
                </div>
            {/if}

            {if $least_likely_followers}
              <div class="clearfix section">
                <h2>This Week's Most Discerning Followers</h2>
                <div class="clearfix article" style="padding-top : 0px;">
                {foreach from=$least_likely_followers key=uid item=u name=foo}
                  <div class="avatar-container" style="float:left;margin:7px;">
                    <a href="https://twitter.com/intent/user?user_id={$u.user_id}" title="{$u.user_name} has {$u.follower_count|number_format} followers and {$u.friend_count|number_format} friends"><img src="{$u.avatar}" class="avatar2"/><img src="{$site_root_path}plugins/{$u.network}/assets/img/favicon.png" class="service-icon2"/></a>
                  </div>
                {/foreach}
                <br /><br /><br />
                </div>
                <div class="clearfix view-all">
                    <a href="{$site_root_path}?v=followers-leastlikely&u={$instance->network_username}&n={$instance->network}">More...</a>
                </div>
                </div>
            {/if}

            {if $click_stats_data}
                <div class="section">
                {include file="_dashboard.clickthroughrates.tpl"}
                </div>
            {/if}

            {if $most_replied_to_1wk}
              <div class="section">
                <h2>This Week's Most {if $instance->network eq 'google+'}Discussed{else}Replied-To{/if} Posts</h2>
                {foreach from=$most_replied_to_1wk key=tid item=t name=foo}
                    {if $instance->network eq "twitter"}
                        {include file="_post.counts_no_author.tpl" post=$t headings="NONE"}
                    {else}
                        {include file="_post.counts_no_author.tpl" post=$t headings="NONE" show_favorites_instead_of_retweets=true}
                    {/if}
                {/foreach}
              </div>
            {/if}

            {if $most_faved_1wk}
              <div class="section">
                <h2>This Week's Most {if $instance->network eq 'google+'}+1ed{else}Liked{/if} Posts</h2>
                {foreach from=$most_faved_1wk key=tid item=t name=foo}
                  {include file="_post.counts_no_author.tpl" post=$t headings="NONE" show_favorites_instead_of_retweets=true}
                {/foreach}
              </div>
            {/if}

            {if $follower_count_history_by_day.history && $follower_count_history_by_week.history}
                <div class="section" style="float : left; clear : none; width : 345px;">
                    {include file="_dashboard.followercountbyday.tpl"}
                </div>
                <div class="section" style="float : left; clear : none;margin-left : 16px; width : 345px;">
                    {include file="_dashboard.followercountbyweek.tpl"}
                </div>
            {/if}

            {if $least_likely_followers}
              <div class="clearfix section">
                <h2>This Week's Most Discerning Followers</h2>
                <div class="clearfix article" style="padding-top : 0px;">
                {foreach from=$least_likely_followers key=uid item=u name=foo}
                  <div class="avatar-container" style="float:left;margin:7px;">
                    <a href="https://twitter.com/intent/user?user_id={$u.user_id}" title="{$u.user_name} has {$u.follower_count|number_format} followers and {$u.friend_count|number_format} friends"><img src="{$u.avatar}" class="avatar2"/><img src="{$site_root_path}plugins/{$u.network}/assets/img/favicon.png" class="service-icon2"/></a>
                  </div>
                {/foreach}
                <br /><br /><br />    
                </div>
                <div class="clearfix view-all">
                    <a href="{$site_root_path}?v=followers-leastlikely&u={$instance->network_username}&n={$instance->network}">More..</a>
                </div>
                </div>
            {/if}

            {if $most_retweeted_1wk}
              <div class="clearfix section">
                <h2>This Week's Most {if $instance->network eq 'google+'}Reshared{else}Retweeted{/if} Posts</h2>
                {foreach from=$most_retweeted_1wk key=tid item=t name=foo}
                  {include file="_post.counts_no_author.tpl" post=$t show_favorites_instead_of_retweets=false}
                {/foreach}
              </div>
            {/if}
            {if $instance->network eq 'twitter' }
              <div class="section" style="float : left; clear : none; width : 345px;">
                {include file="_dashboard.posttypes.tpl"}
              </div>

            <div class="section" style="float : left; clear : none;margin-left : 10px; width : 345px;">
                {include file="_dashboard.clientusage.tpl"}
            </div>
            {/if}
          {/if} {* end if $data_template *}
         {/if}
        {/if}
        

        {if !$instance}
          <div style="width:60%;text-align:center;">
          {if $add_user_buttons}
          <br ><br>
            {foreach from=$add_user_buttons key=smkey item=button name=smenuloop}
                <div style="float:right;padding:5px;"><a href="{$site_root_path}account/?p={$button}" class="linkbutton emphasized">Add a {if $button eq 'googleplus'}Google+{else}{$button|ucwords}{/if} Account &rarr;</a></div>
                <div style="clear:both;">&nbsp;</div>
             {/foreach}
          {/if}
          {if $logged_in_user}
          <div style="float:right;padding:5px;"><a href="{$site_root_path}account/" class="linkbutton emphasized">Adjust Your Settings</a></div>
          {else}
          <div style="float:right;padding:5px;"><a href="{$site_root_path}session/login.php" class="linkbutton emphasized">Log In</a></div>
          {/if}
          </div>
        {/if}

      </div> <!-- /.prefix_1 -->
    </div> <!-- /.thinkup-canvas -->

  </div> <!-- /.clearfix -->
</div> <!-- /.container_24 -->

<script type="text/javascript" src="{$site_root_path}assets/js/linkify.js"></script>

{include file="_footer.tpl"}
