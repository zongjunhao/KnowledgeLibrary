package com.syzc.common.kit;

import javax.sql.DataSource;

import com.jfinal.kit.PathKit;
import com.jfinal.kit.Prop;
import com.jfinal.kit.PropKit;
import com.jfinal.plugin.activerecord.dialect.MysqlDialect;
import com.jfinal.plugin.activerecord.generator.Generator;
import com.jfinal.plugin.druid.DruidPlugin;

public class _GeneratorModel {

	public static DataSource getDaraSource() {
		Prop p = PropKit.use("config.properties");
		DruidPlugin druidPlugin = new DruidPlugin(p.get("jdbcUrl"), p.get("user"), p.get("password"));
		druidPlugin.start();
		return druidPlugin.getDataSource();
	}

	public static void main(String[] args) {
		// base model 说是用的包名
		String baseModelPackageName = "com.syzc.common.model.base";
		// base model 文件保存路径
		String baseModelOutputDir = PathKit.getRootClassPath() + "/../../../src/com/syzc/common/model/base";
		// System.out.println(PathKit.getRootClassPath());D:\eclipse-workspace-jee\BookManage\WebRoot\WEB-INF\classes
		// model 所使用的包名 (MappingKit 默认使用的包名)
		String modelPackageName = "com.syzc.common.model";
		// model 文件保存路径(MappingKit 与DataDictionary 文件默认保存路径)
		String modelOutputDir = baseModelOutputDir + "/..";
		System.out.println(baseModelOutputDir);
		// 创建生成器
		Generator generator = new Generator(getDaraSource(), baseModelPackageName, baseModelOutputDir, modelPackageName,
				modelOutputDir);
		generator.setDialect(new MysqlDialect());
		// 添加不需要生成的表名
		// gernerator.addExcludedTable("adv");
		// 设置是否在 Model 中生成 dao 对象
		generator.setGenerateDaoInModel(true);
		// 设置是否生成字典文件
		generator.setGenerateDataDictionary(false);
		// 设置需要被移除的表名前缀用于生成modelName。例如表名 "osc_user"，移除前缀 "osc_"后生成的model名为
		// "User"而非 OscUser
		// gernerator.setRemovedTableNamePrefixes("t_");
		// 生成
		generator.generate();
	}
}
