<p><strong>shCore.js</strong> is the main file of the SyntaxHighlighter and <strong>must be included on the page before any
other SyntaxHighlighter files</strong>. Failure to do so will result in JavaScript errors on the page. Please
see <a href="../installation.html">usage instructions</a> for details.</p>
<div class="autoinclude" markdown="1">
    &lt;% path = sh_pub_script(&#39;shCore.js&#39;) %&gt;
    <a href="%= path %">&lt;%= path %&gt;</a>
</div>

<p>&lt;%= render(:partial =&gt; &quot;/SyntaxHighlighter/partials/files&quot;) %&gt;</p>
