# テストパターン

## Python (pytest)

### 基本構造
```python
import pytest
from app.services.user_service import UserService

class TestUserService:
    """UserServiceのテスト"""

    @pytest.fixture
    def service(self, mock_repository):
        return UserService(repository=mock_repository)

    def test_create_user_success(self, service):
        """正常系: ユーザー作成成功"""
        user = service.create("test", "test@example.com")

        assert user.name == "test"
        assert user.email == "test@example.com"

    def test_create_user_invalid_email(self, service):
        """異常系: 不正なメールアドレス"""
        with pytest.raises(ValidationError):
            service.create("test", "invalid-email")
```

### フィクスチャ
```python
@pytest.fixture
def mock_repository(mocker):
    repo = mocker.Mock(spec=UserRepository)
    repo.exists_by_email.return_value = False
    return repo

@pytest.fixture
def sample_user():
    return User(id=1, name="test", email="test@example.com")
```

### パラメータ化
```python
@pytest.mark.parametrize("email,expected", [
    ("valid@example.com", True),
    ("invalid", False),
    ("", False),
])
def test_validate_email(email, expected):
    assert validate_email(email) == expected
```

## JavaScript (Jest + React Testing Library)

### コンポーネントテスト
```javascript
import { render, screen, fireEvent } from '@testing-library/react';
import { UserList } from './UserList';

describe('UserList', () => {
  const mockUsers = [
    { id: '1', name: 'User 1' },
    { id: '2', name: 'User 2' },
  ];

  test('ユーザー一覧が表示される', () => {
    render(<UserList users={mockUsers} onSelect={() => {}} />);

    expect(screen.getByText('User 1')).toBeInTheDocument();
    expect(screen.getByText('User 2')).toBeInTheDocument();
  });

  test('ユーザークリックでonSelectが呼ばれる', () => {
    const handleSelect = jest.fn();
    render(<UserList users={mockUsers} onSelect={handleSelect} />);

    fireEvent.click(screen.getByText('User 1'));

    expect(handleSelect).toHaveBeenCalledWith('1');
  });
});
```

### 非同期テスト
```javascript
import { waitFor } from '@testing-library/react';

test('データ取得後に表示される', async () => {
  render(<UserList />);

  await waitFor(() => {
    expect(screen.getByText('User 1')).toBeInTheDocument();
  });
});
```

### モック
```javascript
jest.mock('../services/userApi', () => ({
  userApi: {
    getAll: jest.fn().mockResolvedValue([
      { id: '1', name: 'User 1' },
    ]),
  },
}));
```

## テスト命名規則

| パターン | 例 |
|---------|-----|
| 正常系 | `test_create_user_success` |
| 異常系 | `test_create_user_invalid_email` |
| 境界値 | `test_create_user_max_length_name` |
| 状態 | `test_login_when_already_logged_in` |

## カバレッジ目標

- 全体: 80%以上
- ビジネスロジック: 90%以上
- ユーティリティ: 100%
