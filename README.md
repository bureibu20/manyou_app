## README ##
・User
| Name | Column |
| :-- | :-- | 
| name| string | 
| email | string | 
| password_digest | string | 

・Task
| Name | Column |
| :-- | :-- | 
| title| string | 
| content | text | 
| user_id | string | 

・Label
| Name | Column |
| :-- | :-- | 
| label_name| string | 
| tasl_id | string |

__________________________________________________________

#Herokuへのデプロイ手順#

1.Heroku CLIのインストール
```
brew tap heroku/brew && brew install heroku
```

2.Herokuにログイン
```
heroku login
```

3.~/workspace/○○_appに位置していることを確認

4.Herokuに新しいアプリケーションを作成 (heroku-20では、Ruby2.6.5がサポートの対象外なのでheroku-18で)
```
$ heroku create --remote heroku-18 --stack heroku-18
```

5.アセットプリコンパイル
```
$ rails assets:precompile RAILS_ENV=production
```

6.コミット
```
$ git add -A
$ git commit -m "＊＊＊"
```

7.Heroku buildpackを追加
```
$ heroku buildpacks:set heroku/ruby
$ heroku buildpacks:add --index 1 heroku/nodejs
```

8.Herokuにデプロイ
```
$ git push heroku-18 master
```

9.データベースの移行
```
$ heroku run rails db:migrate
```