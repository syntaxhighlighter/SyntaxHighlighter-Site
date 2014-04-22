<p>Allows you to make a smooth transition from the older 1.5 to the current version without having to go
back and correct already existing instances of 1.5 highlighted elements. For more information please
refer to the <a href="../upgrading.html">upgrade guide</a>.</p>
<div class="autoinclude" markdown="1">
    &lt;% path = sh_pub_script(&#39;shLegacy.js&#39;) %&gt;
    <a href="%= path %">&lt;%= path %&gt;</a>
</div>

<p>&lt;%= render(:partial =&gt; &quot;/SyntaxHighlighter/partials/files&quot;) %&gt;</p>
