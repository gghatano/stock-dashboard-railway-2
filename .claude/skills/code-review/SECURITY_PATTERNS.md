# セキュリティレビューパターン

## 認証・認可

```python
# ❌ 悪い例
@app.route('/admin')
def admin():
    return render_template('admin.html')

# ✅ 良い例
@app.route('/admin')
@require_admin
def admin():
    return render_template('admin.html')
```

## 入力検証（SQLインジェクション）

```javascript
// ❌ 悪い例
const userId = req.query.id;
db.query(`SELECT * FROM users WHERE id = ${userId}`);

// ✅ 良い例
const userId = parseInt(req.query.id, 10);
if (isNaN(userId)) {
  throw new ValidationError('Invalid user ID');
}
db.query('SELECT * FROM users WHERE id = ?', [userId]);
```

## 機密情報のログ出力

```python
# ❌ 悪い例
logger.info(f"User logged in: {username}, password: {password}")

# ✅ 良い例
logger.info(f"User logged in: {username}")
```

## XSS対策

```javascript
// ❌ 悪い例
element.innerHTML = userInput;

// ✅ 良い例
element.textContent = userInput;
// または
element.innerHTML = DOMPurify.sanitize(userInput);
```

## パスワード保存

```python
# ❌ 悪い例
user.password = plain_password

# ✅ 良い例
user.password_hash = bcrypt.hashpw(plain_password, bcrypt.gensalt())
```
