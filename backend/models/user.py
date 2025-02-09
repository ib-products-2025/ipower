from pydantic import BaseModel

class User(BaseModel):
    username: str
    password: str

class UserInDB(BaseModel):
    username: str
    password: str
    hashed_password: str
    account_id: str

class Token(BaseModel):
    access_token: str
    token_type: str