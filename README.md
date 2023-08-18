# Iact3 Action

Iact3 Action是用于测试[阿里云ROS模版](https://help.aliyun.com/document_detail/370710.html)的Github Action。使用于阿里云ROS模板仓库ros-templates的Iact3-test Workflow中，用途是使用[Iact3](https://github.com/aliyun/alibabacloud-ros-tool-iact3)工具测试合并至仓库的ROS模板是否合规及是否可以成功部署。

[ros-templates](https://github.com/aliyun/ros-templates)仓库提供众多阿里云ROS模板的示例和最佳实践资源，包括资源级模板示例、综合模版示例、面向复杂场景的模板最佳实践、基于Transform语法的模板、阿里云文档模板与计算巢最佳实践模板。

Iact3 Action现提供2个版本，`iact3-action@main`版本只提供对模板的校验功能，`iact3-action@v2`版本提供模板校验与根据配置文件对模板进行部署测试的功能。Iact3部署测试所需配置文件语法可参考[此文档](https://aliyun.github.io/alibabacloud-ros-tool-iact3/#/config)。

## 使用方法
```yaml
- name: Test templates
  uses: Achillessanger/iact3-action@v2
  with:
    templates: "template1.xml template2.xml"
    access_key_id: ${{ secrets.ACCESS_KEY_ID }}
    access_key_secret: ${{ secrets.ACCESS_KEY_SECRET }}
```
### Action 输入
| 名称  | 描述                    |
|-----|-----------------------|
| templates | 以空格分割的需要测试的模板与配置文件路径  |
| access_key_id | 阿里云账户key_id           |
| access_key_secret | 阿里云账户key_secret       |

### Action 输出
* `status` - `success/fail` 代表测试模板是否全部通过Iact3 Action测试

### Action测试流程
#### 测试对象
`iact3-action@main`版本中，测试对象为输入参数`templates`中所有的ROS模板。

`iact3-action@v2`版本中，测试对象为输入参数`templates`中所有包含的ROS模板，及`templates`中包含的配置文件对应的ROS模板。当某个配置文件对应的ROS模板不存在于仓库时，将跳过对此配置文件和对应模板的测试。

#### 配置文件
`iact3-action@v2`版本中，若测试的模板的对应位置有配置文件，则会根据测试文件对模板进行部署测试。模板对应的配置文件必须满足以下条件：
* 配置文件名称需为模板名称，后缀需为`.iact3.yml`或`.iact3.yaml`
* 配置文件位置固定为在`iact3-config/`目录下和模板同路径位置处（`name.yml` 对应 `iact3-config/name.iact3.yml`` ）
* 配置文件中`project`配置项`name`需为`test-{模板名}`
* 配置文件中可以不包含`template_config:template_location`项，如包含，模版路径需使用相对ros-template仓库根目录的相对路径

#### 测试方式
`iact3-action@main`版本中，使用`iact3 validate`命令校验模板合法性。

`iact3-action@v2`版本中，对带有配置文件的模板使用`iact3 test run`命令进行部署测试，其余模板使用`iact3 validate`命令校验合法性。

#### 测试结果
Iact3 Action对pull request中涉及更改的全部模板和更改的配置文件对应的模板进行测试，如全部模板都通过测试，则输出`status=success`至workflow并返回退出状态码`0`，反之则输出`status=fail`且返回退出状态码`1`。
