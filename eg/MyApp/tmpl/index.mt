<? extends 'base' ?>
<? block content => sub { ?>
<h2>Message from Config</h2>
<p><?= $message ?></p>
<h2>GET Request</h2>
<form action="/hi">
<input type="text" name="name" />
<input type="submit">
</form>
<h2>Serve Staic File</h2>
<img src="<?= $base ?>static/images/yusukebe.png" alt="yusukebe" />
<h2>Redirect</h2>
<a href="<?= $base ?>redirect">/redirect</a>
<h2>JSON</h2>
<a href="<?= $base ?>json">/json</a>
<? } ?>
