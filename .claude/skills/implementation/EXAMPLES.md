# 実装例

## API エンドポイント (Python/FastAPI)

```python
from fastapi import APIRouter, Depends, HTTPException
from app.services.user_service import UserService
from app.schemas.user import UserCreate, UserResponse

router = APIRouter(prefix="/api/users", tags=["users"])

@router.post("/", response_model=UserResponse)
async def create_user(
    data: UserCreate,
    service: UserService = Depends()
) -> UserResponse:
    """ユーザーを作成する"""
    try:
        user = await service.create(data)
        return UserResponse.from_orm(user)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
```

## サービス層 (Python)

```python
from app.repositories.user_repository import UserRepository
from app.models.user import User

class UserService:
    def __init__(self, repository: UserRepository):
        self.repository = repository

    async def create(self, data: UserCreate) -> User:
        # バリデーション
        if await self.repository.exists_by_email(data.email):
            raise ValueError("メールアドレスは既に使用されています")

        # 作成
        return await self.repository.create(data)
```

## React コンポーネント

```tsx
import { useState } from 'react';
import { useUsers } from '../hooks/useUsers';

interface UserListProps {
  onSelect: (userId: string) => void;
}

export const UserList = ({ onSelect }: UserListProps) => {
  const { users, isLoading, error } = useUsers();

  if (isLoading) return <div>Loading...</div>;
  if (error) return <div>Error: {error.message}</div>;

  return (
    <ul>
      {users.map(user => (
        <li key={user.id} onClick={() => onSelect(user.id)}>
          {user.name}
        </li>
      ))}
    </ul>
  );
};
```

## カスタムフック (React)

```tsx
import { useState, useEffect } from 'react';
import { userApi } from '../services/userApi';

export const useUsers = () => {
  const [users, setUsers] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchUsers = async () => {
      try {
        const data = await userApi.getAll();
        setUsers(data);
      } catch (e) {
        setError(e);
      } finally {
        setIsLoading(false);
      }
    };
    fetchUsers();
  }, []);

  return { users, isLoading, error };
};
```

## エラーハンドリング

### Python
```python
try:
    result = await service.process(data)
except ValidationError as e:
    logger.warning(f"バリデーションエラー: {e}")
    raise HTTPException(status_code=400, detail=str(e))
except DatabaseError as e:
    logger.error(f"データベースエラー: {e}")
    raise HTTPException(status_code=500, detail="内部エラーが発生しました")
```

### JavaScript
```javascript
try {
  const result = await api.fetchData();
  return result;
} catch (error) {
  if (error.response?.status === 404) {
    return null;
  }
  console.error('データ取得エラー:', error);
  throw new Error('データの取得に失敗しました');
}
```
