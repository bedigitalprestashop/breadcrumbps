{*
* 2007-2015 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author PrestaShop SA <contact@prestashop.com>
*  @copyright  2007-2015 PrestaShop SA
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*}

{if isset($smarty.capture.path)}{assign var='path' value=$smarty.capture.path}{/if}

{if !empty($path)}
  {* Extract bradcrumb links from anchors *}
  {$matchCount = preg_match_all('/<a.+?href="(.+?)"[^>]*>([^<]*)<\/a>/', $path, $matches)}
  {$breadcrumbs = []}
  {for $i=0; $i<$matchCount; $i++}
    {$breadcrumbs[] = ['url' => $matches[1][$i], 'title' => $matches[2][$i]]}
  {/for}

  {* Extract the last breadcrumb which is not link, it's plain text or text inside span *}
  {$match = preg_match('/>([^<]+)(?:<\/\w+>\s*)?$/', $path, $matches)}
  {if !empty($matches[1])}
    {$breadcrumbs[] = ['url' => '', 'title' => $matches[1]]}
  {elseif !$match && !$matchCount}
    {$breadcrumbs[] = ['url' => '', 'title' => $path]}
  {/if}
{/if}

<ol class="breadcrumb" itemscope itemtype="http://schema.org/BreadcrumbList">
  <li itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem">
    <a href="{if isset($force_ssl) && $force_ssl}{$base_dir_ssl}{else}{$base_dir}{/if}" title="{l s='Home Page'}" itemprop="item">
      <span itemprop="name">{l s='Home'}</span>
    </a>
    <meta itemprop="position" content="1" />
  </li>
  {if !empty($breadcrumbs)}
    {foreach from=$breadcrumbs item=breadcrumb name=crumbs}
      <li itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem">
        {if !empty($breadcrumb.url)}
          <a href="{$breadcrumb.url}" itemprop="item">
            <span itemprop="name">{$breadcrumb.title}</span>
          </a>
        {else}
          <span itemprop="name">{$breadcrumb.title}</span>
        {/if}
        <meta itemprop="position" content="{($smarty.foreach.crumbs.iteration|intval + 1)}" />
      </li>
    {/foreach}
  {/if}
</ol>

{if isset($smarty.get.search_query) && isset($smarty.get.results) && $smarty.get.results > 1 && isset($smarty.server.HTTP_REFERER)}
  <nav>
    <ul class="pager">
      <li class="previous">
        {capture}{if isset($smarty.get.HTTP_REFERER) && $smarty.get.HTTP_REFERER}{$smarty.get.HTTP_REFERER}{elseif isset($smarty.server.HTTP_REFERER) && $smarty.server.HTTP_REFERER}{$smarty.server.HTTP_REFERER}{/if}{/capture}
        <a href="{$smarty.capture.default|escape:'html':'UTF-8'|secureReferrer|regex_replace:'/[\?|&]content_only=1/':''}" name="back">
          <span>&larr; {l s='Back to Search results for "%s" (%d other results)' sprintf=[$smarty.get.search_query,$smarty.get.results]}</span>
        </a>
      </li>
    </ul>
  </nav>
{/if}
